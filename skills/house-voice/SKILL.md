---
name: house-voice
description: >
  The house writing voice — how to write prose a newcomer wants to read and a
  practitioner can trust. Defines two registers (explanatory and engineer), the
  rule for choosing between them, the LLM-artifact blocklist, and the one
  read-aloud check. The authentic-writing engine folds this in as the tone rubric
  its persona panel and grill-me judge must obey. Reference, not action — it
  teaches how to write, it does not write for you.
allowed-tools: Read
disable-model-invocation: true
---

# Voice — how to write here

Write so a curious newcomer keeps reading and a practitioner keeps trusting. Plain words for the
ideas, exact words for the mechanics. Never sound like a brochure or a generated summary.

## Pick a register by audience

Every paragraph is aimed at someone. Decide who, then pick the register.

**Explanatory register** — for anyone learning what the thing is or why it matters: intros,
getting-started, the "what / why" opening of any piece. Write like you're explaining it to a sharp
friend at a whiteboard.

- Short, concrete sentences. One idea each.
- Active voice. Talk to the reader as "you".
- Lead with the point, then support it. No throat-clearing.
- Show, don't label: a real example beats the word "powerful".
- A little personality is good. Dryness is not the goal; clarity is.
- Gloss a term on first use, then commit to it. Spell out an acronym once, then use the short form.
- One new term per sentence. Precise is not the same as dense.

**Engineer register** — for the reader who has to build, operate, or audit: reference, design notes,
specs, anything load-bearing. Precision outranks simplicity here.

- Use the exact term, every time. No loose synonyms.
- Ground claims in specifics — name the file, the number, the behavior.
- Terse beats chatty. Cut the adjective if the noun already carries it.
- Still no filler: precise is not the same as padded.

When a piece serves both, open in the explanatory register and shift to the engineer register as it
goes deep. A hero paragraph is explanatory; a spec is engineer.

## The LLM-artifact blocklist

These read as machine-written. Cut them in both registers.

- **Em-dash drama.** Stacking em-dashes for rhythm. Use a period or a comma.
- **Filler openers.** "It's worth noting", "It's important to note", "Let's dive in", "In today's
  world", "At the end of the day".
- **Hype adjectives.** powerful, seamless, robust, effortless, cutting-edge, leverage, utilize,
  unlock, supercharge. Name the concrete behavior instead.
- **The "not just X, it's Y" frame.** And its cousin "more than just".
- **Hedge stacks.** "generally typically usually" piled together. Commit or cut.
- **Over-bolding.** Bold one or two real signals per section, not every noun.
- **Echo summaries.** A closing sentence that restates the heading it sits under. (A sentence that
  points *forward* to the next step is not an echo.)
- **Robotic triads.** Forced three-part parallelism where two items, or four, is the honest count.
- **Provenance as adjective.** "authoritative source", "definitive reference", "well-established
  fact". State the claim and let the evidence carry it.

## Before / after

Explanatory:

> Before: "This powerful, seamless tool leverages a robust pipeline to unlock effortless writing —
> more than just an editor."
>
> After: "You give it a topic and a format. It drafts, a panel of readers grills the draft, and it
> revises until the writing reads cleanly. One pass, not a template."

Engineer:

> Before: "It's worth noting that the validator generally tends to enforce the format, which is a
> really important feature for keeping the output consistent."
>
> After: "The validator blocks a draft that breaks the format's hard rules — a LinkedIn post over
> 3000 characters, say — before it ships."

## The one check

Read it aloud. If it sounds like a person who understands the topic explaining it on purpose, ship
it. If it sounds like a press release or a generated abstract, rewrite it.
