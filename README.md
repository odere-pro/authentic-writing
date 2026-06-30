# authentic-writing

A Claude Code plugin that writes in your voice. You describe what you want — a Medium article, a
LinkedIn post, a changelog — and it routes the request to a calibrated pipeline, drafts it, runs a
panel of readers that grills the draft, and revises until it reads like a person wrote it.

It is a **router-first** engine: each format is its own pipeline with its own reader, structural
skeleton, and hard rules. A LinkedIn post is checked against a 3000-character limit and a hook that
has to land in the first line; a Medium article is checked for section dividers, a TL;DR, and length.
Anything that does not match a known format falls back to a generic pipeline.

## Install

```text
/plugin marketplace add odere-pro/claude-software-3-0-marketplace
/plugin install authentic-writing
```

Requires **Bun** (the workflow engine runtime) and `bash`. A `SessionStart` hook installs the engine
into `~/.claude/workflows/` on first run, so there is nothing to set up by hand.

## Use it

```text
/authentic-writing:write a LinkedIn post about my obsidian wiki experiment
/authentic-writing:write a Medium article on why I dropped RAG for deterministic retrieval
/authentic-writing:write release notes for v2.0
```

Describe the piece in plain language. The plugin picks the format, applies your house voice, and
writes the result to `tmp/authentic-writing/` at the project root. It reports which pipeline ran,
whether the draft passed the gate, and anything still open — blocking rule violations, image/table
placeholders, or questions the judge could not resolve.

To ground a piece in real material, mention it ("about my X project") and point at the files; the
subject-matter persona quotes from them instead of inventing.

## Formats

| You ask for | Pipeline |
|---|---|
| a Medium / blog article | `medium` |
| a LinkedIn post | `linkedin` |
| docs / a how-to | `documentation` |
| a story / essay | `narrative` |
| an analysis / report | `report` |
| a GitHub issue / comment | `github-issue` / `github-comment` |
| a PR / code-review comment | `pr-comment` |
| a press release | `press-release` |
| a changelog / release notes | `changelog` / `release-notes` |
| an MVP / POC writeup | `mvp` / `poc` |
| a quick note | `note` |
| anything else | `generic` |

## The house voice

The `house-voice` skill is the tone rubric the engine obeys. It defines two registers — explanatory
for the "what and why", engineer for the load-bearing detail — and a blocklist of phrasings that read
as machine-written (hype adjectives, filler openers, the "not just X, it's Y" frame, and the rest).
The grill-me judge fails any draft that reuses them. Edit the skill to make the output sound more
like you.

## How it works

The engine spawns a small persona panel for each draft: a subject-matter expert who writes the
source-grounded first draft, a format/ship expert who applies the skeleton, newcomer and pro readers
who judge whether the value lands, and an always-on judge who adversarially stress-tests every round.
A draft ships only when the judge passes it, every reviewer scores it at least 4 of 5, and the
deterministic validators report zero blocking violations.

## License

Apache-2.0. See [LICENSE](./LICENSE) and [NOTICE](./NOTICE).
