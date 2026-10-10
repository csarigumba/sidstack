---
name: eng-knowledge-share
description: Turn a brainstormed topic (markdown notes, a file path, or the conversation so far) into one visual HTML explainer page plus a short post for my engineering channel. Manual use only. Invoke as /eng-knowledge-share <path-to-notes.md or pasted markdown>.
disable-model-invocation: true
---

# Engineering knowledge share

I share one small engineering or AI-tooling idea at a time with my team. I brainstorm the topic first, then run this skill on the result. Input is markdown (a file path, pasted text, or this conversation). Output is two files:

1. `<slug>.html`: one self-contained visual explainer page on ONE idea.
2. `<slug>.post.md`: a short message I paste into the team channel with the page link.

The input is the source of truth. Do not research beyond it; I already shaped the idea.

## Procedure

1. **Read the input.** If an argument is a path, read it; otherwise use the pasted markdown; otherwise summarize the current conversation into the brief format below. Extract:
   - Title (if missing, write one: 3-8 plain words, a verb or a claim).
   - Core idea, one sentence.
   - Problem, 3-5 key points or steps, example, any numbers.
   - Source title, if the input names one. If none, there is no source line.
   - Evidence strength: flag any claim the input calls rough, anecdotal, or one person's experience.
   Done when you can state title, idea, and points without guessing.
2. **Read the design rules** in `references/design.md` and `references/ios-theme.md`. Done when you know which 2-4 figures this topic needs.
3. **Build the page** per `references/design.md`. Content order:
   1. Eyebrow + title + one-line idea.
   2. The problem (2-3 short sentences).
   3. Figure(s) that make the idea obvious.
   4. What to do: 3-5 concrete steps.
   5. Example (from the input only).
   6. "Try this today" callout: one specific action.
   7. Bottom-line card.
   8. Footer `Source: <title>`, only when the input names a source. No author, no disclaimer.
   Done when every section of the input is on the page and nothing was invented.
4. **Write the post** per `references/post.md`.
5. **Save** both files to the output directory (default `~/.agent/diagrams/knowledge-share/`) as `<slug>.html` and `<slug>.post.md` (slug = kebab-case title). Open the HTML unless the run is non-interactive. Paste the full post text in the reply.

## Rules

- English only. Simple everyday words. Define a term in one clause the first time it appears.
- One idea per page, readable in about 2 minutes.
- No hype, no emoji, no employer, client, or colleague names, no source-author names.
- Never overstate evidence. Soft claims use "seems to", "tends to", "in my experience".
- Do not invent numbers, tools, quotes, or examples that are not in the input. A gap in the input stays a gap on the page.

## Brief format (when summarizing a conversation)

```markdown
# <Title>
Idea: <one sentence>
Source: <title or none>
## Problem
## Key points
## Example
## Try this today
## Caveats
```

## Pitfalls

- Elements left at `opacity: 0` for a fade-in render blank when animations do not run. Keep motion inside `prefers-reduced-motion: no-preference`.
- Text-character arrows (`->`) and empty placeholder boxes were the main flaws in early pages. Draw arrows as SVG paths; every box carries a label.
- Do not sink time into headless screenshot QA of the page. Run the code checks below, open the page, and let me judge the look.

## Done when

- Both files exist in the output directory.
- The page has 2-4 figures with `fig. N` captions, light and dark mode via theme variables, no `<script>`, no external requests, and no forbidden words (hype, names).
- The post is under 120 words and keeps the literal `<link to page>` placeholder.
