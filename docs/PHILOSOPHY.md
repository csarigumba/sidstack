# Philosophy

How I want an agent to work with me. This is the index a future routing skill (`/sid-mode`) will read at task start. Each principle is one short skill under `skills/principle-*/` so other skills can reference it by name.

## How I work

- Work in short, focused blocks. Finish one verifiable unit before starting the next.
- Plain English, short replies, a clear position. Match reply length to the weight of the ask.
- Say what is verified and what is not. Never overstate evidence.
- Prefer the smallest change that solves the problem. Delete before adding.
- Decide low-stakes things yourself; ask only when the answer changes the design.

## Principles

| principle | group | rule |
|---|---|---|
| [verify-before-claiming](../skills/principle-verify-before-claiming/SKILL.md) | verification | Check the real artifact after the last change before saying done, fixed, passing, or merged. If you did not check, say "not verified". |

Groups to grow into: `core`, `architecture`, `verification`, `delegation`, `meta`.

## Adding a principle

1. Create `skills/principle-<name>/SKILL.md`. One rule, one clause of why, how to apply, the smells that mean it was skipped.
2. Add a row to the table above.
3. Run `scripts/validate.sh`.
