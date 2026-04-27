# Security Policy

## Supported Versions

| Version | Supported |
| ------- | --------- |
| 1.0.x   | ✅ |
| < 1.0   | ❌ |

## Reporting a Vulnerability

**Do not file public issues for security vulnerabilities.**

If you discover a security vulnerability in Squirrel Skill, please report it responsibly:

### Preferred method: GitHub Security Advisories

1. Go to [github.com/flying-squirrel/squirrel-skill/security/advisories/new](https://github.com/flying-squirrel/squirrel-skill/security/advisories/new)
2. Fill in the details: description, affected versions, and impact
3. Submit as a **private** security advisory

### Alternative: Email

Send a detailed report to the maintainer via GitHub DM or the contact method listed in the repository.

### What to include in your report

- **Description** of the vulnerability
- **Affected file(s)** and line number(s)
- **Steps to reproduce** (if applicable)
- **Potential impact** (e.g., what an attacker could exploit)
- **Suggested fix** (optional, but appreciated)

### Response timeline

| Stage | Expected timeframe |
|-------|--------------------|
| Acknowledgment | Within 48 hours |
| Initial assessment | Within 5 business days |
| Fix or mitigation plan | Within 14 business days |
| Public disclosure (if applicable) | After fix is released |

### Disclosure policy

- We practice **coordinated disclosure** — vulnerabilities are published only after a fix is available.
- We will credit the reporter in the advisory unless they request anonymity.
- We ask that reporters do not disclose the vulnerability publicly until the fix is published.

## Scope

This security policy covers the Squirrel Skill source files (`SKILL.md`, reference templates, and documentation). Since Squirrel is a prompt/instruction file consumed by AI agents, "vulnerabilities" in this context include:

- Instructions that could cause the AI agent to produce insecure code patterns (e.g., skipping input validation, using plaintext passwords)
- Templates that include outdated or insecure defaults
- Missing security guidance that a reasonable developer would expect

Out of scope:

- Vulnerabilities in projects *built using* Squirrel Skill (those are the responsibility of the project's own security policy)
- AI agent behavior outside of what Squirrel's instructions direct
