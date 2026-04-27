# Contributing to Squirrel 🐿️

First off, thanks for taking the time to contribute. Squirrel is better because of people like you.

---

## Quick Start

1. Fork the repository
2. Create a branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Test on at least one supported platform
5. Push and open a Pull Request

That's it. Read on for the details.

---

## What You Can Contribute

### Bug fixes

If you find an instruction that leads to incorrect, insecure, or unexpected AI behavior:

1. Check [existing issues](https://github.com/flying-squirrel/squirrel-skill/issues) to see if it's already reported
2. If not, open a new issue with:
   - Which AI platform you were using
   - Which programming language / stack
   - Which phase produced the bad behavior
   - What you expected vs. what happened
   - The relevant section of `SKILL.md` (line numbers help)

### New language / stack support

Squirrel aims to be stack-agnostic. If your language or framework is underrepresented:

- **`references/stack_hints.md`**: Add a new `## Language / Framework` section with common pitfalls and good patterns. Follow the existing format.
- **`references/ci_templates.md`**: Add a new CI template for your ecosystem. Follow the existing format.
- **`SKILL.md`**: Only edit if the main pipeline instructions assume something that doesn't apply to your stack (e.g., if a command example is npm-only and your stack needs something different).

### New platform support

If you want to add support for a new AI coding agent:

1. Research how the platform loads custom instructions (file name, format, frontmatter)
2. Add it to the `platforms:` list in SKILL.md frontmatter
3. Add installation instructions in the Platform Compatibility section
4. Add an execution model entry (parallel-capable or sequential)
5. Update README.md with the new installation method
6. Test that the Markdown body loads correctly on the new platform

### Improvements to existing content

- **Clearer instructions**: If a phase description is ambiguous, reword it
- **Better examples**: If a code example is language-specific where it shouldn't be, generalize it
- **Missing edge cases**: If a checklist misses something you've hit in practice, add it
- **Typos and grammar**: PRs welcome, no issue needed

---

## Style Guide

### SKILL.md

- **Plain Markdown only.** No HTML, no LaTeX, no platform-specific syntax.
- **One imperative per instruction.** "Run the test suite" not "You should probably run the test suite".
- **Stack-agnostic language.** Show all relevant stacks equally. Don't default to npm/Node.js.
- **Code blocks must have language tags.** Use `bash` for shell commands, `typescript`/`python`/`go`/`rust` etc. for code.

### Reference files

- Follow the existing format exactly (headers, bullet style, code block structure).
- Every language section needs both **Common pitfalls** and **Good patterns**.
- CI templates must use GitHub Actions (that's our CI standard for now).

### Commit messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add Ruby stack hints and CI template
fix: correct test detection patterns for Java
docs: update platform compatibility table
refactor: reorganize Phase 6 formatter detection
```

---

## Pull Request Process

1. **One concern per PR.** Don't bundle a bug fix with a new feature and a refactor. Keep it focused.
2. **Test your change.** Load the modified SKILL.md in at least one AI coding agent and verify it works. Mention which platform(s) you tested in the PR description.
3. **Update documentation.** If you change SKILL.md, check if README.md or CHANGELOG.md need updates too.
4. **PR description template:**

```markdown
## What changed
[brief description]

## Why
[context / motivation]

## Tested on
- [ ] OpenCode
- [ ] Codex
- [ ] Claude Code
- [ ] Cursor
- [ ] Windsurf
- [ ] Aider
- [ ] Cline
- [ ] GitHub Copilot

## Checklist
- [ ] SKILL.md follows the style guide
- [ ] README.md updated (if needed)
- [ ] CHANGELOG.md updated (if needed)
- [ ] No platform-specific syntax in SKILL.md
```

5. **Review.** Maintainers will review within 5 business days. Be responsive to feedback.

---

## Reporting Issues

### Bug reports

Use the [GitHub issue template](https://github.com/flying-squirrel/squirrel-skill/issues/new). Include:

- Platform (which AI agent)
- Stack (language / framework)
- Phase where the issue occurred
- Expected vs. actual behavior
- SKILL.md line numbers if relevant

### Feature requests

Open an issue with the `feature-request` label. Describe:

- What you want Squirrel to do
- Why the current behavior is insufficient
- Any alternatives you've considered

### Security vulnerabilities

**Do not file a public issue.** See [SECURITY.md](SECURITY.md) for responsible disclosure.

---

## Development Setup

No build tools needed — Squirrel is plain Markdown files.

```bash
# Clone
git clone https://github.com/flying-squirrel/squirrel-skill.git
cd squirrel-skill

# Edit
vim squirrel/SKILL.md
# or
vim squirrel/references/stack_hints.md

# Test — load SKILL.md into your AI agent and run a task
# (see README.md for platform-specific installation)
```

### File structure

```
squirrel/
├── SKILL.md                        # Main skill — single source of truth
├── README.md                       # Project documentation
├── CHANGELOG.md                    # Version history
├── CONTRIBUTING.md                 # This file
├── SECURITY.md                     # Vulnerability reporting
├── CODE_OF_CONDUCT.md              # Community standards
├── LICENSE                         # Apache 2.0
└── references/
    ├── ci_templates.md             # CI/CD pipeline templates
    ├── plan_template.md            # Project plan template
    ├── readme_template.md          # README template
    └── stack_hints.md              # Language-specific best practices
```

---

## Questions?

Open a [GitHub Discussion](https://github.com/flying-squirrel/squirrel-skill/discussions) for general questions that aren't bugs or feature requests.

---

Thank you for contributing to Squirrel. Every improvement makes the AI coding experience better for everyone.
