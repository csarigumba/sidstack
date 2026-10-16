---
name: speaker-mind-map
description: Use when I ask to "turn this into a mind map", "make a mind map in markdown", or want something to glance at or read from during a presentation, review, or meeting. Converts a talk track, doc, sheet, or notes into a Markmap-compatible markdown mind map in speaking order, as short cues by default or as short speakable lines with bridges when I will read it aloud.
---

# Speaker mind map

I am about to present, review, or share something and want a map to use while I talk. The output is markdown headings plus nested bullets. It renders as a mind map in Markmap (markmap.js.org, the VS Code extension, Obsidian Mindmap plugins) and still reads as a plain outline anywhere else.

## Pick the mode

- **Glance (default).** A memory aid, not a script. Every node is a cue I can read in one second mid-sentence. Use it for presentations and updates I already know well.
- **Read-aloud.** Use it when I say I will read from the map, ask for a "brief description to state it while talking", or ask for a smooth flow. Typical case: walking one person through feedback, goals, or a review. Each node is a short line I can say as written, and each branch hands off to the next.

## Procedure

1. **Pick the voice.** If the source has more than one voice (self-assessment vs reviewer, proposal vs comments), map only the side I will speak. Ask me if it is unclear. Done when every node is something I would say.
2. **Get the spoken order.** If the material is already a talk track (for example from the `status-update` skill), keep its sections and order. If it is a raw doc or notes, find the order I would say it in: headline or big picture first, ask last. Done when you can list the branches top to bottom as I would speak them.
3. **Set the root and branches.** `#` root = the topic in 2 to 5 words. `##` branches = the sections in speaking order (for a status update: Headline, What, So What, Now What). Keep 3 to 6 branches. Items with their own weight or owner (missions, workstreams) can be `###` under one `##` branch.
4. **Write the nodes** for the chosen mode (rules below). Keep the exact numbers, names, periods, weights, and deadlines I must say correctly. Use `→` for cause and flow ("delay likely → raise it early"), `=` for equivalences ("limit = working hours").
5. **Nest only where it helps recall.** One extra level for real lists (areas, steps, allowed cases). Never deeper than three levels below a branch.
6. **Add backup branches last.** `## Optional (if time)` for side topics. `## If pushback → PREP` with Point / Reason / Example / Point cues when the material has an ask someone may resist. Leave both out if they do not apply.
7. **Return it** in one fenced `markdown` block so I can paste it, then at most two lines of prep notes: gaps I must fill (`[date]`), anything kept out of the map (links go in the meeting chat, not the map), and totals that no longer add up after I removed a section.

## Glance-mode nodes

- Cues of 2 to 8 words. Drop the connecting words I can say naturally.
- Cues, not sentences. If a node has a full sentence with a verb and an object, cut it down.

## Read-aloud-mode nodes

- Number the branches and label their purpose: `## 1. Vision: where you want to go`, `## 3. Missions: how we measure it`.
- Open the first branch with a line I can say to start ("I read your vision, here's my feedback").
- Each node is one short line I can say in one breath (up to about 10 words), in my voice: "I" for me, "you" for the listener.
- Before a group of sub-branches, add one overview node per item so the listener knows what is coming ("Mission 1 = grow your scope").
- Inside a branch, group by order of action: `Step 1` / `Step 2`, `Before work` / `During work`, `How`, `Why`. End goal-like branches with `Success looks like` and its points.
- End every branch except the close with a `Bridge → ...` node that leads into the next branch ("Bridge → two missions make this concrete"). A bridge only links what the material already says; it never adds a new claim.
- Finish with a `## Close` branch: one recap node that chains the branches with `→`, then the questions for the listener ("Your thoughts?", "Anything you want to adjust?").

## Rules (both modes)

- One idea per node. No paragraphs, no bold inside nodes (renderers treat it inconsistently); inline code only for numbers, weights, and amounts that must be exact.
- No links or long URLs in the map; they widen the node and I will not read them out.
- Facts come from my material only. Do not invent dates, owners, numbers, or reasons; leave `[date]` or `(owner TBC)` and flag it.
- Match the language and terms I used, so the node triggers my own wording.
- If I remove a section from a map I give back, keep it removed; do not restore it.
- No emoji, no decorative icons.

## Example: glance mode (shape only)

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

## Example: read-aloud mode (shape only)

```markdown
# Half-Year Goals Review

## 1. Vision: where you want to go
- I read your vision, here's my feedback
- Your vision is clear
  - Each step builds toward a lead role
- Start building next-level skills now
  - Look beyond your own tasks
  - Help others grow
- Bridge → so what's the first step this half?

## 2. Overall Goal: the step this half
- From one topic → lead for the whole team
  - You're already strong in your own area
- You don't need to own every area
  - Know what each area needs
  - Help shape the direction
- Bridge → two goals make this concrete

## 3. Goals: how we measure it
- Both run Oct – Mar, passing score `3`
- Goal 1 = grow your scope
- Goal 2 = keep delivery reliable while you grow

### Goal 1: Team Initiative `40%`
- Step 1: build your view of the team
  - Share with me: gaps, priorities
- Step 2: lead `1+` initiative outside your area
- Success looks like
  - Team sees you as its lead
- Bridge → growing scope only works if delivery stays stable

### Goal 2: Stable Delivery `60%`
- Before work: clarify and prioritize requests
- During work: deliver on the agreed timeline
  - Delay likely → raise it early with a new plan
- Success looks like
  - Other teams see us as dependable

## 4. Close
- Recap: clear vision → team lead → 2 goals
- Your thoughts?
- Anything you want to adjust?
```

## Done when

The map renders as a valid Markmap outline, branches follow speaking order, every number and deadline matches my material (or is a visible gap), and the prep notes list every gap I must fill. Glance mode: no node is a full sentence. Read-aloud mode: every node can be said as written, and every branch except the close ends with a bridge to the next.
