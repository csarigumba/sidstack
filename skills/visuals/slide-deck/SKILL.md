---
name: slide-deck
description: Build a polished, self-contained HTML slide deck (fullscreen 16:9 slides, keyboard and touch navigation, speaker notes, print to PDF, calm warm-light theme with auto dark mode) that opens in any browser with no dependencies. Use when I say "make a slide deck", "create slides", "build a presentation", "turn this into slides", "slides for my talk/meeting/demo", or "a quick 5-minute talk on X", even without the word HTML. Not for an editable .pptx (use a pptx skill) and not for heavy scroll or animation effects.
---

# Slide deck

One HTML file, open it, present. Every slide carries one idea and one drawn visual. The deck looks like one calm family: warm paper, one accent per section, big type, lots of air.

## Procedure

1. **Get the brief.** Topic, audience, length (minutes or slide count), and the source material (notes, doc, transcript, or this conversation). If audience or length is missing, ask once; they set density. Extract: the one-line message of the talk, 3-8 core points, numbers with their source, quotes with attribution. Everything on the slides comes from here; do not add facts.
2. **Read `references/design-system.md`.** Tokens, type scale, figure rules, self-check. Done when you know which accent each section gets and which figure each slide needs.
3. **Outline before building.** One line per slide: `N. <slide title> -> <visual component> -> <accent>`. Show it to me if the deck is over 8 slides or the source is ambiguous; otherwise proceed.
4. **Build the file** per the structure, components, and HTML spec below.
5. **Save** as `<topic-slug>-deck.html` next to the source (or the current directory). Open it unless the run is non-interactive. Reply with the path and the outline, nothing else.

## Slide structure

| slide | purpose |
|---|---|
| 1 Title | title, one-line subtitle, name or team, date if given |
| 2 Setup | why this matters, what the audience gets |
| 3..n Core | one idea per slide, each with a visual |
| n+1 Evidence | the numbers or quotes that prove it, with sources |
| last Takeaway | the message in one line, then the ask or next step |

Simple topic: 5-7 slides. Complex: 10-15. Never more than 15; split into two talks instead. Optional section-divider slides (large numbered eyebrow + section title on `--surface`) when there are 3+ sections.

## Visual components (every slide uses one)

Card grid (2-4 cards: SVG icon, title, one line) · Comparison panel (two columns, thin divider, optional verdict row) · Stat callout (one number 96px in the accent, label under it, source in mono) · Step flow (numbered circles joined by SVG arrows) · Quote block (serif italic, accent bar on the left, attribution mono) · Icon + label list (replaces bullets; 3-6 rows) · Code block (`--surface-2`, mono 20px, at most two token colors from the accent) · Timeline (line with dots, labels alternating) · Metric row (3-4 stat boxes) · Figure (any drawn figure from the design-system menu) · Image + caption (only if I supply the image; inline it).

Text-only slides are not allowed. If a slide has nothing to draw, the idea is not slide-shaped; merge it or cut it.

## HTML spec

- Each slide is a `<section class="slide">` sized `100vw x 100vh`, content box max 1100px, padding 64px, vertically centered, `overflow: hidden`. Only the active slide is visible; the rest are `hidden`.
- Navigation: `ArrowRight`/`Space`/`PageDown` next, `ArrowLeft`/`PageUp` back, `Home`/`End`, click or tap on the right/left third, swipe on touch. Hash sync (`#5`) so a slide is linkable and refresh keeps the place.
- Chrome: slide counter `n / N` bottom-right in mono `--ink-3`; 2px progress bar at the bottom in the current section's accent. Nothing else.
- Speaker notes: `<aside class="notes">` per slide, hidden by default; `N` toggles a notes panel at the bottom (`--surface`, mono 16px). Write notes when I ask for them or when a slide's visual needs a spoken explanation; one short paragraph each, in plain words, never reading the slide aloud.
- Print: `@media print` shows every slide, one per page, `@page { size: 1920px 1080px; margin: 0 }`, chrome hidden. Printing to PDF from the browser is the export path.
- Section accent: set `--accent` on each section's slides (`<section class="slide" style="--accent: var(--amber)">`). Rotate per the design system.
- `?` shows a tiny key legend; `Escape` hides it. Reduced motion respected for slide transitions (a 160ms fade, else none).
- No external requests, no webfonts, no emoji, no icon fonts. Inline SVG for every icon, arrow, and figure.

## Content rules

- One idea per slide. Two points means two slides.
- Max 30 words per slide, excluding the title and figure labels. Big text over small text.
- Numbers show their unit and their source in a mono footnote on the same slide.
- The title of each slide is the claim ("Reviews got 40% faster"), not the topic ("Review time").
- No bullet dumps; use icon + label list, and only for real lists.
- Do not invent statistics, quotes, logos, or names. A missing number stays missing; say "(no figure given)" in the notes, not on the slide.

## Done when

The file opens offline, every slide has a drawn visual and under 30 words, arrows keys and swipe work, print preview shows one slide per page, the self-check in `references/design-system.md` passes, and every number on a slide traces to the input.

## Origin

Rewritten from my earlier `slide-deck-builder` skill. Kept the warm-light palette and the slide structure; added dark mode, speaker notes, print to PDF, hash sync, touch and keyboard navigation, the shared design system, and the ban on emoji icons.
