# authentic-writing

A Claude Code plugin that writes in your voice. You describe what you want — a Medium article, a
LinkedIn post, a changelog — and it routes the request to a calibrated pipeline, drafts it, runs a
panel of readers that grills the draft, and revises until it reads like a person wrote it.

## What's inside

| Component | What it does |
| --- | --- |
| `authentic-writing` skill | The router-first engine: 15 calibrated format pipelines (Medium, LinkedIn, docs, report, changelog, and more) plus a generic fallback, each with a persona panel, deterministic validators, and a green-gate loop |
| `house-voice` skill | The tone rubric the engine obeys: two registers (explanatory / engineer) and an LLM-artifact blocklist |
| `onboarding` skill | First-run orientation |
| `/authentic-writing:write` | The entry point — describe the piece, get it written |
| `/authentic-writing:doctor` | Health check (Bun, engine, output folder) |

## How it works

The engine spawns a small persona panel for each draft: a subject-matter expert who writes the
source-grounded first draft, a format expert who applies the skeleton, newcomer and pro readers who
judge whether the value lands, and an always-on judge that adversarially stress-tests every round. A
draft ships only when the judge passes it, every reviewer scores it at least 4 of 5, and the
deterministic validators report zero blocking violations. Each format is its own pipeline with its
own reader and hard rules — a LinkedIn post is held to a 3000-character limit and a hook in the first
line; a Medium article to section dividers, a TL;DR, and length.

## Prerequisites

| Tool | Purpose | Install |
| --- | --- | --- |
| **Bun** `>= 1.2` | Runs the workflow engine | `curl -fsSL https://bun.sh/install \| bash` |
| `bash`, `git` | Hook + installer | Pre-installed on macOS / Linux |

`/authentic-writing:doctor` checks these and tells you what to install.

## Install

```text
/plugin marketplace add odere-pro/claude-software-3-0-marketplace
/plugin install authentic-writing
```

A `SessionStart` hook installs the engine into `~/.claude/workflows/` on first run. Run
`/authentic-writing:doctor` once after install to confirm everything is in place.

## Quickstart

```text
/authentic-writing:write a LinkedIn post about my obsidian wiki experiment
/authentic-writing:write a Medium article on why I dropped RAG for deterministic retrieval
/authentic-writing:write release notes for v2.0
```

Describe the piece in plain language; the plugin picks the format, applies your house voice, and
writes the result to `tmp/authentic-writing/`. It reports which pipeline ran, whether the draft
passed the gate, and anything still open. To ground a piece in real material, mention it and point at
the files — the subject-matter persona quotes from them instead of inventing.

| You ask for | Pipeline |
| --- | --- |
| a Medium / blog article | `medium` |
| a LinkedIn post | `linkedin` |
| docs, report, narrative | `documentation` / `report` / `narrative` |
| a GitHub issue / comment / PR comment | `github-issue` / `github-comment` / `pr-comment` |
| a press release, changelog, release notes | `press-release` / `changelog` / `release-notes` |
| an MVP / POC / note | `mvp` / `poc` / `note` |
| anything else | `generic` |

## Documentation

- The `house-voice` skill is the tone rubric the engine obeys; edit it to tune your voice.
- Conventions this plugin follows: [odere-pro plugin conventions](https://github.com/odere-pro/claude-software-3-0-marketplace/blob/main/CONVENTIONS.md).
- Release history: [CHANGELOG.md](./CHANGELOG.md).

## Privacy

No telemetry. The plugin never phones home. Everything runs in your session — your files, your hooks,
your shell. Output stays in your project's `tmp/authentic-writing/`.

## License

MIT. See [LICENSE](./LICENSE).
