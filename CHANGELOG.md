# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/); versioning is [SemVer](https://semver.org/).

## [0.2.0] - 2026-06-30

### Added

- `onboarding` skill — first-run orientation.
- `/authentic-writing:doctor` command + `scripts/doctor.sh` — health check (Bun, engine, output dir).
- `CLAUDE.md` contributor guide and a minimal CI workflow.
- README reshaped to the odere-pro standard skeleton, with a Privacy note.

### Changed

- Relicensed Apache-2.0 → MIT (odere-pro suite standard); removed `NOTICE`.
- Canonical author: Oleksandr Derechei.

## [0.1.0] - 2026-06-30

### Added

- Initial release of the `authentic-writing` Claude Code plugin.
- Router-first writing engine: 15 calibrated format pipelines plus a generic fallback, a persona
  panel, deterministic validators, and a green-gate revision loop.
- `house-voice` reference skill; `/authentic-writing:write` command; `SessionStart` hook that
  installs the workflow engine into `~/.claude/workflows/`.
