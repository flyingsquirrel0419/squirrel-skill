# CI/CD Templates — Squirrel 🐿️

Ready-to-use CI configurations for common stacks. Pick the one that matches your project, customize the variables at the top, and drop it into `.github/workflows/ci.yml`.

---

## GitHub Actions — Node.js / TypeScript

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20, 22]

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      - run: npm ci
      - run: npm run lint --if-present
      - run: npm run typecheck --if-present
      - run: npm test
      - run: npm run build --if-present

      - name: Upload coverage
        if: matrix.node-version == 22
        uses: codecov/codecov-action@v4
        with:
          token: ${{ secrets.CODECOV_TOKEN }}
```

---

## GitHub Actions — Python

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ['3.10', '3.11', '3.12']

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: 'pip'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
          pip install pytest pytest-cov mypy bandit

      - name: Lint
        run: |
          python -m mypy src/ --ignore-missing-imports || true
          python -m bandit -r src/ -f json || true

      - name: Test
        run: |
          pytest --cov=src --cov-report=xml --cov-report=term-missing -v

      - name: Upload coverage
        if: matrix.python-version == '3.12'
        uses: codecov/codecov-action@v4
        with:
          token: ${{ secrets.CODECOV_TOKEN }}
```

---

## GitHub Actions — Go

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Go
        uses: actions/setup-go@v5
        with:
          go-version: '1.22'

      - name: Vet
        run: go vet ./...

      - name: Test
        run: go test ./... -v -race -coverprofile=coverage.out

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          token: ${{ secrets.CODECOV_TOKEN }}
          files: ./coverage.out
```

---

## GitHub Actions — Rust

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  CARGO_TERM_COLOR: always

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Clippy
        run: cargo clippy -- -D warnings

      - name: Format check
        run: cargo fmt -- --check

      - name: Test
        run: cargo test --verbose

      - name: Build
        run: cargo build --release --verbose
```

---

## GitHub Actions — Ruby

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        ruby-version: ['3.2', '3.3']

    steps:
      - uses: actions/checkout@v4

      - name: Setup Ruby ${{ matrix.ruby-version }}
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ matrix.ruby-version }}
          bundler-cache: true

      - name: Lint
        run: bundle exec rubocop

      - name: Test
        run: bundle exec rspec
```

---

## GitHub Actions — Java (Gradle)

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        java-version: [17, 21]

    steps:
      - uses: actions/checkout@v4

      - name: Setup Java ${{ matrix.java-version }}
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: ${{ matrix.java-version }}

      - name: Setup Gradle
        uses: gradle/actions/setup-gradle@v4

      - name: Lint
        run: ./gradlew spotlessCheck

      - name: Test
        run: ./gradlew test

      - name: Build
        run: ./gradlew build
```

---

## GitHub Actions — .NET

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        dotnet-version: ['8.0', '9.0']

    steps:
      - uses: actions/checkout@v4

      - name: Setup .NET ${{ matrix.dotnet-version }}
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ matrix.dotnet-version }}

      - name: Restore
        run: dotnet restore

      - name: Build
        run: dotnet build --no-restore

      - name: Test
        run: dotnet test --no-build --collect:"XPlat Code Coverage"
```

---

## GitHub Actions — Release / Publish (npm)

Add this as `.github/workflows/release.yml` for automatic npm publishing on tag push:

```yaml
name: Release

on:
  push:
    tags: ['v*']

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      id-token: write

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 22
          registry-url: 'https://registry.npmjs.org'

      - run: npm ci
      - run: npm run build --if-present
      - run: npm test
      - run: npm publish --provenance --access public
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

---

## GitHub Actions — Release / Publish (PyPI)

```yaml
name: Release

on:
  push:
    tags: ['v*']

jobs:
  publish:
    runs-on: ubuntu-latest
    permissions:
      id-token: write

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'

      - name: Install build tools
        run: pip install build

      - name: Build package
        run: python -m build

      - name: Publish to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1
```

---

## Setup checklist

After adding CI, verify:

- [ ] `.github/workflows/ci.yml` exists and runs on push/PR
- [ ] Badge added to README: `![CI](https://github.com/USER/REPO/actions/workflows/ci.yml/badge.svg)`
- [ ] Secrets configured in GitHub repo settings (`NPM_TOKEN`, `CODECOV_TOKEN`, `PYPI_API_TOKEN`, etc.)
- [ ] CI runs green on the first push — if not, fix before shipping
- [ ] Release workflow tested with a `v0.1.0` tag (dry-run first)
