# PhenoProject

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

## References

- **AgilePlus**: Work planning and specification at `repos/AgilePlus`
- **Governance**: Project rules in `CLAUDE.md`
- **CI/CD**: Quality policy in `AGENTS.md`
- **Worklogs**: Audit trail in `docs/worklogs/` (if present)
