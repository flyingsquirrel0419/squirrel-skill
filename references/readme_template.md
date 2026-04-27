# README Template for Squirrel 🐿️

Reference: https://github.com/matiassingers/awesome-readme

---

## Template

Paste this into the project's README.md and fill in every section. Do NOT leave placeholder text in the final output.

```markdown
<div align="center">

# 🚀 Project Name

[![Build](https://img.shields.io/github/actions/workflow/status/USER/REPO/ci.yml?branch=main)](https://github.com/USER/REPO/actions)
[![Coverage](https://img.shields.io/codecov/c/github/USER/REPO)](https://codecov.io/gh/USER/REPO)
[![License](https://img.shields.io/github/license/USER/REPO)](LICENSE)
[![Version](https://img.shields.io/npm/v/PACKAGE)](https://npmjs.com/package/PACKAGE)

**One sentence that says exactly what this does and why it matters.**

[Demo](https://...) · [Docs](https://...) · [Report Bug](https://github.com/USER/REPO/issues)

</div>

---

## ✨ Features

- **Feature 1** — what it does and why it's compelling
- **Feature 2** — what it does and why it's compelling
- **Feature 3** — what it does and why it's compelling

---

## 🚀 Quick Start

Get running in under 60 seconds:

\`\`\`bash
npm install PACKAGE_NAME
\`\`\`

\`\`\`typescript
import { thing } from 'PACKAGE_NAME'

// Minimal working example — copy, paste, run
const result = thing({ input: 'hello' })
console.log(result) // => 'world'
\`\`\`

---

## 📦 Installation

### Requirements
- Node.js 18+ (or whatever applies)
- [other requirement]

### npm
\`\`\`bash
npm install PACKAGE_NAME
\`\`\`

### yarn
\`\`\`bash
yarn add PACKAGE_NAME
\`\`\`

### From source
\`\`\`bash
git clone https://github.com/USER/REPO.git
cd REPO
npm install
npm run build
\`\`\`

---

## 📖 Usage

### Basic usage
\`\`\`typescript
// Real example. Not pseudocode.
\`\`\`

### Common use case 1
\`\`\`typescript
// Example with output comment showing what it returns
\`\`\`

### Common use case 2
\`\`\`typescript
// Another real example
\`\`\`

---

## ⚙️ Configuration

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `option1` | `string` | `"default"` | What it controls |
| `option2` | `number` | `100` | What it controls |
| `option3` | `boolean` | `false` | What it controls |

---

## 🧪 Development

### Setup
\`\`\`bash
git clone https://github.com/USER/REPO.git
cd REPO
npm install
cp .env.example .env   # configure as needed
\`\`\`

### Run in dev mode
\`\`\`bash
npm run dev
\`\`\`

### Run tests
\`\`\`bash
npm test
npm run test:coverage
\`\`\`

### Lint & format
\`\`\`bash
npm run lint
npm run format
\`\`\`

### Contributing
1. Fork the repo
2. Create a branch: `git checkout -b feature/your-feature`
3. Make changes + add tests
4. Push and open a PR

---

## 📄 License

[MIT](LICENSE) © [Author]
```

---

## What makes a README excellent (checklist)

- [ ] Hero: clear name, badges, one-line description, links to demo/docs
- [ ] Features: 3-5 bullets that sell the project's strengths
- [ ] Quick Start: literally copy-pasteable and works on the first try
- [ ] Usage: real examples, not pseudocode, with expected output shown
- [ ] Configuration: every option documented in a table
- [ ] Development: newcomer can contribute without asking questions
- [ ] All code blocks have language tags (` ```typescript ` not ` ``` `)
- [ ] All links are verified working
- [ ] No "TODO" or placeholder text left in
- [ ] Consistent heading hierarchy (H1 → H2 → H3, never skip)
- [ ] Readable line length (wrap prose at ~80 chars in source)
