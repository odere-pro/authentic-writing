#!/usr/bin/env bash
# doctor.sh — health check for the authentic-writing plugin.
# Verifies the engine can run: Bun present, workflow engine installed, output writable.
set -uo pipefail

pass=0 warn=0 fail=0
ok()   { printf '  ✓ %s\n' "$1"; pass=$((pass+1)); }
note() { printf '  ! %s\n' "$1"; warn=$((warn+1)); }
bad()  { printf '  ✗ %s — %s\n' "$1" "$2"; fail=$((fail+1)); }

echo "authentic-writing doctor"

# D1 — Bun (the workflow engine runtime)
if command -v bun >/dev/null 2>&1; then ok "Bun present ($(bun --version 2>/dev/null))"
else bad "Bun" "install from https://bun.sh — the workflow engine needs it"; fi

# D2 — workflow engine installed where the Workflow tool resolves it
ENGINE="${HOME}/.claude/workflows/authentic-writing.js"
if [ -f "$ENGINE" ]; then ok "engine installed ($ENGINE)"
else note "engine not yet installed — the SessionStart hook installs it on next session, or run: bash \"${CLAUDE_PLUGIN_ROOT:-.}/skills/authentic-writing/install.sh\""; fi

# D3 — output directory writable
if mkdir -p tmp/authentic-writing 2>/dev/null && [ -w tmp/authentic-writing ]; then ok "output writable (tmp/authentic-writing/)"
else bad "output dir" "cannot write tmp/authentic-writing/ in this project"; fi

echo "doctor: ${pass} ok, ${warn} warn, ${fail} fail"
[ "$fail" -eq 0 ]
