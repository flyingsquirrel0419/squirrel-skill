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

  cp "$ROOT_DIR/install.sh" "$ROOT_DIR/SKILL.md" "$fixture_dir/"
  mkdir -p "$fixture_dir/references"

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

test_docs_use_canonical_repo_slug() {
  local files
  local legacy_owner legacy_repo
  files=(
    "$ROOT_DIR/README.md"
    "$ROOT_DIR/SKILL.md"
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

test_changelog_does_not_claim_unreleased_version_is_shipped() {
  ! grep -Eq '^## \[1\.0\.0\] - ' "$ROOT_DIR/CHANGELOG.md" \
    || fail "CHANGELOG.md still claims 1.0.0 has been released"
}

main() {
  test_cursor_frontmatter_uses_real_newlines
  test_custom_nested_path_creates_parent_directories
  test_docs_use_canonical_repo_slug
  test_changelog_does_not_claim_unreleased_version_is_shipped
  echo "installer smoke tests: PASS"
}

main "$@"
