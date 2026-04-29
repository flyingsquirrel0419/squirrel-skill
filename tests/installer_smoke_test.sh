#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_file_contains_line() {
  local file="$1"
  local expected="$2"

  grep -Fx -- "$expected" "$file" >/dev/null || fail "Expected line '$expected' in $file"
}

assert_file_starts_with_lines() {
  local file="$1"
  shift
  local expected_lines=("$@")
  local index=1
  local actual_line

  for expected_line in "${expected_lines[@]}"; do
    actual_line="$(sed -n "${index}p" "$file")"
    [[ "$actual_line" == "$expected_line" ]] \
      || fail "Expected line ${index} of $file to be '$expected_line' but was '$actual_line'"
    index=$((index + 1))
  done
}

setup_fixture() {
  local fixture_dir
  fixture_dir="$(mktemp -d)"

  cp "$ROOT_DIR/install.sh" "$fixture_dir/"
  mkdir -p "$fixture_dir/skills/squirrel/references"
  cp "$ROOT_DIR/skills/squirrel/SKILL.md" "$fixture_dir/skills/squirrel/SKILL.md"

  printf '%s\n' "$fixture_dir"
}

test_cursor_frontmatter_uses_real_newlines() {
  local fixture_dir output_file
  fixture_dir="$(setup_fixture)"
  output_file="$fixture_dir/.cursor/rules/squirrel.mdc"

  (
    cd "$fixture_dir"
    bash install.sh --platform cursor >/dev/null
  )

  [[ -f "$output_file" ]] || fail "Cursor install did not create $output_file"
  assert_file_starts_with_lines \
    "$output_file" \
    "---" \
    "description: Squirrel full-cycle development skill" \
    "alwaysApply: true" \
    "---"
  ! grep -F '\\n' "$output_file" >/dev/null || fail "Cursor frontmatter still contains literal \\n sequences"
}

test_custom_nested_path_creates_parent_directories() {
  local fixture_dir output_file
  fixture_dir="$(setup_fixture)"
  output_file="$fixture_dir/nested/dir/AGENTS.md"

  (
    cd "$fixture_dir"
    bash install.sh --platform codex --path ./nested/dir/AGENTS.md >/dev/null
  )

  [[ -f "$output_file" ]] || fail "Custom nested path install did not create $output_file"
}

test_antigravity_creates_skill_directory() {
  local fixture_dir output_dir home_dir
  fixture_dir="$(setup_fixture)"
  home_dir="$(mktemp -d)"
  output_dir="$home_dir/.gemini/antigravity/skills/squirrel"

  (
    cd "$fixture_dir"
    HOME="$home_dir" bash install.sh --platform antigravity >/dev/null
  )

  [[ -f "$output_dir/SKILL.md" ]] || fail "Antigravity install did not create $output_dir/SKILL.md"
  [[ -d "$output_dir/references" ]] || fail "Antigravity install did not copy references"
}

test_docs_use_canonical_repo_slug() {
  local files
  local legacy_owner legacy_repo
  files=(
    "$ROOT_DIR/README.md"
    "$ROOT_DIR/skills/squirrel/SKILL.md"
    "$ROOT_DIR/CHANGELOG.md"
    "$ROOT_DIR/CONTRIBUTING.md"
    "$ROOT_DIR/CODE_OF_CONDUCT.md"
    "$ROOT_DIR/SECURITY.md"
    "$ROOT_DIR/install.sh"
  )
  legacy_owner="flying-squirrel"
  legacy_repo="squirrel-skill"

  ! grep -R -n "${legacy_owner}/${legacy_repo}" "${files[@]}" >/dev/null \
    || fail "Found outdated repo slug in project docs or installer"
}

test_release_docs_match_1_0_0_state() {
  grep -Eq '^## \[1\.0\.0\] - 2026-04-28$' "$ROOT_DIR/CHANGELOG.md" \
    || fail "CHANGELOG.md is missing the 1.0.0 release heading"
  grep -F '[1.0.0]: https://github.com/flyingsquirrel0419/squirrel-skill/releases/tag/v1.0.0' "$ROOT_DIR/CHANGELOG.md" >/dev/null \
    || fail "CHANGELOG.md is missing the 1.0.0 release link"
  ! grep -F 'still pre-release' "$ROOT_DIR/CHANGELOG.md" >/dev/null \
    || fail "CHANGELOG.md still contains pre-release wording"
  ! grep -F 'still pre-release' "$ROOT_DIR/README.md" >/dev/null \
    || fail "README.md still contains pre-release wording"
  ! grep -F 'latest pre-release' "$ROOT_DIR/README.md" >/dev/null \
    || fail "README.md still contains pre-release install wording"
  ! grep -F 'tracks the latest `main` branch version' "$ROOT_DIR/README.md" >/dev/null \
    || fail "README.md still claims install tracks pre-release main"
  ! grep -F 'still pre-release' "$ROOT_DIR/CONTRIBUTING.md" >/dev/null \
    || fail "CONTRIBUTING.md still contains pre-release wording"
  grep -F '| 1.0.x | ✅ |' "$ROOT_DIR/SECURITY.md" >/dev/null \
    || fail "SECURITY.md is missing 1.0.x support policy"
  grep -F '| < 1.0 | ❌ |' "$ROOT_DIR/SECURITY.md" >/dev/null \
    || fail "SECURITY.md is missing unsupported pre-1.0 policy"
}

test_all_contributors_docs_are_wired_up() {
  [[ -f "$ROOT_DIR/.all-contributorsrc" ]] || fail ".all-contributorsrc is missing"
  grep -F '[![All Contributors]' "$ROOT_DIR/README.md" >/dev/null \
    || fail "README.md is missing the All Contributors badge"
  grep -F '<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->' "$ROOT_DIR/README.md" >/dev/null \
    || fail "README.md is missing the All Contributors list start marker"
  grep -F 'npx all-contributors-cli add' "$ROOT_DIR/CONTRIBUTING.md" >/dev/null \
    || fail "CONTRIBUTING.md is missing contributor update instructions"
}

test_pull_request_template_exists() {
  [[ -f "$ROOT_DIR/.github/pull_request_template.md" ]] \
    || fail ".github/pull_request_template.md is missing"
  grep -F '## Summary' "$ROOT_DIR/.github/pull_request_template.md" >/dev/null \
    || fail "Pull request template is missing the summary section"
  grep -F -- '- [ ] Ran `bash tests/installer_smoke_test.sh`' "$ROOT_DIR/.github/pull_request_template.md" >/dev/null \
    || fail "Pull request template is missing the smoke-test checklist item"
}

main() {
  test_cursor_frontmatter_uses_real_newlines
  test_custom_nested_path_creates_parent_directories
  test_antigravity_creates_skill_directory
  test_docs_use_canonical_repo_slug
  test_release_docs_match_1_0_0_state
  test_all_contributors_docs_are_wired_up
  test_pull_request_template_exists
  echo "installer smoke tests: PASS"
}

main "$@"
