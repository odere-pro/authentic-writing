---
name: onboarding
description: First-run orientation for authentic-writing — what it does, a one-time engine check, and your first /authentic-writing:write. Trigger when the user says "get started", "how do I use this", "onboard me", "first time", or invokes it directly. Reference, not action.
allowed-tools: Read, Bash
disable-model-invocation: true
---

# Getting started with authentic-writing

authentic-writing turns a request into a polished piece in a chosen format — a Medium article, a
LinkedIn post, a changelog — in a consistent house voice. You describe what you want; a persona
panel drafts it, grills the draft, and revises until it reads like a person wrote it.

## 1. Confirm the engine is ready

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/doctor.sh"
```

All green means you're set. The `SessionStart` hook installs the workflow engine automatically; if
the engine check is yellow, start a new session or run `skills/authentic-writing/install.sh`.

## 2. Write your first piece

Describe it in plain language and name the format:

```text
/authentic-writing:write a LinkedIn post about <your topic>
```

The result lands in `tmp/authentic-writing/`. The report tells you which format ran, whether it
passed the quality gate, and anything still open.

## 3. Make it sound like you

The `house-voice` skill is the tone rubric the engine obeys — two registers plus a blocklist of
machine-sounding phrasings. Edit it to tune your voice; every piece is held to it.

## Next

- `/authentic-writing:write` — the one verb you'll use most.
- `/authentic-writing:doctor` — health check when something feels off.
