# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/); versioning is [SemVer](https://semver.org/).

## [0.1.0] - 2026-06-30

### Added

- Initial release of the `authentic-writing` Claude Code plugin.
- **Router-first writing engine** bundled as the `authentic-writing` skill: 15 calibrated format
  pipelines (Medium, LinkedIn, documentation, narrative, report, GitHub issue, GitHub comment, PR
  comment, press release, changelog, release notes, MVP, POC, note) plus a generic fallback. Each
  pipeline has a persona panel, deterministic format validators, and a green-gate revision loop.
- **`house-voice` reference skill** — two registers (explanatory / engineer) and an LLM-artifact
  blocklist the engine folds in as its tone rubric.
- **`/authentic-writing:write` command** — describe what to write; it routes, applies the house
  voice, and reports the result.
- **`SessionStart` hook** that idempotently installs the workflow engine into `~/.claude/workflows/`.
