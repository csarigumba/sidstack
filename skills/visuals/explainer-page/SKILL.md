---
name: explainer-page
description: Build a polished, self-contained HTML page that explains one concept, system, comparison, process, or result visually, with drawn figures and a calm warm-light theme (auto dark mode). Use when I say "make a visual page", "build an HTML explainer", "explain this visually as a page", "turn this doc into a page", "architecture overview page", "comparison page", or "project recap page". For a quick in-chat diagram use show-me; for a team knowledge-share post use eng-knowledge-share; for slides use slide-deck.
---

# Explainer page

A single HTML file that reads like a page from a well-made product site: short text, then a figure that carries the point, repeated for 3-6 sections.

## Page types

| type | best for | lead components |
|---|---|---|
| Architecture overview | systems, stacks, infrastructure | labeled flow figure, component cards, boundary boxes |
| Comparison | tool vs tool, plan vs plan, before vs after | comparison grid, verdict callout |
| Process | tutorials, onboarding, how it works | step flow, state figure |
| Timeline | roadmaps, history, changelogs | vertical timeline, milestone cards |
| Dashboard | metrics, KPIs, results | stat row, bar figure, progress bars |
| Concept | abstract ideas, mental models | analogy figure, layered stack, callout |
| Recap | project summaries, case studies | before/after pair, stats, quote |

Auto-detect from the input; ask only if two types fit equally.

## Procedure

1. **Gather content.** From the doc, notes, transcript, or conversation I gave: title, 3-6 sections, key numbers with sources, relationships (what connects to what), hierarchy (what matters most). If I gave nothing but a topic, ask for the 3-6 sections in one question. Do not research beyond the input or invent numbers.
2. **Read `references/design-system.md`.** Done when you know each section's accent and figure.
3. **Plan the layout** and show it in 3-6 lines before building, unless the input is small and unambiguous:
   `01 What it is -> concept card + layered-stack figure (blue)`
   `02 How it works -> 4-step flow figure (amber)`
4. **Build the file** per the spec below.
5. **Save** as `<topic-slug>.html` next to the source or in the current directory. Open it unless the run is non-interactive. Reply with the path and the section plan.
6. **Iterate on request.** Typical changes: swap a figure type, add or cut a section, change a number, inline a logo (small, base64). Keep the palette; brand color may replace one accent if I ask.

## Page spec

- `header`: eyebrow (mono, accent), display title (`--font-display`, 48-56px), one-line standfirst in `--ink-2`, optional meta row (date, author, version) in mono.
- Sticky top bar only if the page has 5+ sections: section links, hairline bottom border, `--bg` with slight transparency.
- Each `section`: numbered eyebrow, h2, at most 50 words of intro, then the component or figure in a card, then an optional one-line takeaway in the accent's soft fill.
- Closing "bottom line" card: 2-3 sentences and the key steps as mono chips joined by drawn arrows.
- Footer: `Source: <title>` only when the input names one. No author bio, no disclaimer.
- Components: stat cards, section cards (SVG icon, title, one line), comparison grid (sticky header, checkmarks drawn as SVG), flow steps, status chips (semantic colors only), code block, callout (accent left bar, soft fill), progress bars with labels, striped table with horizontal scroll under 720px, vertical timeline, quote block, drawn figures.
- Responsive: grids stack under 720px; stat rows wrap; tables scroll; figures scale via `viewBox`.
- No external requests, no webfonts, no emoji, no icon fonts. JS only for optional smooth scroll or reduced-motion fade.

## Rules

- Every section has a visual. If nothing can be drawn, the section is a note, not a section; fold it into a callout elsewhere.
- Max 50 words of prose before a visual. Body copy max 68 characters per line.
- Plain English, simple words. Define a term in one clause the first time it appears.
- Facts, numbers, and quotes come from the input. Mark a gap as `(figure not given)` in the text rather than filling it.

## Done when

The file opens offline, light and dark both render, every section has a drawn or structured visual, no section exceeds 50 words before its visual, the self-check in `references/design-system.md` passes, and nothing on the page is a fact I did not provide.

## Origin

Rewritten from my earlier `visual-page-builder` skill. Changed: dark-only palette with Google Fonts replaced by the shared warm-light system with auto dark mode and system fonts; emoji icons replaced by inline SVG; figure rules and the self-check added.
