1,198 @@
# Threat Model Template (STRIDE-per-component)

> **Source audit:** `FLEET-AUDIT-REPORT.md` — S7 (Threat model) is the #1 P0 gap (priority 42, 10 of 11 audited repos at score 0).
> **Method:** STRIDE per-component. Each component in your system gets a row; each STRIDE category is a column.
> **How to use:** Copy this file to your repo as `docs/security/threat-model.md`, fill in the rows, commit.

## When to do this

A threat model is **wired** (score 2) when this file exists in `docs/security/threat-model.md`
and is referenced from your `README.md` or `SECURITY.md`.
It's **measured** (score 3) when a CI gate fails if the file is more than 90 days old.

## STRIDE cheat sheet

| Letter | Threat | Property violated | Question to ask |
|--------|--------|-------------------|------------------|
| **S** | Spoofing | Authentication | Can an attacker impersonate a user/system? |
| **T** | Tampering | Integrity | Can an attacker modify data or code? |
| **R** | Repudiation | Non-repudiation | Can a user deny an action they took? |
| **I** | Information disclosure | Confidentiality | Can an attacker read data they shouldn't? |
| **D** | Denial of service | Availability | Can an attacker make the system unavailable? |
| **E** | Elevation of privilege | Authorization | Can an attacker gain higher privileges? |

For each cell, mark one of: **N/A** (not applicable to this component), **low** (impact minor,
mitigation optional), **med** (mitigation required), **high** (mitigation + test required).

---

## Component inventory

This repo (`cursor-reset-tools`) is a Node.js / Express service that mutates the local
Cursor IDE installation to bypass machine-id tracking. Every component below accepts
input or handles data and is in scope for STRIDE.

| # | Component | Path | Trust boundary | Notes |
|---|-----------|------|----------------|-------|
| 1 | Express HTTP server | `app.js` | Public network (loopback / LAN, port 3000) | `cors()` wide-open; no auth |
| 2 | Reset API router | `routes/reset.js` | Public network | 3 GET endpoints; mutates user filesystem |
| 3 | SQLite reader/writer | `routes/reset.js` (sqlite + sqlite3) | Filesystem (user's `state.vscdb`) | Reads + writes Cursor's main DB |
| 4 | Filesystem mutator | `routes/reset.js` (fs-extra) | User's `$HOME` | Writes `machineId`, `storage.json`, `cursor.json`, `workbench.html`, `product.json` |
| 5 | Child-process executor | `routes/reset.js` (child_process) | OS shell | Hardcoded commands; `taskkill`, `pkill`, `defaults`, `attrib`, `REG ADD`, `security` |
| 6 | Static asset server | `app.js` (`express.static`) | Public network | Serves `public/` (CSS/JS); no auth |
| 7 | EJS view renderer | `views/index.ejs` | Public network | Renders server-side; user input not interpolated |
| 8 | Build / start pipeline | `package.json`, `justfile`, `Taskfile.yml` | Local dev | `npm start`; no CI workflows present |
| 9 | GitHub Actions (CI) | `.github/workflows/` | n/a | **Not present** — no CI configured; documented as finding F1 below |
| 10 | Third-party deps | `node_modules` (express, sqlite3, fs-extra, uuid, node-fetch, get-uri, cors) | npm registry | SCA not enforced; documented as finding F2 below |

## Per-component threat grid

For each component, fill in the STRIDE table.

### Component: `<name>`

| Threat | Rating | Specific attack vector | Mitigation | Owner | Last reviewed |
|--------|--------|------------------------|------------|-------|---------------|
| **S — Spoofing** | low/med/high | | | | YYYY-MM-DD |
| **T — Tampering** | | | | | |
| **R — Repudiation** | | | | | |
| **I — Info disclosure** | | | | | |
| **D — DoS** | | | | | |
| **E — Elevation** | | | | | |

Repeat this block for every component.

---

## Worked example: cursor-reset-tools (PhenoProject)

Three components are expanded in detail below because they cover the trust boundaries
the audit flagged: the public HTTP entry point, the local domain data store (Cursor's
SQLite DB), and the build/start pipeline. CI workflows are listed as Finding F1 because
`.github/workflows/` is absent in this repo.

### Component: `cursor-reset-tools` Express HTTP server (`app.js`)

| Threat | Rating | Specific attack vector | Mitigation | Owner | Last reviewed |
|--------|--------|------------------------|------------|-------|---------------|
| **S — Spoofing** | med | Browser/LAN client impersonates the local operator (no auth) | Localhost binding by default; document LAN exposure risk; consider `origin` allowlist on `cors()` | maintainer | 2026-06-16 |
| **T — Tampering** | high | Any LAN caller can trigger `/api/reset`, `/api/patch`, `/api/paths` to mutate user's Cursor install | Add a shared-secret header or bind to `127.0.0.1`; fail-closed on missing auth | maintainer | 2026-06-16 |
| **R — Repudiation** | low | No request logging — user cannot prove which action ran when | Add a request log (timestamp + endpoint) writing to `data/audit.log`; non-repudiation is local | maintainer | 2026-06-16 |
| **I — Info disclosure** | med | `/api/paths` returns absolute paths under user's `$HOME` (CORS wide-open) | CORS allowlist; do not expose internal paths to non-local origins | maintainer | 2026-06-16 |
| **D — DoS** | low | Unbounded request rate on a single Express process | Process supervisor (`systemd` / launchd); rate limit per IP if exposed | maintainer | 2026-06-16 |
| **E — Elevation** | high | Server requires sudo / Administrator to write system files; a vuln = full host compromise | Document the elevation requirement; minimize dependency surface; remove `get-uri` SSRF risk | maintainer | 2026-06-16 |

### Component: `cursor-reset-tools` SQLite access (Cursor `state.vscdb` — "domain data store")

| Threat | Rating | Specific attack vector | Mitigation | Owner | Last reviewed |
|--------|--------|------------------------|------------|-------|---------------|
| **S — Spoofing** | N/A | Local DB; no remote auth surface | n/a | maintainer | 2026-06-16 |
| **T — Tampering** | med | Open `state.vscdb` with `sqlite3.Database`; if path is ever attacker-controlled, DB corruption / SQLi via crafted rows | Backup before write (`fs.copy` → `*.bak.<ts>` already in `bk()`); parameterize any future dynamic SQL; keep paths hardcoded from `os.homedir()` | maintainer | 2026-06-16 |
| **R — Repudiation** | low | DB edits leave no audit trail | Backup files timestamped; document rollback procedure in runbook | maintainer | 2026-06-16 |
| **I — Info disclosure** | low | DB contains Cursor session metadata (no secrets in schema) | Out of scope for personal-use tool; never ship DB contents over the network | maintainer | 2026-06-16 |
| **D — DoS** | low | Failed DB write mid-mutation leaves Cursor in inconsistent state | Backup-before-mutate pattern already in place; add a top-level try/except that restores backup on failure | maintainer | 2026-06-16 |
| **E — Elevation** | med | Code runs with whatever privileges launched the server (typically admin); DB write itself does not elevate | Out of scope — DB driver does not require elevation | maintainer | 2026-06-16 |

### Component: `cursor-reset-tools` Filesystem mutator + Build/start pipeline (`fs-extra`, `npm start`)

| Threat | Rating | Specific attack vector | Mitigation | Owner | Last reviewed |
|--------|--------|------------------------|------------|-------|---------------|
| **S — Spoofing** | N/A | Local files; no network identity | n/a | maintainer | 2026-06-16 |
| **T — Tampering** | high | Untrusted content (`storage.json`, `cursor.json`, `product.json`) is rewritten in-place; a single bad write bricks Cursor until backup restored | Always `bk()` before write; verify post-write JSON parses; rollback on exception | maintainer | 2026-06-16 |
| **R — Repudiation** | low | Writes are local; git log is the audit trail | Backups at `*.bak.<ts>` provide forensic snapshots | maintainer | 2026-06-16 |
| **I — Info disclosure** | med | `fs.writeFile(mp, machId)` writes a fresh UUID to `machineId`; no leakage | n/a — local write | maintainer | 2026-06-16 |
| **D — DoS** | med | `fs.ensureDir` + recursive writes can create directories the user did not intend | Scope all paths under `os.homedir()`; never join user-supplied input into a write path | maintainer | 2026-06-16 |
| **E — Elevation** | high | `attrib +r`, `REG ADD HKLM\\…`, `sudo defaults write` — these need root / Administrator; a bug here = full host persistence | Minimize use of elevation; never call `sudo` with interpolated user input; document that the tool must be run as the file owner, not as root, when possible | maintainer | 2026-06-16 |

### Component: `cursor-reset-tools` CI workflows (`.github/workflows/`)

| Threat | Rating | Specific attack vector | Mitigation | Owner | Last reviewed |
|--------|--------|------------------------|------------|-------|---------------|
| **S — Spoofing** | N/A | No CI configured | Finding F1 — no risk because no workflow exists | maintainer | 2026-06-16 |
| **T — Tampering** | N/A | No CI configured | Finding F1 — tracked as P1 follow-up | maintainer | 2026-06-16 |
| **R — Repudiation** | N/A | No CI configured | n/a | maintainer | 2026-06-16 |
| **I — Info disclosure** | N/A | No CI configured | n/a | maintainer | 2026-06-16 |
| **D — DoS** | N/A | No CI configured | n/a | maintainer | 2026-06-16 |
| **E — Elevation** | N/A | No CI configured | n/a | maintainer | 2026-06-16 |

### Component: `cursor-reset-tools` Third-party dependencies (`node_modules`)

| Threat | Rating | Specific attack vector | Mitigation | Owner | Last reviewed |
|--------|--------|------------------------|------------|-------|---------------|
| **S — Spoofing** | med | Typosquat on npm (e.g. `cors` vs `corss`) | Pin via `package-lock.json`; SCA gate in CI (Finding F2) | maintainer | 2026-06-16 |
| **T — Tampering** | med | Malicious post-install script in a dependency | `npm ci --ignore-scripts` in CI; review `package.json` `scripts` | maintainer | 2026-06-16 |
| **R — Repudiation** | low | Dep version drift across installs | `package-lock.json` committed (FLEET-AUDIT found 1 → 2 lift here) | maintainer | 2026-06-16 |
| **I — Info disclosure** | med | `node-fetch` / `get-uri` SSRF if ever used with untrusted URLs | Audit call sites; `get-uri` is currently a declared dep with no usage in `app.js` (F3 — unused dep) | maintainer | 2026-06-16 |
| **D — DoS** | low | Dep update breaks install | Renovate or Dependabot (none configured — F4) | maintainer | 2026-06-16 |
| **E — Elevation** | med | Post-install script runs with same privileges as `npm install` | `--ignore-scripts` for non-dev installs; document this in README | maintainer | 2026-06-16 |

---

## Findings raised by this model

| ID | Severity | Component | Finding | S7 lift impact |
|----|----------|-----------|---------|----------------|
| F1 | med | CI workflows | `.github/workflows/` is empty/absent — no automated security gate. Tracked under P1 follow-up. | Blocks S7=3 |
| F2 | med | Dependencies | No SCA / `deny.toml` / SBOM. FLEET-AUDIT noted `deny.toml` not present. | Blocks S8/SC2 lifts |
| F3 | low | Dependencies | `get-uri` declared in `package.json` but not imported in `app.js`; unused surface. | Tracked under P2 |
| F4 | low | Dependencies | No automated dependency update tool (Renovate / Dependabot). | Tracked under P2 |
| F5 | high | Express HTTP server | CORS wide-open; LAN exposure of mutating endpoints. | P0 — see Component 1, rows T & E |

---

## How to lift the S7 score

- **0 → 1 (ad-hoc):** Add a `docs/security/threat-model.md` with at least one component's STRIDE table.
- **1 → 2 (wired):** Reference the threat model from `README.md` and `SECURITY.md`. Cover at least 80% of your components. Add an owner + last-reviewed column to each row.
- **2 → 3 (measured):** Add a CI gate that fails if `docs/security/threat-model.md` is older than 90 days, OR if a previously-scored component row is deleted.

## Review cadence

Review the threat model:
- **On every major release** (semver minor)
- **On any new external dependency** added
- **On any new public-facing endpoint**
- **Quarterly minimum** (a 90-day-old model is a CI failure for "measured" repos)

## Cross-references

- `BACKLOG.md` — the P0 list; S7 is the #1 item.
- `FLEET-AUDIT-REPORT.md` — the per-pillar fleet-wide distribution.
- Per-repo `ACTION-PLAN.md` files — each has a "Build" phase with S7 task entries.

## How to validate

```bash
# After writing your threat model, validate it has all 5 STRIDE rows.
# Markdown table rows look like: | **S — Spoofing** | ...
for c in S T R I D E; do
  grep -qE "^\| \*\*$c " docs/security/threat-model.md || echo "missing $c"
done

# Also assert that every component block has all 6 letters
python3 - <<'PY'
import re, sys
text = open("docs/security/threat-model.md").read()
blocks = re.findall(r"### Component:[^\n]*\n\n.*?(?=\n### |\Z)", text, re.S)
letters = "STRIDE"
bad = []
for i, b in enumerate(blocks):
    name = re.search(r"### Component: (.+)", b).group(1)
    missing = [c for c in letters if not re.search(rf"\| \*\*{c} ", b)]
    if missing:
        bad.append(f"  block {i} ({name}): missing {''.join(missing)}")
if bad:
    print("INCOMPLETE:")
    print("\n".join(bad)); sys.exit(1)
print(f"OK: {len(blocks)} components, all {len(letters)} STRIDE rows present in each")
PY
```

If `grep` and the Python check both return successfully, your file is valid.

## Provenance

- **Template version:** 1.0
- **Author:** Phenotype Org holistic audit, 2026-06-16
- **Audit that produced it:** `FLEET-AUDIT-30-PILLAR.md` (S7 P0)
- **License:** Same as the parent repo
-- 
2.50.1 (Apple Git-155)
