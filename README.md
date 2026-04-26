# PhenoProject

**Status:** maintenance

Phenotype project and workflow management framework for tracking, organizing, and executing work across the Phenotype ecosystem.

## Purpose

PhenoProject provides unified project management, workflow coordination, and task execution capabilities for Phenotype repositories. It integrates with AgilePlus for specification-driven development and provides tooling for organizing work packages, tracking progress, and managing cross-repo dependencies.

## Features

- **Project Tracking** — Organize work into projects and milestones
- **Workflow Management** — Define and execute multi-stage workflows
- **Task Coordination** — Track tasks across projects with dependency resolution
- **Progress Reporting** — Real-time status dashboards and completion metrics
- **Integration** — AgilePlus specs, Git branches, and cross-repo linking

## Quick Start

```bash
pheno-project init <name>
pheno-project add-task <project> <task>
pheno-project workflow run <project>
pheno-project status --all
```

## Project Status

- **Status**: Active
- **Type**: Project Management Framework
- **Part of**: Phenotype Ecosystem
- **Integrates With**: AgilePlus, Git, Phenotype CLI

## Governance & Quality

- **Specs**: All work tracked in AgilePlus
- **Testing**: Use `cargo test` for Rust components
- **Linting**: `cargo clippy` + Vale for documentation
- **Standards**: SemVer releases, git-based versioning

## Installation & Setup

```bash
# Build the project
cargo build --release

# Run tests
cargo test --workspace

# Install locally
cargo install --path .
```

## Commands Reference

### Project Initialization
```bash
# Create a new project
pheno-project init my-project

# Add workspace configuration
pheno-project workspace add my-workspace
```

### Task Management
```bash
# Add new task to project
pheno-project add-task my-project "Implement feature X"

# List all tasks
pheno-project task list my-project

# Update task status
pheno-project task update my-project task-id --status in-progress

# Mark task complete
pheno-project task complete my-project task-id
```

### Workflow Operations
```bash
# Define workflow stages
pheno-project workflow define my-project --stages discovery,design,build,test

# Execute workflow
pheno-project workflow run my-project

# Get workflow status
pheno-project workflow status my-project
```

### Cross-Repo Coordination
```bash
# Track dependencies across repositories
pheno-project dependency add my-project repo:agileplus

# Resolve dependency graph
pheno-project dependency resolve my-project

# Check integration readiness
pheno-project status --all
```

## Architecture

- **Task Model**: Work units with status, ownership, dependencies
- **Workflow Engine**: Multi-stage workflow with transition guards
- **Repository Integration**: Git-aware task tracking and branch management
- **Progress Tracking**: Real-time dashboards and completion metrics
- **Cross-Repo Linking**: Dependency resolution across Phenotype repositories

## Testing

```bash
# Unit tests
cargo test --lib

# Integration tests
cargo test --test '*'

# Test coverage
cargo tarpaulin --workspace --out Html
```

## Quality Standards

- **Code Coverage**: Minimum 75% coverage for all modules
- **Linting**: Zero `clippy` warnings with strict allow rules
- **Formatting**: All code must pass `cargo fmt --check`
- **Documentation**: All public APIs documented with examples
- **Tests**: All functional requirements traced to test cases

## References

- **AgilePlus**: Work planning and specification at `repos/AgilePlus`
- **Governance**: Project rules in `CLAUDE.md`
- **CI/CD**: Quality policy in `AGENTS.md`
- **Worklogs**: Audit trail in `docs/worklogs/` (if present)
- **Collection**: Part of the Phenotype Ecosystem — see `projects.kooshapari.com` for overview

## Development

This project follows the Phenotype organization guidelines:

- **Worktrees**: Feature work in `repos/PhenoProject-wtrees/<topic>/`
- **Specs**: All work tracked in AgilePlus before implementation
- **CI/CD**: GitHub Actions with policy gates for all PRs
- **Releases**: CalVer + SemVer hybrid versioning strategy

## License

MIT — see [LICENSE](./LICENSE).
