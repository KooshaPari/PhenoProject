# PhenoProject

[![Build](https://img.shields.io/github/actions/workflow/status/KooshaPari/PhenoProject/ci.yml?branch=main&label=build)](https://github.com/KooshaPari/PhenoProject/actions)
[![Release](https://img.shields.io/github/v/release/KooshaPari/PhenoProject?include_prereleases&sort=semver)](https://github.com/KooshaPari/PhenoProject/releases)
[![License](https://img.shields.io/github/license/KooshaPari/PhenoProject)](LICENSE)
[![Phenotype](https://img.shields.io/badge/Phenotype-org-blueviolet)](https://github.com/KooshaPari)

Phenotype project & workflow management workspace.

## Status

Active. Aggregates two product subprojects in their own technology stacks.

## Layout

| Path | Purpose |
|------|---------|
| `rust/Planify/` | Planify — TypeScript/Bun monorepo (apps + packages, Turbo, pnpm/bun) |
| `go/KaskMan/` | KaskMan — Go-based task/project manager |
| `tests/` | Workspace-level tests |
| `docs/guides/` | Workspace guides and traceability docs |
| `docs/worklogs/` | Per-session worklog entries |
| `AGENTS.md` | Agent governance |
| `CLAUDE.md` | Claude Code project instructions |
| `FUNCTIONAL_REQUIREMENTS.md` | FR tracker (stub) |

Note: despite the parent `rust/` and `go/` directory names, `rust/Planify/` is currently a TypeScript monorepo (Turbo + pnpm/bun workspaces) — see its own `README.md`.

## Quick Start

Each subproject is independent. Refer to its own README:

```bash
git clone https://github.com/KooshaPari/PhenoProject.git
cd PhenoProject/rust/Planify   # or: cd PhenoProject/go/KaskMan
```

## Links

- Canonical repo: https://github.com/KooshaPari/PhenoProject
- Planify subproject README: `rust/Planify/README.md`
- KaskMan subproject README: `go/KaskMan/README.md`
