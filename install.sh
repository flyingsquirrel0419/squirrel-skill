#!/usr/bin/env bash
#
# Squirrel Skill Installer
# https://github.com/flyingsquirrel0419/squirrel-skill
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main/install.sh | bash
#
# Or clone and run:
#   bash install.sh [--platform <name>] [--path <dir>]
#
set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# --- Defaults ---
PLATFORM=""
CUSTOM_PATH=""
REPO_URL="https://github.com/flyingsquirrel0419/squirrel-skill"
RAW_BASE="https://raw.githubusercontent.com/flyingsquirrel0419/squirrel-skill/main"

# --- Parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform) PLATFORM="$2"; shift 2 ;;
    --path) CUSTOM_PATH="$2"; shift 2 ;;
    --help|-h)
      echo "Usage: bash install.sh [--platform <name>] [--path <dir>]"
      echo ""
      echo "Platforms: opencode, codex, claude-code, cursor, windsurf, aider, cline, copilot"
      echo ""
      echo "Without --platform, auto-detects installed AI agents and installs for all of them."
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# --- Helpers ---
info()  { echo -e "${BLUE}  info${RESET} $*"; }
ok()    { echo -e "${GREEN}  ok${RESET}   $*"; }
warn()  { echo -e "${YELLOW}  warn${RESET} $*"; }
fail()  { echo -e "${RED}  fail${RESET} $*"; exit 1; }

download_skill() {
  local dest="$1"

  mkdir -p "$(dirname "${dest}")"

  if [[ -d "${SCRIPT_DIR}/references" ]]; then
    # Running from cloned repo — copy local files
    cp "${SCRIPT_DIR}/SKILL.md" "${dest}"
    ok "Copied from local repository"
    return 0
  fi

  # Download from GitHub
  info "Downloading SKILL.md..."
  if command -v curl &>/dev/null; then
    curl -fsSL "${RAW_BASE}/SKILL.md" -o "${dest}" || fail "Failed to download SKILL.md"
  elif command -v wget &>/dev/null; then
    wget -q "${RAW_BASE}/SKILL.md" -O "${dest}" || fail "Failed to download SKILL.md"
  else
    fail "Need curl or wget to download"
  fi
  ok "Downloaded SKILL.md"
}

download_with_frontmatter() {
  local dest="$1"
  shift
  local frontmatter="$*"

  mkdir -p "$(dirname "${dest}")"

  if [[ -d "${SCRIPT_DIR}/references" ]]; then
    # Local repo — prepend frontmatter to copy
    printf '%s\n\n' "${frontmatter}" > "${dest}"
    cat "${SCRIPT_DIR}/SKILL.md" >> "${dest}"
    ok "Copied from local repository with frontmatter"
    return 0
  fi

  # Download and prepend frontmatter
  local tmp
  tmp=$(mktemp)
  download_skill "${tmp}"
  printf '%s\n\n' "${frontmatter}" > "${dest}"
  cat "${tmp}" >> "${dest}"
  rm -f "${tmp}"
}

detect_platforms() {
  local platforms=()

  # OpenCode
  if [[ -d "${HOME}/.config/opencode/skills" ]] || [[ -d ".opencode/skills" ]]; then
    platforms+=("opencode")
  fi

  # Codex (AGENTS.md convention)
  if [[ -f "AGENTS.md" ]] || command -v codex &>/dev/null; then
    platforms+=("codex")
  fi

  # Claude Code
  if [[ -f "CLAUDE.md" ]] || [[ -d ".claude" ]]; then
    platforms+=("claude-code")
  fi

  # Cursor
  if [[ -d ".cursor" ]] || [[ -f ".cursorrules" ]]; then
    platforms+=("cursor")
  fi

  # Windsurf
  if [[ -d ".windsurf" ]] || [[ -f ".windsurfrules" ]]; then
    platforms+=("windsurf")
  fi

  # Aider
  if [[ -f ".aider.conf.yml" ]] || command -v aider &>/dev/null; then
    platforms+=("aider")
  fi

  # Cline
  if [[ -d ".clinerules" ]]; then
    platforms+=("cline")
  fi

  # GitHub Copilot
  if [[ -d ".github" ]]; then
    platforms+=("copilot")
  fi

  echo "${platforms[@]}"
}

# --- Install functions ---

install_opencode() {
  local skill_dir="${HOME}/.config/opencode/skills/squirrel"
  mkdir -p "${skill_dir}"
  download_skill "${skill_dir}/SKILL.md"
  ok "Installed for OpenCode at ${skill_dir}/SKILL.md"
}

install_codex() {
  local dest="${CUSTOM_PATH:-AGENTS.md}"
  download_skill "${dest}"
  ok "Installed for Codex at ${dest}"
}

install_claude_code() {
  local dest="${CUSTOM_PATH:-CLAUDE.md}"
  download_skill "${dest}"
  ok "Installed for Claude Code at ${dest}"
}

install_cursor() {
  local dest="${CUSTOM_PATH:-.cursor/rules/squirrel.mdc}"
  download_with_frontmatter "${dest}" $'---\ndescription: Squirrel full-cycle development skill\nalwaysApply: true\n---'
  ok "Installed for Cursor at ${dest}"
}

install_windsurf() {
  local dest="${CUSTOM_PATH:-.windsurf/rules/squirrel.md}"
  download_with_frontmatter "${dest}" $'---\ntrigger: always_on\ndescription: Squirrel full-cycle development skill\n---'
  ok "Installed for Windsurf at ${dest}"
}

install_aider() {
  local dest="${CUSTOM_PATH:-squirrel-skill.md}"
  download_skill "${dest}"
  ok "Installed for Aider at ${dest}"
  echo -e "${DIM}  Load with: aider --read ${dest}${RESET}"
  echo -e "${DIM}  Or add to .aider.conf.yml:  read: ${dest}${RESET}"
}

install_cline() {
  local dest="${CUSTOM_PATH:-.clinerules/squirrel.md}"
  mkdir -p "$(dirname "${dest}")"
  download_skill "${dest}"
  ok "Installed for Cline at ${dest}"
}

install_copilot() {
  local dest="${CUSTOM_PATH:-.github/copilot-instructions.md}"
  mkdir -p "$(dirname "${dest}")"
  download_skill "${dest}"
  ok "Installed for GitHub Copilot at ${dest}"
}

# --- Main ---

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo -e "${BOLD}  Squirrel Skill Installer${RESET}"
echo -e "${DIM}  Full-cycle AI coding skill${RESET}"
echo ""

if [[ -n "${PLATFORM}" ]]; then
  # Explicit platform
  case "${PLATFORM}" in
    opencode)      install_opencode ;;
    codex)         install_codex ;;
    claude-code)   install_claude_code ;;
    cursor)        install_cursor ;;
    windsurf)      install_windsurf ;;
    aider)         install_aider ;;
    cline)         install_cline ;;
    copilot)       install_copilot ;;
    *)             fail "Unknown platform: ${PLATFORM}. Supported: opencode, codex, claude-code, cursor, windsurf, aider, cline, copilot" ;;
  esac
else
  # Auto-detect
  detected=$(detect_platforms)

  if [[ -z "${detected}" ]]; then
    warn "No AI coding agents detected in this directory."
    echo ""
    echo "  Install for a specific platform:"
    echo "    bash install.sh --platform opencode"
    echo "    bash install.sh --platform codex"
    echo "    bash install.sh --platform claude-code"
    echo "    bash install.sh --platform cursor"
    echo "    bash install.sh --platform windsurf"
    echo "    bash install.sh --platform aider"
    echo "    bash install.sh --platform cline"
    echo "    bash install.sh --platform copilot"
    echo ""
    echo "  Or install to a custom path:"
    echo "    bash install.sh --platform codex --path ./my-instructions.md"
    echo ""
    exit 0
  fi

  info "Detected platforms: ${detected}"
  echo ""

  for p in ${detected}; do
    case "${p}" in
      opencode)      install_opencode ;;
      codex)         install_codex ;;
      claude-code)   install_claude_code ;;
      cursor)        install_cursor ;;
      windsurf)      install_windsurf ;;
      aider)         install_aider ;;
      cline)         install_cline ;;
      copilot)       install_copilot ;;
    esac
    echo ""
  done
fi

echo -e "${GREEN}${BOLD}  Done.${RESET} Squirrel is ready to use."
echo -e "${DIM}  Docs: https://github.com/flyingsquirrel0419/squirrel-skill${RESET}"
echo ""
