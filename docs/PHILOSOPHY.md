# Philosophy

The rules every agent follows when working with me live in [`AGENTS.md`](../AGENTS.md) at the repo root (`.claude/CLAUDE.md` imports it). This file is the index of the principle skills: one rule per skill under `skills/principle-*/`, so other skills can reference a principle by name and a future routing skill can read this index at task start.

## Principles

| principle | group | rule |
|---|---|---|
| [verify-before-claiming](../skills/principle-verify-before-claiming/SKILL.md) | verification | Check the real artifact after the last change before saying done, fixed, passing, or merged. If you did not check, say "not verified". |

Groups to grow into: `core`, `architecture`, `verification`, `delegation`, `meta`.

## Adding a principle

1. Create `skills/principle-<name>/SKILL.md`. One rule, one clause of why, how to apply, the smells that mean it was skipped.
2. Add a row to the table above.
3. If it is a rule every agent should follow always, add one line to `AGENTS.md` too. The skill holds the detail; `AGENTS.md` holds the one-liner.
4. Run `scripts/validate.sh`.
