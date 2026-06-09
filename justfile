# Phenotype-org standard justfile
# PhenoProject is a polyglot workspace (TS/Bun + Go + Python).
# Prefer the existing Taskfile.yml when present; these recipes are thin wrappers.

default:
    @just --list

# Build all subprojects
build:
    task build

# Run all subproject tests
test:
    task test

# Lint all subprojects
lint:
    task lint

# Remove common build and test artifacts
clean:
    task clean

# Full local CI sweep
ci: lint test

# Format code (delegates to per-language formatters via Taskfile)
fmt:
    task lint
