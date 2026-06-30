---
description: Write a polished, authentic piece in a chosen format (Medium, LinkedIn, docs, report, changelog, and more) in the house voice. Routes to the right pipeline, drives a persona panel plus validators, and writes the result to tmp/authentic-writing/.
argument-hint: [what to write, e.g. "a LinkedIn post about my obsidian wiki experiment" or "a Medium article on NO-RAG retrieval"]
allowed-tools: Skill, Read, Bash
---

# /authentic-writing:write

One verb: describe what you want written, and the plugin produces it in your house voice.

## What this command does

1. **Read the house voice.** Read `${CLAUDE_PLUGIN_ROOT}/skills/house-voice/SKILL.md`. Its two
   registers and the LLM-artifact blocklist are the tone rubric every persona must obey.
2. **Route and invoke the engine.** Hand the user's request to the `authentic-writing` skill, which
   picks the format pipeline, makes sure the workflow engine is installed, and runs the persona panel
   plus deterministic validators via `Workflow({ name: 'authentic-writing', args })`.
3. **Apply the house voice.** Fold the house voice into the engine args: set `tone` from the register
   that fits the audience, and append the blocklist to the `brief` as hard "do-not-write" constraints
   so the grill-me judge fails any draft that reuses them.
4. **Report.** Print the pipeline that ran, the output path under `tmp/authentic-writing/`, whether it
   passed the gate, and any blocking violations, asset placeholders, or unresolved grill questions.

## Invocation

Treat `$ARGUMENTS` as the writing request. Map it to a `format` (a Medium/blog article -> `medium`,
a LinkedIn post -> `linkedin`, and so on — see the `authentic-writing` skill's routing table), then:

```text
Skill: authentic-writing
  request: $ARGUMENTS
  voiceRubric: ${CLAUDE_PLUGIN_ROOT}/skills/house-voice/SKILL.md   # fold into tone + brief constraints
```

If `$ARGUMENTS` is empty, ask one short question: what to write, and in what format.

## Grounding in sources

If the request points at real material ("about my X project"), pass the relevant files as
`sourcePaths` so the subject-matter persona quotes from them instead of inventing. Ungrounded claims
are the fastest way to fail the judge.
