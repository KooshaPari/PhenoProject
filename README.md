<!-- AI-DD-META:START -->
<!-- This repository is planned, maintained, and managed by AI Agents only. -->
<!-- Slop issues are expected and intentionally present as part of an HITL-less -->
<!-- /minimized AI-DD metaproject of learning, refining, and building brute-force -->
<!-- training for both agents and the human operator. -->
![Downloads](https://img.shields.io/github/downloads/KooshaPari/PhenoProject/total?style=flat-square&label=downloads&color=blue)
![GitHub release](https://img.shields.io/github/v/release/KooshaPari/PhenoProject?style=flat-square&label=release)
![License](https://img.shields.io/github/license/KooshaPari/PhenoProject?style=flat-square)
![AI-Slop](https://img.shields.io/badge/AI--DD-Slop%20Expected-orange?style=flat-square)
![AI-Only-Maintained](https://img.shields.io/badge/Planned%20%26%20Maintained%20by-AI%20Agents%20Only-red?style=flat-square)
![HITL-less](https://img.shields.io/badge/HITL--less%20AI--DD-metaproject-yellow?style=flat-square)

> ⚠️ **AI-Agent-Only Repository**
>
> This repo is **planned, maintained, and managed exclusively by AI Agents**.
> Slop issues, rough edges, and AI artifacts are **expected and intentionally
> present** as part of an **HITL-less / minimized AI-DD** metaproject focused
> on learning, refining, and brute-force training both the agents and the
> human operator. Bug reports and contributions are still welcome, but please
> expect AI-generated code, comments, and documentation throughout.
<!-- AI-DD-META:END -->
## Work State

| Field | Value |
|---|---|
| Last commit | 2026-06-08 |
| Open issues | 0 |
| Open PRs | 6 |
| Focus | npm dependency updates + planify/kaskman integration |

Progress: █████░░░░░ 50%

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
