---
name: squirrel
description: |
  Full-cycle software development agent: plans, builds, tests, lints, fixes bugs, and writes production-grade README docs.

  ALWAYS use this skill when the user wants to: build or scaffold a new project, add features to existing code, fix bugs, improve code quality (lint, format, refactor), write or improve a README, add tests, do a code review, or handle any multi-step software development task.

  Trigger on: "build me", "create a project", "make a", "fix this bug", "add tests", "write README", "improve code quality", "refactor", "review my code", "squirrel", "스쿼럴" — or any request that involves writing, reading, or improving code files, even if it sounds simple.

  Why the name? Squirrels are obsessive planners. They find, organize, and store before winter hits. This skill does the same: gather requirements → plan carefully → build for the long run.
license: Apache-2.0
metadata:
  author: flying_squirrel__
  platforms: "opencode codex claude-code cursor windsurf aider cline copilot antigravity"
---

# 🐿️ Squirrel — Full-Cycle Software Development Skill

Squirrel works on **any project at any stage** — from blank canvas to legacy codebase. The first thing it does is figure out *where the project actually is*, then jump in at exactly the right point.

---

## Step 0 — Detect Mode (Always First)

Before anything else, answer: **Is this a new project or an existing one?**

```bash
# Check for signs of an existing codebase
ls -la
find . -maxdepth 2 \( -name "package.json" -o -name "pyproject.toml" -o -name "go.mod" \
  -o -name "Cargo.toml" -o -name "Gemfile" -o -name "*.csproj" \) 2>/dev/null
find . -maxdepth 1 -name "*.md" 2>/dev/null
```

| Signal | Mode |
|--------|------|
| Empty dir, no source files | 🆕 **Greenfield** — start from scratch |
| Source files exist, no tests, no docs | 🔧 **In-Progress** — join and improve |
| Source + tests + CI + README | 🏗️ **Mature** — targeted improvement |
| "fix this bug / add this feature / review my code" | 🎯 **Targeted** — scoped task, full audit optional |

**Announce the mode** to the user: *"This looks like an in-progress project — I'll audit the existing code before touching anything."*

Each mode has a different entry point into the phases below. Don't always start at Phase 1.

---

## Phases

```
[1] 🔍 Discover      → Understand the project (new OR existing)
[2] 📋 Plan          → Decide what to do and in what order
[3] 💻 Build         → Write or modify code
[4] 🧪 Test          → Run + write tests
[5] 🐛 Bug Hunt      → Static analysis + manual review
[6] ✨ Polish        → Lint + format + type check
[7] 📖 Document      → README + inline docs
[8] 🚀 Ship          → Final review, clean deliverable
```

**Greenfield projects**: run all 8 phases in order.

**In-Progress / Mature projects**: always run Phase 1 (Audit) first, then jump to whichever phases are relevant to the task. You don't need to rebuild tests that already exist or rewrite docs that are already good — but you do need to *know* they exist before skipping them.

**Targeted tasks** (e.g., "fix this one bug"): still run Phase 1 (abbreviated), do the work, then run Phase 5 to make sure the fix didn't break anything else.

Always announce which phases you're running and why.

---

## Phase 1 — 🔍 Discover

**Goal: know the project cold before writing a single line.**

### 1a. Find Plan.md

```bash
find . -maxdepth 3 -name "Plan.md" 2>/dev/null
```

If it exists: read it. Update any outdated sections before proceeding.
If it doesn't: you'll create it — but only *after* understanding the existing code (for existing projects) or after talking to the user (for new projects).

### 1b. New project — gather requirements

If starting from scratch, ask yourself:
- What is the core problem being solved?
- Who uses this and what do they care about most?
- What tech stack fits best and why?
- What does "done" look like, concretely?
- What are the risks and unknowns?

Create `Plan.md` from `references/plan_template.md`, show it to the user, and get approval before writing code. A plan the user hasn't seen is a liability.

### 1c. Existing project — run a full audit

For any project with existing code, run the Codebase Audit before touching anything. This is not optional — skipping it means working blind.

```bash
# 1. Structure snapshot (exclude common vendor/cache directories)
find . -type f | grep -v -E '(node_modules|\.git|__pycache__|\.pyc$|vendor/|target/|build/|dist/|\.gradle/)' | sort

# 2. Dependencies (detect which package manager the project uses)
cat package.json 2>/dev/null       # Node.js (npm/yarn/pnpm)
cat pyproject.toml 2>/dev/null     # Python
cat go.mod 2>/dev/null             # Go
cat Cargo.toml 2>/dev/null         # Rust
cat Gemfile 2>/dev/null            # Ruby
cat pom.xml 2>/dev/null            # Java (Maven)
cat build.gradle* 2>/dev/null      # Java/Kotlin (Gradle)
cat *.csproj 2>/dev/null           # C# / .NET
cat mix.exs 2>/dev/null            # Elixir

# 3. Existing tests (all common naming conventions)
find . -type f \( -name "*.test.*" -o -name "*.spec.*" -o -name "test_*.py" \
  -o -name "*_test.go" -o -name "*_test.rs" -o -name "*Test.java" \
  -o -name "*Tests.cs" -o -name "*_test.exs" \) | grep -v -E '(node_modules|vendor/)'

# 4. Existing tooling (linters, formatters, type checkers, CI)
ls .eslintrc* .prettierrc* pyproject.toml .github/workflows/ \
   rustfmt.toml .clippy.toml staticcheck.conf \
   .rubocop.yml .solhintrc* .editorconfig 2>/dev/null

# 5. Recent git activity (if git repo)
git log --oneline -20 2>/dev/null
git status 2>/dev/null

# 6. Dependency vulnerabilities (use whatever matches the project's stack)
npm audit 2>/dev/null || pip-audit 2>/dev/null || cargo audit 2>/dev/null \
  || yarn audit 2>/dev/null || pnpm audit 2>/dev/null
```

**Synthesize what you find into an Audit Report:**

```
## 🔍 Audit Report

**Stack:** [languages, frameworks, key libraries]
**Size:** ~N files, ~N lines of code
**Test coverage:** [existing tests: yes/no, framework, rough coverage if known]
**Tooling:** [linters/formatters already configured]
**Conventions:** [naming style, file organization patterns observed]
**Tech debt spotted:** [anything obviously broken, outdated, or risky]
**Open questions:** [things you need the user to clarify]
```

Share the Audit Report with the user before proceeding. This ensures you're aligned on what's already there and what needs doing. It also builds trust — the user sees you actually read their code.

**Critical rule for existing projects: respect what's already there.**
- Use the existing test framework, don't introduce a new one
- Match the existing code style (spacing, naming, patterns) — check the project's linter/formatter config: `.eslintrc`, `pyproject.toml`, `rustfmt.toml`, `.editorconfig`, `.rubocop.yml`, etc.
- Work within the existing architecture; propose refactoring only if you spot a real problem, not just preference
- Extend existing docs rather than rewriting them from scratch

---

## Phase 2 — 📋 Plan

Turn the goal + audit findings into a concrete, sequenced task list.

**Your plan must include:**
- What already exists and can be reused / built on (for existing projects)
- What's missing and needs to be created
- Tasks in dependency order with "done" criteria
- Risk flags: what's uncertain, what might break, what existing code might be affected
- Which tasks can be parallelized (sub-agent candidates)
- Complexity tags: 🟢 easy / 🟡 medium / 🔴 hard

**For existing projects, the plan should also call out:**
- Which files will be modified (not just created)
- Any existing tests that will need to be updated
- Any breaking changes to existing interfaces

Save this into `Plan.md` under `## Task Breakdown`. Show it to the user before building.

---

## Phase 3 — 💻 Build

Execute the plan.

### For new code:
Write it to a standard you'd be proud to show in a PR:
- Names that explain intent: `get_user_by_id`, `MAX_RETRY_COUNT`, `UserRepository`, not `getU`, `3`
- Errors that tell the user what went wrong and what to do about it
- Comments that explain **why**, not what: `// skip cache on admin routes — stale data is a security risk`
- Small, focused functions: one job per function
- No magic strings or numbers — use named constants
- Follow the naming convention of the language: `camelCase` in JS/TS/Java, `snake_case` in Python/Ruby/Rust, `PascalCase` in Go for exports

### For existing code:
- **Match the codebase's style** — use their naming convention, their error handling patterns, their import style. If they use `snake_case`, don't introduce `camelCase`.
- **Read before writing** — look at 2-3 similar existing functions before implementing a new one. Follow the pattern.
- **Touch only what's necessary** — if the task is "add a password reset endpoint", don't refactor unrelated files.
- **Leave the codebase better than you found it**, but scope improvements to what you touched.

### Sub-agents / Parallel execution:

**When your platform supports sub-agents (OpenCode, Codex, Claude Code, Cursor):**

Decompose work into independent units and spawn in parallel. Each sub-agent gets:
- Their specific task with clear success criteria
- Relevant sections of Plan.md (not the whole thing — just what they need)
- Shared interfaces, types, and contracts they must conform to
- Explicit file scope: which files to read, which to write, which NOT to touch
- Reference to existing code patterns they must follow

**Delegation prompt template:**
```
TASK: [specific, atomic goal — one action per delegation]
CONTEXT: [relevant Plan.md sections, existing code paths, shared types]
SCOPE: [files to modify, files to read for patterns, files NOT to touch]
DONE WHEN: [concrete, verifiable success criteria]
STYLE: [existing patterns to follow — point to specific files]
CONSTRAINTS: [what not to do, what to preserve]
```

**What to parallelize:**
- Independent modules (e.g., auth module + payment module)
- Independent layers (e.g., database migration + API endpoint + frontend component)
- Independent concerns (e.g., feature implementation + test writing + documentation)

**What NOT to parallelize:**
- Changes that share mutable state or modify the same files
- Work where Task B depends on Task A's output types/interfaces
- Anything that might create conflicting edits in the same file

**When your platform does NOT support sub-agents:**
Work in dependency order. Quick sanity check after each task — don't accumulate broken code. The phases still apply; you just execute them sequentially instead of in parallel.

**Platform-specific execution hints:**
| Platform | Sub-agent mechanism | How to parallelize |
|----------|-------------------|-------------------|
| OpenCode | `task()` with `run_in_background=true` | Spawn multiple background tasks |
| Codex | Parallel sessions via `codex` CLI | Multiple terminal tabs |
| Cursor | Agent panel, multiple Composer threads | Parallel Composer tabs |
| Claude Code | Sequential only | Decompose mentally, execute one at a time |
| Aider | `aider --message` in separate terminals | Separate sessions per task |
| Cline | Sequential only | One task at a time |

---

## Phase 4 — 🧪 Test

### For existing projects — extend, don't replace:
1. Run the existing test suite first — detect the right command from the project's stack:
   ```bash
   npm test 2>/dev/null || pytest 2>/dev/null || go test ./... 2>/dev/null \
     || cargo test 2>/dev/null || bundle exec rspec 2>/dev/null || dotnet test 2>/dev/null
   ```
2. Note what's passing, what's failing, what's missing coverage
3. Add tests for the new/changed code using the *same framework and style* already in use
4. If existing tests are broken by your changes, fix them — don't delete them

### For new projects — build from scratch:
| Project type | Test strategy |
|---|---|
| Library / utility | Unit tests for every exported function |
| REST API | Integration test per endpoint |
| CLI tool | Integration tests with real input/output fixtures |
| Frontend component | Unit + snapshot/visual tests |
| Full-stack app | Unit + integration + at least one e2e happy-path test |
| Script / automation | Smoke test with representative sample data |

### Good tests, always:
- Test behavior, not implementation
- Names like sentences: `"returns 404 when user is not found"`
- Cover: happy path ✅, edge cases ⚠️, one error case ❌
- 70%+ coverage is healthy; 100% is often over-engineering
- **Test isolation is non-negotiable**: each test must start from clean state. For apps with in-memory state, use a factory function and instantiate fresh in `beforeEach` / `setUp` / `#[test]`. Global mutations across tests cause phantom failures that waste hours of debugging.

### Run and report (use the command that matches the project's stack):
```bash
# Node.js
npm test && npx jest --coverage

# Python
pytest -v --cov=src --cov-report=term-missing

# Go
go test ./... -v -cover

# Rust
cargo test -- --nocapture

# Ruby
bundle exec rspec

# Java (Maven)
mvn test

# .NET
dotnet test --collect:"XPlat Code Coverage"
```

*"X tests passing, Y failing, Z% coverage"* — fix failures before moving on.

---

## Phase 5 — 🐛 Bug Hunt

Actively hunt for bugs. Don't wait for the user to find them.

### For existing projects — prioritize areas you touched:
Start with files modified in Phase 3, then expand to their direct callers/dependencies. You're most likely to have introduced a regression near your changes.

### Static analysis (run whichever matches the project's stack):
```bash
# TypeScript / JavaScript
npx tsc --noEmit
npx eslint . --ext .ts,.tsx,.js

# Python
python -m mypy src/ --ignore-missing-imports
python -m bandit -r src/

# Go
go vet ./... && staticcheck ./...

# Rust
cargo clippy -- -D warnings

# Ruby
bundle exec rubocop

# Java
mvn spotbugs:check 2>/dev/null || ./gradlew spotbugsMain 2>/dev/null
```

### Manual review checklist:
- [ ] All external inputs validated before use
- [ ] No unhandled promise rejections or swallowed errors
- [ ] No hardcoded secrets or credentials
- [ ] Error messages are useful (not just stack traces)
- [ ] No N+1 query problems or expensive ops in hot loops
- [ ] No obvious race conditions in concurrent code
- [ ] Edge cases handled: empty input, null, very large input, unicode

### For existing projects — also check:
- [ ] Did your changes break any existing interfaces or contracts?
- [ ] Any dependencies that were already vulnerable (from `npm audit` / `pip-audit` / `cargo audit` / `yarn audit`)?
- [ ] Any dead code you introduced, or old code now unreachable?

### Bug report format:
```
🐛 [SEVERITY] Short title
   Location: file.ts:42
   Problem:  What's wrong and why it matters
   Fix:      What you did (or will do)
```
🔴 Critical → 🟡 Warning → 🔵 Info. Fix all 🔴/🟡 before shipping.

---

## Failure Recovery Protocol

When things go wrong — and they will — follow this protocol instead of guessing.

### The 3-Strike Rule:

**Strike 1:** Fix the specific error. Run tests to confirm. Move on.
**Strike 2:** Re-read the relevant code more carefully. Check for root causes you missed the first time. Try a different approach.
**Strike 3:** STOP. Do not attempt another fix.

### After Strike 3:

1. **STOP all edits** — do not make any more changes
2. **REVERT** to the last known working state:
   ```bash
   # If git repo
   git stash  # or git checkout -- <broken-files>
   # If no git, manually undo the last changes
   ```
3. **DOCUMENT** what happened:
   ```
   ## 🚨 Failure Report
   **What I tried:** [approach 1], [approach 2], [approach 3]
   **What went wrong:** [error messages, unexpected behavior]
   **Where I think the problem is:** [root cause hypothesis]
   **What I've ruled out:** [things that are NOT the issue]
   ```
4. **ASK THE USER** — share the Failure Report and ask for guidance:
   - Is there context I'm missing about this code/module?
   - Are there known issues with this dependency/version?
   - Should I try a completely different approach?
5. **NEVER**: Leave code in a broken state, delete failing tests to "pass", or shotgun-debug with random changes

### Recovery for sub-agent failures:

If a sub-agent returns broken or incomplete work:
1. Read what they produced before doing anything
2. Identify specific gaps: missing files, wrong patterns, compilation errors
3. Either fix it yourself (if small) or re-delegate with explicit correction in the prompt
4. Re-delegation prompt: "Previous attempt failed because [specific error]. Fix by [specific action]. Do NOT [what went wrong last time]."

---

## Phase 6 — ✨ Polish

### For existing projects — check what's already configured first:
```bash
# JS/TS
cat .prettierrc* .eslintrc* 2>/dev/null
# Python
cat pyproject.toml 2>/dev/null | grep -A5 "\[tool.black\]"
# Go
cat gofmt 2>/dev/null; go vet -h 2>/dev/null
# Rust
cat rustfmt.toml .rustfmt.toml 2>/dev/null
# Ruby
cat .rubocop.yml 2>/dev/null
# Java/Kotlin
cat .editorconfig 2>/dev/null; cat spotless*.xml 2>/dev/null
```

Use the project's existing formatter config, don't introduce a new one. If no formatter is configured, you can add one — but discuss it with the user first, since reformatting all files creates noisy diffs.

### Auto-format (use whichever matches the project's stack):
```bash
# JavaScript / TypeScript
npx prettier --write "**/*.{ts,tsx,js,jsx,json,css,md}"

# Python
black . && isort .

# Go
gofmt -w .

# Rust
cargo fmt

# Ruby
bundle exec rubocop -A

# Java (Spotless)
./gradlew spotlessApply 2>/dev/null || mvn spotless:apply 2>/dev/null
```

### Lint with auto-fix (use whichever matches the project's stack):
```bash
# JS/TS
npx eslint . --fix

# Python
ruff check --fix .

# Ruby
bundle exec rubocop -A
```

### Manual polish:
- Remove dead code and commented-out blocks (code, not explanatory comments)
- Remove unused imports and variables
- Extract repeated logic into shared utilities — but only within the scope of what you touched
- Add doc comments to functions you wrote or modified (JSDoc for JS/TS, docstrings for Python, `///` for Rust, godoc for Go, RDoc for Ruby)

---

## Phase 7 — 📖 Document

### For existing projects — update, don't overwrite:
Read the existing README before writing anything. Then:
- Update sections that are now inaccurate (installation steps, API docs, config options)
- Add documentation for new features you built
- Fix any broken links or outdated examples
- Don't rewrite sections that are still correct — unnecessary churn confuses contributors

### For new projects — write an awesome README from scratch:
See `references/readme_template.md` for the full template. Required sections:

```markdown
# Project Name
[badges: build, coverage, license, version]
One-sentence value proposition.

## ✨ Features
## 🚀 Quick Start      ← copy-pasteable, works first try, no hand-waving
## 📦 Installation
## 📖 Usage            ← real examples with syntax-highlighted code
## ⚙️ Configuration    ← options table: name | type | default | description
## 🧪 Development      ← setup, run tests, how to contribute
## 📄 License
```

**Quality bar:** every code block has a language tag, no placeholder text, all links work, Quick Start tested from a clean environment.

**Inline docs — always:**
- Doc comments for all exported/public functions you wrote or modified (JSDoc, docstrings, godoc, `///`, RDoc — whatever the language uses)
- Brief module-level comment for non-obvious files
- `// TODO:` / `# TODO:` / `// FIXME:` for known limitations — honest beats pretending

---

## Phase 8 — 🚀 Ship

Final check before handing off.

### Checklist:
- [ ] All tests pass (existing + new)
- [ ] No linting or type errors
- [ ] All 🔴/🟡 bugs from Phase 5 fixed
- [ ] README accurate and complete
- [ ] No debug logs in production code (`console.log`, `print()`, `fmt.Println`, `println!`, `pp`, `puts`, `System.out.println`, `dd()`, `pry`)
- [ ] No hardcoded secrets anywhere
- [ ] `.gitignore` covers build artifacts, `.env`, `__pycache__`, `node_modules`, `target/`, `build/`, `.DS_Store`
- [ ] `.env.example` present if env vars are used
- [ ] CI pipeline configured (see `references/ci_templates.md`)
- [ ] CI badge added to README
- [ ] Project runs from a clean checkout

### Final summary:
```
## 🐿️ Squirrel Summary

**Mode:** [Greenfield / In-Progress / Targeted]
**What changed:** [files created, modified, deleted]
**Tests:** X passing (+N new), Y% coverage
**Bugs fixed:** N — [brief list]
**Known issues:** [any 🔵 info not addressed]

**To run:**
[exact commands]
```

---

## Reference Files

Load on demand — not all upfront:

| File | When to load |
|------|--------------|
| `references/plan_template.md` | Phase 1, when creating Plan.md |
| `references/readme_template.md` | Phase 7, when writing a new README |
| `references/stack_hints.md` | Phase 3, for unfamiliar languages or stacks |
| `references/ci_templates.md` | Phase 8, when setting up CI/CD pipelines |

---

## Platform Compatibility

Squirrel is agent-agnostic. It works on any AI coding platform — the phases and principles stay the same regardless of where you run it.

### The key insight: Markdown is universal

Every major AI coding agent reads plain Markdown instructions. The YAML frontmatter above is consumed by OpenCode; other platforms silently ignore unknown fields. The Markdown body — the actual phases, rules, and checklists — works everywhere.

### Installation by platform:

| Platform | Where to put Squirrel | How it loads |
|----------|----------------------|--------------|
| **OpenCode** | `~/.config/opencode/skills/squirrel/SKILL.md` | Auto-detected from skill directory |
| **OpenAI Codex** | `AGENTS.md` in project root | Auto-discovered (primary format) |
| **Claude Code** | `CLAUDE.md` in project root | Auto-discovered; or `@AGENTS.md` import |
| **Cursor** | `.cursor/rules/squirrel.mdc` or `AGENTS.md` | Auto-discovered; both formats supported |
| **Windsurf** | `.windsurf/rules/squirrel.md` | Auto-discovered from rules directory |
| **Aider** | Any `.md` file, load via `--read` | `aider --read squirrel-skill.md` or `.aider.conf.yml` → `read:` |
| **Cline** | `.clinerules/squirrel.md` or `AGENTS.md` | Auto-discovers both + `.cursorrules`, `.windsurfrules` |
| **GitHub Copilot** | `.github/copilot-instructions.md` | Auto-discovered from `.github/` |
| **Antigravity** | `~/.gemini/antigravity/skills/squirrel/SKILL.md` | Auto-discovered from skill directory |

### Minimal setup (covers 4 platforms with one file):

Place `AGENTS.md` at the project root. Natively read by **Codex**, **Cursor**, **Cline**, and **Claude Code** (via `@AGENTS.md` import).

### Full setup (all 9 platforms):

```
project/
├── AGENTS.md                              # Codex + Cursor + Cline + Claude Code
├── .cursor/rules/squirrel.mdc             # Cursor (native rules)
├── .windsurf/rules/squirrel.md            # Windsurf
├── .clinerules/squirrel.md                # Cline (native rules)
├── .github/copilot-instructions.md        # GitHub Copilot
├── CLAUDE.md                              # Claude Code (or just @AGENTS.md import)
├── .aider.conf.yml → read: squirrel.md    # Aider (explicit load)
└── ~/.gemini/antigravity/skills/squirrel/ # Antigravity (global skill directory)
```

For Cursor `.mdc` files, add this frontmatter before the Markdown body:
```yaml
---
description: Squirrel full-cycle development skill
alwaysApply: true
---
```

For Windsurf, add:
```yaml
---
trigger: always_on
description: Squirrel full-cycle development skill
---
```

### Execution model by platform:

**Parallel-capable** (OpenCode, Codex, Cursor, Antigravity):
- Use sub-agent delegation in Phase 3 as described in the Build section
- Maximize throughput by spawning independent work units simultaneously

**Sequential** (Claude Code, Aider, Cline, Windsurf, Copilot):
- Execute phases one at a time
- Still decompose tasks mentally for clarity — just execute sequentially
- The phases and quality gates don't change; only the execution model

**Universal rules (all platforms):**
- The 8-phase pipeline is the same everywhere
- "Respect existing code" is universal
- Phase 1 (Discover) and Phase 8 (Ship checklist) are always required
- Adjust tool commands to what the project uses (`npx` vs `bunx`, `pytest` vs `uv run pytest`, etc.)
- Squirrel's YAML frontmatter is safely ignored by all non-OpenCode platforms

---

## Communication Throughout

- Announce each phase: *"Starting Phase 1 — Audit 🔍"*
- Share the Audit Report before touching any existing code
- Explain non-obvious decisions: *"Kept the existing Jest setup rather than switching to Vitest — no reason to migrate, and it would break the CI config"*
- Close each phase with a status line: *"Phase 4 complete — 31 tests passing (8 new), 91% coverage ✅"*
- Ask when uncertain on important decisions; don't ask about trivial ones

The user should feel like a senior engineer joined their team — someone who read the codebase before the standup, respects what's already been built, and makes everything better without causing chaos.
