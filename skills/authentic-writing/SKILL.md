---
name: authentic-writing
description: Router-first skill for producing easy-to-read, authentic content in a chosen format (notes, documentation, narrative stories, Medium articles, LinkedIn posts, MVP/POC writeups, reports, GitHub issues/comments, PR comments, press releases, changelogs, release notes). Use when the user wants a polished piece of writing that is genuinely clear and true to a real human voice. It first routes the request to one calibrated per-format pipeline (or a generic pipeline when nothing matches), then drives a format-aware persona panel (domain SME, newcomer, pro + non-pro reader, format/ship expert, always-on grill-me judge) plus deterministic format validators until it reads cleanly and survives stress testing.
disable-model-invocation: true
---

# Authentic Writing

A **router-first** writing skill. On every invocation it (1) routes the request to the right calibrated *pipeline*, (2) makes sure the workflow engine is installed, (3) drives that pipeline's persona panel + validators, and (4) reports the result. Each format is its own calibrated pipeline; anything that doesn't match falls back to a **generic pipeline**.

## Step 1 — Route the request (do this first)

Read the user's intent and pick exactly one pipeline. Map natural language → a `format` key:

| The user wants… | `format` |
|---|---|
| a quick note / memo | `note` |
| docs / a how-to / guide | `documentation` |
| a story / essay | `narrative` |
| a Medium / blog article | `medium` |
| a LinkedIn post | `linkedin` |
| an MVP spec | `mvp` |
| a proof-of-concept writeup | `poc` |
| an analysis / report | `report` |
| a GitHub issue / bug | `github-issue` |
| a GitHub comment | `github-comment` |
| a PR / code-review comment | `pr-comment` |
| a press release / announcement | `press-release` |
| a changelog | `changelog` |
| release notes | `release-notes` |

Then:

- **Confident match** → state the chosen pipeline and its reader (see `reference.md` for each pipeline's audience + must-haves), then proceed.
- **Ambiguous** (fits several) → ask the user one short question to pick.
- **No match** → use `format: 'generic'` and say so explicitly.

The engine also routes defensively: any unrecognized `format` falls back to the generic pipeline.

## Step 2 — Ensure the workflow engine is installed

Check whether `~/.claude/workflows/authentic-writing.js` exists. If it is missing, run the bundled installer (idempotent, safe to re-run):

```bash
bash ~/.claude/skills/authentic-writing/install.sh
```

If the script cannot run, copy the engine manually:

```bash
mkdir -p ~/.claude/workflows
cp ~/.claude/skills/authentic-writing/authentic-writing.js ~/.claude/workflows/authentic-writing.js
```

## Step 3 — Gather args

- **format** (required) — the pipeline key resolved in Step 1.
- **domain** — subject-matter area, used to build the SME + newcomer personas (e.g. "Agentic Engineering / New SDLC"). Fully generic.
- **brief** (required unless `sourcePaths` given) — what to write, in one or two sentences.
- **sourcePaths** (optional) — files to ground the writing in; the SME reads and quotes them.
- **audience** (optional) — overrides the pipeline's default reader.
- **tone** (optional) — e.g. "warm and practical".
- **outPath** (optional) — defaults to `./tmp/authentic-writing/<format>-<slug>.<ext>` at the project root.

## Step 4 — Drive the workflow

```
Workflow({
  name: 'authentic-writing',
  args: {
    format: 'medium',
    domain: 'Agentic Engineering / New SDLC',
    brief: 'Why a rule file is the foundation of an AI-assisted workflow',
    audience: 'engineers new to AI agents',
    tone: 'practical, first-person'
  }
})
```

## Step 5 — Report the result

The engine writes the deliverable to `tmp/authentic-writing/` and returns:

- `format` / `matched` — which pipeline ran and whether it was an exact match or the generic fallback.
- `path` — where the deliverable was written.
- `passedGate` / `judgeVerdict` / `rounds` — whether it cleared the grill-me judge **and** the deterministic validators.
- `wordCount` / `charCount` — computed (not self-reported).
- `blockingViolations` / `warnings` — deterministic format-rule findings; surface any blocking ones.
- `assetPlaceholders` — every `<!-- IMAGE / TABLE / GRAPH / QUOTE -->` still needing a real asset.
- `report.unresolvedGrillQuestions` / `report.notes` — open questions and pre-publish notes.

Tell the user the pipeline + path, whether it passed, and call out blocking violations, asset placeholders, and unresolved grill questions.

## The persona pool

| Persona | Job |
|---------|-----|
| **SME drafter** | Domain expert; writes the accurate, source-grounded first draft. |
| **Format/ship expert** | Applies the pipeline skeleton + conventions; inserts asset placeholders. |
| **Newcomer reader** | Judges follow-ability for *this format's* reader. |
| **Pro reader/writer** | Judges craft, rigor, credibility. |
| **Non-pro reader/writer** | Judges whether the value lands for a non-specialist in that audience. |
| **Grill-me judge** | Always on, every round; adversarially stress-tests and gates shipping. |

All reviewers are **format-aware** — appropriate terseness (e.g. a changelog or PR comment) is not penalized. See `reference.md` for each pipeline's audience, must-haves, validators, and structural skeleton.

## Notes

- Side effects (installing the engine, writing files) are why this skill sets `disable-model-invocation: true`: it stays available via `/authentic-writing` and the Skill tool but never auto-fires the costly multi-agent run.
- Output goes to a `tmp/` folder at the project root (the directory containing `.claude`). Add `tmp/` to `.gitignore` if the repo is versioned.
- Pipelines, validators, and skeletons live in the workflow's `PIPELINES` map — add a format by adding one entry. Full per-pipeline rubric is in `reference.md`.
