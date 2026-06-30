---
description: Health check for authentic-writing. Verifies Bun is installed, the workflow engine is in place, and the output folder is writable.
allowed-tools: Bash
---

# /authentic-writing:doctor

The standard way to diagnose the plugin's own state. Run it after install and any time
`/authentic-writing:write` does not behave.

## Action

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/doctor.sh"
```

| Check | Verifies | Fix |
| --- | --- | --- |
| Bun | the workflow engine runtime is on `PATH` | install from <https://bun.sh> |
| Engine | `~/.claude/workflows/authentic-writing.js` exists | re-run the `SessionStart` hook or `skills/authentic-writing/install.sh` |
| Output | `tmp/authentic-writing/` is writable in this project | check directory permissions |

Exit code is non-zero if any check fails.
