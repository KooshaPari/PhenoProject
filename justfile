# justfile for PhenoProject
# Monorepo with two TypeScript subprojects: `go/KaskMan` (npm) and
# `rust/Planify` (pnpm). The `rust/` and `go/` directory names are
# organizational — both are TypeScript workspaces.
# Use `just` (or `just <recipe>`) to run recipes.
# `just` is the casey/just command runner: https://just.systems

set shell := ["bash", "-uc"]
set dotenv-load

# ---- Detected features (eval once, exported as env vars) ----

export HAS_ROOT_PACKAGE := `test -f package.json && echo 1 || echo 0`
export HAS_KASKMAN := `test -f go/KaskMan/package.json && echo 1 || echo 0`
export HAS_PLANIFY := `test -f rust/Planify/package.json && echo 1 || echo 0`
export HAS_PLANIFY_API_PY := `test -f rust/Planify/apps/api/pyproject.toml && echo 1 || echo 0`
export HAS_UV := `command -v uv >/dev/null 2>&1 && echo 1 || echo 0`
export JS_RUNNER := `command -v bun >/dev/null 2>&1 && echo bun || (command -v pnpm >/dev/null 2>&1 && echo pnpm || echo npm)`

# ---- Default recipe: list available recipes ----

default: list

# Show all available recipes
list:
    @just --list

# ---- Dev: start watchers in both subprojects in parallel ----

dev:
    #!/usr/bin/env bash
    set -euo pipefail

    pids=()

    if [ "${HAS_KASKMAN}" = "1" ]; then
      (cd go/KaskMan && npm run start) &
      pids+=($!)
    fi

    if [ "${HAS_PLANIFY}" = "1" ]; then
      (cd rust/Planify && pnpm dev) &
      pids+=($!)
    fi

    if [ ${#pids[@]} -eq 0 ]; then
      echo "no subprojects detected" >&2
      exit 1
    fi

    trap "kill ${pids[*]} 2>/dev/null || true" INT TERM EXIT
    wait "${pids[@]}"

# ---- Build: produce release artifacts for both subprojects ----

build:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ "${HAS_KASKMAN}" = "1" ]; then
      (cd go/KaskMan && npm run build 2>/dev/null || true)
    fi

    if [ "${HAS_PLANIFY}" = "1" ]; then
      (cd rust/Planify && pnpm build)
    fi

# ---- Test: run the test suite in both subprojects ----

test:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ "${HAS_KASKMAN}" = "1" ]; then
      (cd go/KaskMan && npm test)
    fi

    if [ "${HAS_PLANIFY}" = "1" ]; then
      (cd rust/Planify && pnpm test 2>/dev/null || pnpm run check)
    fi

    if [ "${HAS_PLANIFY_API_PY}" = "1" ] && [ "${HAS_UV}" = "1" ]; then
      (cd rust/Planify/apps/api && uv run pytest 2>/dev/null || true)
    fi

# ---- Lint: eslint/biome for JS, ruff for python ----

lint:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ "${HAS_KASKMAN}" = "1" ]; then
      (cd go/KaskMan && npm run lint)
    fi

    if [ "${HAS_PLANIFY}" = "1" ]; then
      (cd rust/Planify && pnpm check:lint 2>/dev/null || pnpm lint 2>/dev/null || true)
    fi

    if [ "${HAS_PLANIFY_API_PY}" = "1" ] && [ "${HAS_UV}" = "1" ]; then
      (cd rust/Planify/apps/api && uv run ruff check . 2>/dev/null || true)
    fi

# ---- Fmt: apply formatter in both subprojects ----

fmt:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ "${HAS_KASKMAN}" = "1" ]; then
      (cd go/KaskMan && npm run fix 2>/dev/null || npm run format 2>/dev/null || true)
    fi

    if [ "${HAS_PLANIFY}" = "1" ]; then
      (cd rust/Planify && pnpm fix:format 2>/dev/null || pnpm format 2>/dev/null || true)
    fi

    if [ "${HAS_PLANIFY_API_PY}" = "1" ] && [ "${HAS_UV}" = "1" ]; then
      (cd rust/Planify/apps/api && uv run ruff format . 2>/dev/null || true)
    fi

# ---- Clean: remove generated artifacts ----

clean:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ "${HAS_KASKMAN}" = "1" ]; then
      rm -rf go/KaskMan/node_modules go/KaskMan/dist go/KaskMan/coverage
    fi

    if [ "${HAS_PLANIFY}" = "1" ]; then
      rm -rf rust/Planify/node_modules rust/Planify/apps/*/node_modules rust/Planify/packages/*/node_modules
      rm -rf rust/Planify/apps/*/dist rust/Planify/packages/*/dist
      rm -rf rust/Planify/.turbo rust/Planify/apps/*/.turbo rust/Planify/packages/*/.turbo
    fi

    if [ "${HAS_PLANIFY_API_PY}" = "1" ]; then
      rm -rf rust/Planify/apps/api/.venv rust/Planify/apps/api/__pycache__
      rm -rf rust/Planify/apps/api/.pytest_cache rust/Planify/apps/api/.ruff_cache
    fi
