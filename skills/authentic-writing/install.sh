#!/usr/bin/env bash
# install.sh — auto-installer for the authentic-writing skill + workflow.
# Idempotent: safe to run any number of times. Copies the bundled workflow
# engine into the local Claude config so `Workflow({ name: 'authentic-writing' })`
# and the `/authentic-writing` skill work immediately.
set -euo pipefail

# Resolve the directory this script (and the skill bundle) lives in.
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENGINE="${SRC_DIR}/authentic-writing.js"
SKILL_MD="${SRC_DIR}/SKILL.md"

if [[ ! -f "${ENGINE}" ]]; then
  echo "error: bundled workflow engine not found at ${ENGINE}" >&2
  exit 1
fi

# Copy SRC to DEST unless they are the same file (so re-running from the
# installed location is a clean no-op instead of a `cp: identical` error).
safe_cp() {
  local src="$1" dest="$2"
  if [[ -e "${dest}" ]] && [[ "${src}" -ef "${dest}" ]]; then
    return 0
  fi
  cp "${src}" "${dest}"
}

HOME_CLAUDE="${HOME}/.claude"
GLOBAL_WF_DIR="${HOME_CLAUDE}/workflows"
GLOBAL_SKILL_DIR="${HOME_CLAUDE}/skills/authentic-writing"

placed=()

# --- 1. Global workflow engine -----------------------------------------------
mkdir -p "${GLOBAL_WF_DIR}"
safe_cp "${ENGINE}" "${GLOBAL_WF_DIR}/authentic-writing.js"
placed+=("${GLOBAL_WF_DIR}/authentic-writing.js")

# --- 2. Global skill folder (engine + SKILL.md + this installer) --------------
mkdir -p "${GLOBAL_SKILL_DIR}"
safe_cp "${ENGINE}" "${GLOBAL_SKILL_DIR}/authentic-writing.js"
safe_cp "${SKILL_MD}" "${GLOBAL_SKILL_DIR}/SKILL.md"
safe_cp "${BASH_SOURCE[0]}" "${GLOBAL_SKILL_DIR}/install.sh"
# Progressive-disclosure assets (sync when present).
[[ -f "${SRC_DIR}/reference.md" ]] && safe_cp "${SRC_DIR}/reference.md" "${GLOBAL_SKILL_DIR}/reference.md"
for sub in examples scripts; do
  if [[ -d "${SRC_DIR}/${sub}" ]] && [[ "${SRC_DIR}/${sub}" -ef "${GLOBAL_SKILL_DIR}/${sub}" ]]; then
    : # source == destination, nothing to copy
  elif [[ -d "${SRC_DIR}/${sub}" ]]; then
    rm -rf "${GLOBAL_SKILL_DIR}/${sub}"
    cp -R "${SRC_DIR}/${sub}" "${GLOBAL_SKILL_DIR}/${sub}"
  fi
done
placed+=("${GLOBAL_SKILL_DIR}/")

# --- 3. Project workflow engine (when run inside a repo with .claude) ---------
# Walk up from the current working directory to find a project .claude folder.
find_project_claude() {
  local dir="${PWD}"
  while [[ "${dir}" != "/" ]]; do
    if [[ -d "${dir}/.claude" ]]; then
      echo "${dir}/.claude"
      return 0
    fi
    dir="$(dirname "${dir}")"
  done
  return 1
}

if PROJECT_CLAUDE="$(find_project_claude)"; then
  if [[ "${PROJECT_CLAUDE}" != "${HOME_CLAUDE}" ]]; then
    mkdir -p "${PROJECT_CLAUDE}/workflows"
    cp "${ENGINE}" "${PROJECT_CLAUDE}/workflows/authentic-writing.js"
    placed+=("${PROJECT_CLAUDE}/workflows/authentic-writing.js")
  fi
fi

# --- Verify -------------------------------------------------------------------
echo "authentic-writing installed:"
ok=1
for p in "${placed[@]}"; do
  if [[ -e "${p%/}" || -d "${p}" ]]; then
    echo "  ✓ ${p}"
  else
    echo "  ✗ ${p} (missing!)"
    ok=0
  fi
done

if [[ "${ok}" -ne 1 ]]; then
  echo "error: one or more destinations were not created" >&2
  exit 1
fi

echo "Done. Use it with: /authentic-writing  (or Workflow name 'authentic-writing')."
