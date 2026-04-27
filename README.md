<div align="center">

# 🐿️ Squirrel

[![License](https://img.shields.io/github/license/flyingsquirrel0419/squirrel-skill)](LICENSE)
[![Platforms](https://img.shields.io/badge/platforms-8-blue)](#-platform-compatibility)
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/github/all-contributors/flyingsquirrel0419/squirrel-skill?color=ee8449&style=flat-square)](#contributors)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

**Full-cycle AI coding skill that works everywhere — from blank canvas to production.**

Plans, builds, tests, lints, fixes bugs, and writes production-grade docs.
Runs on OpenCode, Codex, Claude Code, Cursor, Windsurf, Aider, Cline, and Copilot.

[Install](#-installation) · [How it works](#-how-it-works) · [Report Bug](https://github.com/flyingsquirrel0419/squirrel-skill/issues)

</div>

---

## Features

- **Auto-detects project state** — Greenfield, in-progress, or mature. Squirrel figures out where your project is and jumps in at exactly the right point instead of forcing a one-size-fits-all workflow.
- **Respects existing code** — Matches your naming conventions, test framework, import style, and architecture. Extends what's there instead of overwriting it. Reads 2–3 similar files before writing a new one.
- **8-phase engineering pipeline** — Discover → Plan → Build → Test → Bug Hunt → Polish → Document → Ship. The same disciplined process a senior engineer follows, every time.
- **Platform-agnostic** — One skill file, 8 AI coding agents. Drop it in as `AGENTS.md`, `CLAUDE.md`, `.cursor/rules/squirrel.mdc`, or any of the other supported formats and it just works.
- **Built-in failure recovery** — 3-Strike Rule: fix, retry differently, then stop and ask. Never leaves code in a broken state. Includes sub-agent failure recovery for parallel execution.
- **CI/CD templates included** — Ready-to-use GitHub Actions workflows for Node.js, Python, Go, Rust, and more. Use them as a starting point, not a drop-in guarantee.
- **Stack-agnostic** — Works with TypeScript, Python, Go, Rust, Ruby, Java, C#, Elixir, and any language that has a linter, formatter, and test runner. Detects your stack and adapts automatically.

---

## Quick Start

Install in one command — auto-detects your AI agent and platform:

```bash
curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/install.sh | bash
```

Or install for a specific platform:

```bash
curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/install.sh | bash -s -- --platform cursor
```

Or clone and run locally:

```bash
git clone https://github.com/flyingsquirrel0419/squirrel-skill.git
cd squirrel-skill && bash install.sh
```

Then just tell your AI agent what you want to build:

```
> build me a REST API for a todo app with TypeScript and Express
```

```
> create a CLI tool in Rust that parses CSV files
```

```
> fix this bug in src/auth/login.py
```

```
> squirrel this project — add tests, fix lint errors, write README
```

Squirrel auto-detects your project state and starts at the right phase. No config needed.

---

## Installation

### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/install.sh | bash
```

Auto-detects which AI agents are configured in your project and installs Squirrel for all of them.

### Install for a specific platform

```bash
# Any platform
bash install.sh --platform <platform>

# Examples
bash install.sh --platform opencode
bash install.sh --platform cursor
bash install.sh --platform claude-code
bash install.sh --platform aider

# Custom output path
bash install.sh --platform codex --path ./my-instructions.md
```

Supported platforms: `opencode`, `codex`, `claude-code`, `cursor`, `windsurf`, `aider`, `cline`, `copilot`

### Manual install per platform

<details>
<summary>OpenCode</summary>

```bash
mkdir -p ~/.config/opencode/skills/squirrel
curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/SKILL.md \
  -o ~/.config/opencode/skills/squirrel/SKILL.md
```
</details>

<details>
<summary>OpenAI Codex</summary>

```bash
curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/SKILL.md -o AGENTS.md
```
</details>

<details>
<summary>Claude Code</summary>

```bash
# Option A: Direct
curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/SKILL.md -o CLAUDE.md

# Option B: Import from existing CLAUDE.md
echo -e "\n@AGENTS.md" >> CLAUDE.md
curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/SKILL.md -o AGENTS.md
```
</details>

<details>
<summary>Cursor</summary>

```bash
mkdir -p .cursor/rules
curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/SKILL.md -o .cursor/rules/squirrel.mdc
# Then add frontmatter to squirrel.mdc:
# ---
# description: Squirrel full-cycle development skill
# alwaysApply: true
# ---
```
</details>

<details>
<summary>Windsurf</summary>

```bash
mkdir -p .windsurf/rules
curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/SKILL.md -o .windsurf/rules/squirrel.md
# Then add frontmatter to squirrel.md:
# ---
# trigger: always_on
# description: Squirrel full-cycle development skill
# ---
```
</details>

<details>
<summary>Aider</summary>

```bash
curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/SKILL.md -o squirrel-skill.md
aider --read squirrel-skill.md
# Or add to .aider.conf.yml:  read: squirrel-skill.md
```
</details>

<details>
<summary>Cline</summary>

```bash
mkdir -p .clinerules
curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/SKILL.md -o .clinerules/squirrel.md
```
</details>

<details>
<summary>GitHub Copilot</summary>

```bash
mkdir -p .github
curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/SKILL.md \
  -o .github/copilot-instructions.md
```
</details>

---

## How It Works

### Step 0: Detect Mode

Squirrel checks your project directory and classifies it:

| Signal | Mode | Entry Point |
|--------|------|-------------|
| Empty directory, no source files | 🆕 Greenfield | All 8 phases from scratch |
| Source files, no tests/docs | 🔧 In-Progress | Audit first, then improve |
| Source + tests + CI + README | 🏗️ Mature | Targeted improvements |
| "fix this bug / add this feature" | 🎯 Targeted | Abbreviated audit, scoped work |

### The 8-Phase Pipeline

```
[1] Discover  → Understand the project (audit existing code or gather requirements)
[2] Plan      → Concrete task list with dependencies, risks, and done-criteria
[3] Build     → Write or modify code (parallel sub-agents when platform supports it)
[4] Test      → Run existing tests, write new ones, 70%+ coverage target
[5] Bug Hunt  → Static analysis + manual review, fix all critical/warning bugs
[6] Polish    → Lint, format, type check, remove dead code
[7] Document  → README + inline docs (update existing, don't overwrite)
[8] Ship      → Final checklist: tests green, no secrets, CI configured, clean checkout
```

### Failure Recovery (3-Strike Rule)

1. **Strike 1:** Fix the specific error. Run tests. Move on.
2. **Strike 2:** Re-read the code. Try a different approach.
3. **Strike 3:** STOP. Revert. Document what failed. Ask the user.

Code is never left in a broken state. Failing tests are never deleted to "pass".

### Parallel Execution

On platforms that support sub-agents (OpenCode, Codex, Cursor), Squirrel decomposes work into independent units and spawns them in parallel using a structured delegation prompt:

```
TASK: [atomic goal]
CONTEXT: [relevant plan sections, shared types]
SCOPE: [files to modify, files NOT to touch]
DONE WHEN: [verifiable success criteria]
STYLE: [existing patterns to follow]
CONSTRAINTS: [what not to do]
```

---

## Reference Files

Squirrel ships with supplementary references loaded on demand:

| File | Purpose |
|------|---------|
| `references/plan_template.md` | Project plan template with risk matrix, task breakdown, progress log |
| `references/readme_template.md` | Production-grade README template with badges, quick start, config table |
| `references/stack_hints.md` | Common pitfalls and best practices for TS, Python, Go, Rust, React, REST, DB |
| `references/ci_templates.md` | GitHub Actions CI/CD for Node.js, Python, Go, Rust + npm/PyPI release workflows |

---

## Development

### Project structure

```
squirrel/
├── .all-contributorsrc              # All Contributors config for README credits
├── .github/workflows/ci.yml         # Smoke-test workflow for installer regressions
├── SKILL.md                        # Main skill definition (629 lines)
├── install.sh                      # One-liner installer with auto-detection
├── tests/
│   └── installer_smoke_test.sh     # Verifies installer output and doc slug consistency
└── references/
    ├── ci_templates.md             # CI/CD pipeline templates
    ├── plan_template.md            # Project plan template
    ├── readme_template.md          # README template
    └── stack_hints.md              # Language-specific best practices
```

### Contributing

1. Fork the repo
2. Create a branch: `git checkout -b feature/your-feature`
3. Edit `SKILL.md` or add references in `references/`
4. Test your changes on at least one supported platform
5. Push and open a PR

### Design principles

- **One file does everything.** `SKILL.md` is the single source of truth. Reference files are supplementary, not required.
- **No platform assumptions.** Every instruction must make sense on all 8 platforms. Platform-specific details go in the Platform Compatibility section only.
- **Respect > Rewrite.** The skill teaches the agent to respect existing code. The skill itself follows the same principle — extend, don't replace.
- **Plain Markdown is portable.** No proprietary syntax, no code-only constructs. Every AI agent reads Markdown.

---

## Contributors

This project follows the [All Contributors](https://allcontributors.org/overview/) specification. Contributions of any kind are welcome.

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/flyingsquirrel0419"><img src="https://avatars.githubusercontent.com/u/217446317?v=4" width="100px;" alt="flyingsquirrel0419"/><br /><sub><b>flyingsquirrel0419</b></sub></a><br /><a href="https://github.com/flyingsquirrel0419/squirrel-skill/commits?author=flyingsquirrel0419" title="Code">💻</a> <a href="https://github.com/flyingsquirrel0419/squirrel-skill/commits?author=flyingsquirrel0419" title="Documentation">📖</a></td>
    </tr>
  </tbody>
</table>
<!-- ALL-CONTRIBUTORS-LIST:END -->

---

## License

[Apache 2.0](LICENSE) © flying_squirrel__
