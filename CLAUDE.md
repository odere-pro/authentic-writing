# authentic-writing — plugin repo

Source of the `authentic-writing` Claude Code plugin: a router-first writing engine that turns a
request into a polished piece in a chosen format (Medium, LinkedIn, docs, report, changelog, and
more), in a consistent house voice.

## Layout

| Path | Responsibility |
| --- | --- |
| `skills/authentic-writing/` | The engine: `authentic-writing.js` (the `PIPELINES` map + persona panel + validators), `SKILL.md` (the router), `reference.md` (per-pipeline rubric), `install.sh` (places the engine at `~/.claude/workflows/`), `examples/` (deterministic fixtures). |
| `skills/house-voice/` | The tone rubric the engine obeys: two registers + the LLM-artifact blocklist. |
| `skills/onboarding/` | First-run orientation. |
| `commands/write.md` | `/authentic-writing:write` — the entry point. |
| `commands/doctor.md` | `/authentic-writing:doctor` — health check (`scripts/doctor.sh`). |
| `hooks/hooks.json` | `SessionStart` auto-installs the engine. |

## Conventions

This plugin follows the odere-pro plugin conventions
([`CONVENTIONS.md`](https://github.com/odere-pro/claude-software-3-0-marketplace/blob/main/CONVENTIONS.md)):
MIT licensed; author `Oleksandr Derechei`; one entry verb + `onboarding` + a `doctor`; the standard
README skeleton; no telemetry.

## Dev

- `bash skills/authentic-writing/install.sh` — install the engine locally.
- `node skills/authentic-writing/scripts/validate-examples.mjs` — run the deterministic format fixtures.
- `claude plugin validate .` — validate the plugin manifest.
- `bash scripts/doctor.sh` — run the health check.

The engine (`authentic-writing.js`) is kept byte-identical to the upstream global skill so the two
stay in sync; wiring lives in the hook and the commands, not in the engine.
