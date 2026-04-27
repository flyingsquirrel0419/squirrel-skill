# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

## [1.0.0] - 2026-04-27

### Added

- 8-phase full-cycle software development pipeline (Discover → Plan → Build → Test → Bug Hunt → Polish → Document → Ship)
- Auto-detection of project state: Greenfield, In-Progress, Mature, Targeted
- Sub-agent delegation with structured prompt template for parallel execution
- Failure Recovery Protocol with 3-Strike Rule
- Platform compatibility for 8 AI coding agents: OpenCode, Codex, Claude Code, Cursor, Windsurf, Aider, Cline, GitHub Copilot
- `AGENTS.md` cross-platform installation strategy
- Stack-agnostic audit commands covering TypeScript, Python, Go, Rust, Ruby, Java, C#, Elixir
- Reference files loaded on demand:
  - `plan_template.md` — project plan with risk matrix and task breakdown
  - `readme_template.md` — production-grade README with badges and quick start
  - `stack_hints.md` — language-specific pitfalls and best practices (TS, Python, Go, Rust, React, REST, DB, Ruby, Java/Kotlin, C#/.NET)
  - `ci_templates.md` — GitHub Actions CI/CD for Node.js, Python, Go, Rust, Ruby, Java, .NET + npm/PyPI release workflows

### Changed

- _Initial release — no prior versions._

[Unreleased]: https://github.com/flying-squirrel/squirrel-skill/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/flying-squirrel/squirrel-skill/releases/tag/v1.0.0
