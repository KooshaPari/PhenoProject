# FUNCTIONAL REQUIREMENTS — PhenoProject

> **Project:** PhenoProject
> **Owner:** KooshaPari
> **Layout:** `rust/Planify/` (TypeScript/Bun monorepo) and `go/KaskMan/` (Go task manager)
> **Tracking:** This document. All tests MUST reference an FR. All FRs MUST have at least one test.

---

## FR-001: Project and Workflow Management

**Description**

PhenoProject provides a unified workspace for managing project metadata, workflow
state, and cross-teammate coordination.  The `rust/Planify/` subproject exposes
TypeScript APIs (via Bun) for workspace initialization, plan creation, and status
tracking.  The `go/KaskMan/` subproject implements a command-line project manager
that reads and writes the same workspace plan files.

Both subprojects share the same plan file schema and are designed to interoperate:
KaskMan manages the on-disk state, and Planify provides a rich web interface.

**Traced source files**

| File | Role |
|------|------|
| `rust/Planify/apps/web/src/app/**` | Next.js app router pages |
| `rust/Planify/packages/core/src/index.ts` | Core workspace API |
| `rust/Planify/packages/db/src/schema.ts` | Database schema and queries |
| `go/KaskMan/main.go` | CLI entry point |
| `go/KaskMan/cmd/plan.go` | Plan CRUD commands |
| `go/KaskMan/internal/plan/plan.go` | Plan domain logic |

**Acceptance criteria**
- [ ] `plan create <name>` / `plan create` in KaskMan creates a plan file in the workspace
- [ ] Plan files follow a documented JSON/YAML schema with title, description, status, and phase fields
- [ ] Planify web UI reads the same plan files and renders them in a dashboard
- [ ] `plan status` reports the current phase and open work packages
- [ ] Plan files are isolated per subproject under `plans/` with a dated naming convention

---

## FR-002: Task Scheduling and Execution

**Description**

KaskMan implements a task scheduler that enqueues work items, respects priority and
dependency ordering, and advances tasks through a defined lifecycle
(Pending → Running → Blocked → Completed / Failed).  Tasks carry a `workPackage`
reference linking them to the parent plan work package.

Planify's web UI renders a Kanban-style board that reflects the task queue state
and allows drag-to-advance transitions.

**Traced source files**

| File | Role |
|------|------|
| `go/KaskMan/internal/scheduler/scheduler.go` | Scheduler with priority queue |
| `go/KaskMan/internal/task/task.go` | Task domain model |
| `go/KaskMan/cmd/task.go` | Task CLI commands |
| `rust/Planify/packages/core/src/task.ts` | Task type definitions |
| `rust/Planify/apps/web/src/components/kanban/**` | Kanban board UI |

**Acceptance criteria**
- [ ] `task add <name> --plan <plan-id> --priority <level>` creates a task in Pending state
- [ ] `task run <task-id>` transitions Pending → Running and records `started_at`
- [ ] `task block <task-id>` transitions Running → Blocked
- [ ] `task complete <task-id>` transitions Running → Completed and records `completed_at`
- [ ] `task list --plan <plan-id>` shows all tasks with current status
- [ ] Tasks without a parent plan are rejected at creation time
- [ ] Scheduler enforces that a task does not run until all its `depends_on` tasks are Completed

---

## FR-003: Multi-Language Project Support

**Description**

PhenoProject natively handles workspaces that span multiple technology stacks.
The `rust/Planify/` subproject is a TypeScript/Bun monorepo using Turbo and pnpm
workspaces.  The `go/KaskMan/` subproject is a standalone Go binary.  Both
subprojects coexist in the same git repository under separate top-level directories
(`rust/` and `go/`).

Planify's tooling detection reads `package.json`, `Cargo.toml`, and `go.mod`
files to surface which language runtimes are active in a workspace.

**Traced source files**

| File | Role |
|------|------|
| `rust/Planify/package.json` | Bun/pnpm workspace root |
| `rust/Planify/turbo.json` | Turbo pipeline definition |
| `rust/Planify/pnpm-workspace.yaml` | pnpm workspace packages |
| `rust/Planify/apps/web/package.json` | Next.js web app |
| `rust/Planify/packages/core/package.json` | Shared core package |
| `rust/Planify/packages/db/package.json` | Database package |
| `rust/Planify/packages/tsconfig.json` | TypeScript project references |
| `go/KaskMan/go.mod` | Go module definition |

**Acceptance criteria**
- [ ] `pnpm install` in `rust/Planify/` installs all workspace packages without errors
- [ ] `pnpm --filter @planify/web build` compiles the Next.js app
- [ ] `pnpm --filter @planify/core build` compiles the shared core package
- [ ] `go build` in `go/KaskMan/` produces a runnable binary
- [ ] Planify workspace detection identifies both subprojects and their package managers
- [ ] TypeScript project references resolve without circular dependency errors

---

## FR-004: Dependency Resolution and Tracking

**Description**

Planify's `core` package manages workspace dependency metadata: inter-package
references (e.g. `@planify/core` → `@planify/db`), external npm package versions,
and Go module version pins.  The dependency graph is used for change-impact analysis
and to gate which packages are rebuilt during incremental Turbo pipelines.

KaskMan tracks task-level dependencies as a DAG using `depends_on` IDs.

**Traced source files**

| File | Role |
|------|------|
| `rust/Planify/packages/core/src/deps.ts` | Dependency graph types and resolver |
| `rust/Planify/packages/core/src/index.ts` | Exported core API |
| `rust/Planify/packages/db/src/schema.ts` | Dependency rows in SQLite |
| `go/KaskMan/internal/deps/deps.go` | Go dependency resolution |
| `rust/Planify/turbo.json` | Turborepo pipeline / task graph |

**Acceptance criteria**
- [ ] `core.resolveDeps(packageName)` returns a topologically sorted list of dependent packages
- [ ] Circular dependencies between workspace packages are detected and reported as errors
- [ ] `turbo.json` `pipeline` entries define the correct `dependsOn` task graph
- [ ] Database stores each dependency as `(owner, package, version, type)` tuples
- [ ] `go list -m all` output is parsed to populate the Go module dependency view

---

## FR-005: Artifact Generation and Publishing

**Description**

Planify generates and publishes two classes of artifacts:

1. **Plan documents** — stored as timestamped Markdown files under `plans/`, rendered
   in the web UI as read-only HTML
2. **Workspace exports** — JSON snapshots of all plans, tasks, and teammate status,
   downloadable from the web UI

KaskMan writes the same plan files on disk; Planify reads them and enriches with
UI metadata.  Artifacts are immutable once published; updates create new versions.

**Traced source files**

| File | Role |
|------|------|
| `rust/Planify/packages/core/src/artifacts.ts` | Artifact generation logic |
| `rust/Planify/apps/web/src/app/plans/page.tsx` | Plan listing page |
| `rust/Planify/apps/web/src/app/plans/[id]/page.tsx` | Plan detail page |
| `go/KaskMan/internal/artifact/artifact.go` | Artifact write logic |
| `go/KaskMan/cmd/export.go` | Export command |

**Acceptance criteria**
- [ ] `plan export --format json` writes a complete workspace snapshot to stdout
- [ ] Plan markdown files include frontmatter with `id`, `title`, `created`, `updated` fields
- [ ] Web UI displays plan documents as rendered Markdown with syntax-highlighted code blocks
- [ ] Export JSON schema is documented and versioned; breaking changes require a schema bump
- [ ] Artifacts are written atomically (write-then-rename) to avoid partial files

---

## FR-006: Configuration Management

**Description**

PhenoProject configuration is layered: defaults in code, overridden by environment
variables, and further overridden by per-workspace `planify.config.ts` / `kaskman.yaml`
files.  Configuration includes:

- Workspace root path
- Database path (SQLite by default)
- NATS server URL (for event streaming)
- Log level
- Plan directory path
- Teammate registry seed data

**Traced source files**

| File | Role |
|------|------|
| `rust/Planify/packages/core/src/config.ts` | TypeScript config loader |
| `rust/Planify/apps/web/.env.example` | Environment variable template |
| `rust/Planify/apps/web/src/env.ts` | Vite environment binding |
| `go/KaskMan/internal/config/config.go` | Go config loader |
| `go/KaskMan/kaskman.yaml.example` | Example config file |

**Acceptance criteria**
- [ ] Config values fall back to hardcoded defaults when env vars / config files are absent
- [ ] Environment variables take precedence over config file values
- [ ] Config file values take precedence over defaults
- [ ] `planify.config.ts` is loaded via `tsx` or native ESM at startup
- [ ] All config fields are typed and validated; unknown fields produce a warning
- [ ] `kaskman.yaml` is parsed with a documented schema; invalid YAML produces a clear error

---

## FR-007: Integration with External Services

**Description**

Planify integrates with two external services:

1. **NATS** — JetStream event bus for real-time teammate heartbeat, task state change
   events, and KV caching of plan and model data.  KV stores: `provider_cache`
   (5 min TTL), `model_cache` (1 hr TTL), `pareto_cache` (1 min TTL), `price_cache`
   (1 min TTL).
2. **SQLite** — Local persistence for plans, tasks, teammates, and audit logs.

KaskMan is a standalone CLI with no external service dependencies; it writes to the
local filesystem and SQLite.

**Traced source files**

| File | Role |
|------|------|
| `rust/Planify/packages/db/src/schema.ts` | SQLite schema |
| `rust/Planify/packages/db/src/client.ts` | Database client (Drizzle ORM) |
| `rust/Planify/apps/web/src/lib/nats.ts` | NATS client singleton |
| `rust/Planify/apps/web/src/lib/kv.ts` | KV store helpers |
| `rust/Planify/apps/web/src/app/api/health/route.ts` | Health endpoint |
| `go/KaskMan/internal/store/sqlite.go` | SQLite operations |

**Acceptance criteria**
- [ ] NATS connection is established lazily on first publish and reconnects on drop
- [ ] NATS KV `provider_cache` TTL is enforced client-side with per-get expiry checks
- [ ] SQLite schema is applied via migrations; migration files are versioned and idempotent
- [ ] `GET /api/health` returns 200 when both NATS and SQLite are reachable
- [ ] `GET /api/health` returns 503 and a JSON error body when NATS is unreachable
- [ ] KaskMan works fully offline (no NATS required); plan files are the source of truth
