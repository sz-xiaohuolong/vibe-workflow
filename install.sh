#!/usr/bin/env bash
# Vibe Workflow: Multi-Agent Installer Script
# Supports: OpenAI Codex, Claude Code, Antigravity / Gemini CLI, Cursor, and Project-local (.agents/skills)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SOURCE="${SCRIPT_DIR}/skills/vibe-workflow"

if [[ ! -d "${SKILL_SOURCE}" ]]; then
  echo "Error: Skill source directory not found at ${SKILL_SOURCE}" >&2
  exit 1
fi

print_usage() {
  cat <<EOF
Vibe Workflow Multi-Agent Installer

Usage:
  ./install.sh [agent] [options]

Supported agents:
  claude      Install globally for Claude Code (~/.claude/skills/vibe-workflow)
  codex       Install globally for OpenAI Codex (~/.codex/skills/vibe-workflow)
  gemini      Install globally for Antigravity / Gemini (~/.gemini/config/skills/vibe-workflow)
  project     Install to current project directory (.agents/skills/vibe-workflow)
  cursor      Generate Cursor rules in current workspace (.cursor/rules/vibe-workflow.mdc)
  all         Install to all detected agent environments

Options:
  --help, -h  Show this help message
EOF
}

install_to_dir() {
  local target_dir="$1"
  local agent_name="$2"

  echo "Installing Vibe Workflow for ${agent_name}..."
  if [[ -L "${target_dir}" ]]; then
    local link_target
    link_target="$(readlink "${target_dir}" || true)"
    if [[ "${link_target}" == "${SKILL_SOURCE}" ]]; then
      echo "✓ Already linked to source repository: ${target_dir}"
      return 0
    fi
    rm -f "${target_dir}"
  fi

  mkdir -p "${target_dir}"
  # Sync files cleanly
  rm -rf "${target_dir:?}"/*
  cp -R "${SKILL_SOURCE}/"* "${target_dir}/"
  echo "✓ Successfully installed to: ${target_dir}"
}

install_claude() {
  local target="${HOME}/.claude/skills/vibe-workflow"
  install_to_dir "${target}" "Claude Code"
}

install_codex() {
  local target="${HOME}/.codex/skills/vibe-workflow"
  install_to_dir "${target}" "OpenAI Codex"
}

install_gemini() {
  local target="${HOME}/.gemini/config/skills/vibe-workflow"
  install_to_dir "${target}" "Antigravity / Gemini CLI"
}

install_project() {
  local target="./.agents/skills/vibe-workflow"
  install_to_dir "${target}" "Project (.agents/skills)"
}

install_cursor() {
  local target_dir="./.cursor/rules"
  mkdir -p "${target_dir}"
  cat <<'EOF' > "${target_dir}/vibe-workflow.mdc"
---
description: Lifecycle Orchestrator for long-running software engineering projects.
globs: *
alwaysApply: false
---

# Vibe Workflow Instructions

When coordinating multi-session, multi-release, or complex software development:
1. Requirements Freeze: Never write implementation code until requirements are frozen and open questions are resolved.
2. Repository as Memory: The repository (code, git, tests, docs/vibe/) is the sole source of truth.
3. Decision Gates: Human approval is strictly required before changing product scope, schema/migrations, public APIs, or credentials.
4. Circuit Breaker: Stop patching after 3 consecutive failures; capture a debug snapshot and replan.
5. Evidence-based Completion: Never declare done without fresh, passing test/build verification evidence.

For detailed templates and references, see: skills/vibe-workflow/
EOF
  echo "✓ Successfully generated Cursor rule at: ${target_dir}/vibe-workflow.mdc"
}

install_all_detected() {
  local installed_any=false

  # Check Claude Code
  if [[ -d "${HOME}/.claude" ]] || command -v claude >/dev/null 2>&1; then
    install_claude
    installed_any=true
  fi

  # Check Codex
  if [[ -d "${HOME}/.codex" ]] || command -v codex >/dev/null 2>&1; then
    install_codex
    installed_any=true
  fi

  # Check Gemini / Antigravity
  if [[ -d "${HOME}/.gemini" ]]; then
    install_gemini
    installed_any=true
  fi

  # Always offer project-local installation if git root
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    install_project
    installed_any=true
  fi

  if [[ "${installed_any}" == false ]]; then
    echo "No standard global agent directories found. Installing to local project (.agents/skills/)..."
    install_project
  fi
}

# Parse Arguments
AGENT="${1:-auto}"
case "${AGENT}" in
  claude|--claude)
    install_claude
    ;;
  codex|--codex)
    install_codex
    ;;
  gemini|antigravity|--gemini)
    install_gemini
    ;;
  project|local|--project)
    install_project
    ;;
  cursor|--cursor)
    install_cursor
    ;;
  all|--all)
    install_claude
    install_codex
    install_gemini
    install_project
    install_cursor
    ;;
  auto)
    install_all_detected
    ;;
  -h|--help|help)
    print_usage
    exit 0
    ;;
  *)
    echo "Unknown option: ${AGENT}" >&2
    print_usage
    exit 1
    ;;
esac

echo ""
echo "Vibe Workflow installation complete! Start using it in your next agent prompt."
