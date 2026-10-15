---
name: speaker-mind-map
description: Use when I ask to "turn this into a mind map", "make a mind map in markdown", or want something to glance at during a presentation, sharing, or meeting. Converts a talk track, update, doc, or notes into a Markmap-compatible markdown mind map of short cue words, in speaking order.
---

# Speaker mind map

I am about to present or share something and want a map I can glance at mid-sentence. It is a memory aid, not a script: every node is a cue that reminds me what to say, readable in one second.

The output is markdown headings plus nested bullets. It renders as a mind map in Markmap (markmap.js.org, the VS Code extension, Obsidian Mindmap plugins) and still reads as a plain outline anywhere else.

## Procedure

1. **Get the spoken order.** If the material is already a talk track (for example from the `status-update` skill), keep its sections and order. If it is a raw doc or notes, find the order I would say it in: headline first, ask last. Done when you can list the branches top to bottom as I would speak them.
2. **Set the root and branches.** `#` root = the topic in 2 to 5 words. `##` branches = the sections in speaking order (for a status update: Headline, What, So What, Now What). Keep 3 to 6 branches.
3. **Compress each point into a cue.** Under each branch, bullets of 2 to 8 words. Keep the exact numbers, names, channels, and deadlines I must say correctly; drop the connecting words I can say naturally. Use `→` for cause and flow ("on by default → used without thinking"), `=` for equivalences ("limit = working hours").
4. **Nest only where it helps recall.** One extra level for real lists (allowed cases, approval flow steps). Never deeper than three levels below a branch.
5. **Add backup branches last.** `## Optional (if time)` for side topics. `## If pushback → PREP` with Point / Reason / Example / Point cues when the material has an ask someone may resist. Leave both out if they do not apply.
6. **Return it** in one fenced `markdown` block so I can paste it, then at most two lines of prep notes: gaps I must fill (`[date]`) and anything kept out of the map (links go in the meeting chat, not the map).

## Rules

- Cues, not sentences. If a bullet has a full sentence with a verb and an object, cut it down.
- One idea per bullet. No paragraphs, no bold inside nodes (renderers treat it inconsistently); inline code only for numbers and amounts that must be exact.
- No links or long URLs in the map; they widen the node and I will not read them out.
- Facts come from my material only. Do not invent dates, owners, or numbers; leave `[date]` or `(owner TBC)` and flag it.
- Match the language and terms I used, so the cue triggers my own wording.
- No emoji, no decorative icons.

## Example (shape only)

```markdown
# Overage Policy

## Headline
- Shared earlier
- Draft ready → need confirmation

## What
- 40 members, overage ON by default
- Up to `$9,600/year` if fully used

## So What
- Limit hit = review planning, not add credits
- Limit = working hours, overage = overtime

## Now What
- OFF by default
- Allowed only:
  - Deadline at risk
  - Incident
- Ask: concerns by [date]
- If aligned → roll out

## If pushback → PREP
- Point: keep it off
- Reason: much higher rate
- Example: `$9,600/year` worst case
- Point: confirm by [date]
```

## Done when

The map renders as a valid Markmap outline, branches follow speaking order, no node is a full sentence, every number and deadline matches my material (or is a visible gap), and the prep notes list every gap I must fill before presenting.
