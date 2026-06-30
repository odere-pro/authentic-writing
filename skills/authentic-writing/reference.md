# authentic-writing — reference

Detailed rubric for the `authentic-writing` skill. The body of `SKILL.md` stays lean; the per-pipeline detail lives here. Source of truth for behavior is the `PIPELINES` map in `authentic-writing.js`.

## Routing (natural language → pipeline)

The skill is router-first. Layer 1 (Claude, via `SKILL.md`) classifies intent into a `format` key. Layer 2 (`routePipeline` in the engine) resolves `format` → exact key → alias → **generic** fallback and logs the decision. Pass `format: 'generic'` to force the generic pipeline.

Aliases accepted by the engine (non-exhaustive): `article/blog → medium`, `story/essay → narrative`, `li/social → linkedin`, `issue/bug → github-issue`, `pr/review-comment → pr-comment`, `press/announcement → press-release`, `notes/release-note → release-notes`, `memo → note`.

> Note the resolved collision: `notes` routes to **release-notes** (not `note`). Use `note`, `memo`, or `quick-note` for a quick note.

## Per-pipeline rubric

Each pipeline declares an **audience**, **rules** (prompt guidance), a **skeleton** (structural anchor), and **checks** (deterministic validators). `blocking` checks fail the green gate; `warn` checks are surfaced but do not block.

| Pipeline | Audience | Key blocking checks | Key warn checks |
|---|---|---|---|
| `note` | busy colleague scanning for the takeaway | takeaway lead present | — |
| `documentation` | engineer doing a task | — | has steps/usage/example section |
| `narrative` | general reader to be carried along | no tables | — |
| `medium` | practitioner skimming a 15-min read | no tables, `---` separators present | single H1, ~1200–5000 words, TL;DR blockquote |
| `linkedin` | feed scroller deciding in one line | ≤3000 chars | plain text (no markdown), hook in first 210 chars, hashtags |
| `mvp` | founder/PM judging the smallest build | — | hypothesis + scope sections |
| `poc` | tech lead judging viability | — | verdict present |
| `report` | decision-maker reading the exec summary | — | executive summary present |
| `github-issue` | maintainer triaging | — | summary/context + expected-vs-actual |
| `github-comment` | contributor reading a thread | — | — |
| `pr-comment` | PR author needing a verdict | — | verdict word (approve/request changes/question) |
| `press-release` | journalist/customer scanning the news | "About" boilerplate present | a quote present |
| `changelog` | user scanning what changed | ≥1 Keep-a-Changelog group heading | — |
| `release-notes` | user deciding how to adopt | — | highlights section |
| `generic` | general reader | — | — |

## Deterministic validator catalogue

Run on the draft every round and on the final text (see `runValidators`). All asset placeholders (`<!-- IMAGE/TABLE/GRAPH/QUOTE -->`) are extracted and reported.

- **maxChars** (blocking) — character count over the pipeline limit (LinkedIn: 3000).
- **tables** (blocking) — a markdown table in a `allowTables:false` pipeline.
- **mustHaveAll** (blocking) — a required element regex did not match.
- **singleH1 / plainText / hookWithin / wordTarget / mustHaveAny** (warn) — structural expectations that inform revision but do not hard-block.

The green gate = judge `pass` **AND** every reviewer dimension ≥ 4/5 **AND** zero blocking validator violations.

## Persona calibration (roles)

Each role prompt is calibrated with explicit scope / out-of-scope / format-aware audience / grading anchors.

- **SME drafter** — owns accuracy and authentic voice; reads `sourcePaths` and quotes them; never fabricates facts/URLs; does not format for the channel.
- **Format/ship expert** — owns conventions, the skeleton, and asset placeholders; never adds new claims.
- **Newcomer reader** — judges follow-ability for *this format's* reader; does not demand a terse format become a tutorial.
- **Pro reader/writer** — judges craft, rigor, credibility.
- **Non-pro reader/writer** — judges whether the value lands for a non-specialist *in that audience*; calibrated so dense/direct formats aren't penalized.
- **Grill-me judge** — always on, every round; adversarial; must block on any deterministic `blocking` violation or unmet format must-have.

Grading anchors (0–5): 5 = nothing to fix for this reader; 4 = minor polish; 3 = noticeable gaps; ≤2 = would not ship.

## Examples & fixtures

Every pipeline except `generic` ships at least one `examples/<case>/{before,after}.md` pair; `medium` and `linkedin` have two (they have several validators each). Most cases also carry an `expect.json` oracle and are **executable fixtures**: `before.md` must trip the listed validator `check`s, and `after.md` must be clean.

Run the suite (no LLM calls — it drives the engine's real validators with stubbed agents):

```bash
node scripts/validate-examples.mjs   # exit 0 = all cases pass
```

| Case | Pipeline | `before` trips |
|---|---|---|
| `note-no-takeaway` | note | `mustHave` (takeaway lead) |
| `documentation-no-steps` | documentation | `mustHaveAny` (steps/usage/example) |
| `narrative-tables` | narrative | `tables` |
| `medium-tables` | medium | `tables`, `mustHave` (no `---`) |
| `medium-structure` | medium | `singleH1`, `mustHaveAny` (no TL;DR) |
| `linkedin-hook` | linkedin | *(judgment exemplar — buried hook; no oracle)* |
| `linkedin-overlong` | linkedin | `maxChars`, `plainText` |
| `mvp-no-hypothesis` | mvp | `mustHaveAny` |
| `poc-no-verdict` | poc | `mustHaveAny` |
| `report-no-summary` | report | `mustHaveAny` |
| `github-issue-no-repro` | github-issue | `mustHaveAny` |
| `github-comment-table` | github-comment | `tables` |
| `pr-comment-no-verdict` | pr-comment | `mustHaveAny` |
| `press-release-no-boilerplate` | press-release | `mustHave`, `mustHaveAny` |
| `changelog-no-groups` | changelog | `mustHaveAny` |
| `release-notes-no-highlights` | release-notes | `mustHaveAny` |

> Two flavors of example: **fixtures** (have `expect.json`; assert a deterministic validator) and **judgment exemplars** (no `expect.json`; illustrate a quality the persona panel catches but no validator can, e.g. `linkedin-hook`'s buried hook). The runner only executes fixtures.

When you add or change a validator, add/adjust a fixture and re-run the suite.

## Adding a pipeline

Add one entry to `PIPELINES` in `authentic-writing.js`: `{ aliases, extension, audience, assets, rules, skeleton, checks }`. The `checks` object drives the deterministic validator; everything else feeds the persona prompts. Then re-run `install.sh` to propagate.
