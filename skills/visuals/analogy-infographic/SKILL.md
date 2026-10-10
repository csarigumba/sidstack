---
name: analogy-infographic
description: Create a single-image infographic that explains one technical concept through a real-world analogy, rendered as a fixed-size HTML/SVG artboard (square, story, slide, or blog sizes) ready to screenshot or print. Use when I say "make an infographic", "explain this with an analogy", "explainer graphic", "one graphic that explains X", or "social post that explains X". For a multi-section page use explainer-page; for slides use slide-deck.
---

# Analogy infographic

Find the analogy first, map every part of the concept onto it, then draw one graphic where the picture carries the story and the words are a caption.

## Procedure

1. **Pin the concept.** One sentence: what the graphic must make someone understand. One concept per graphic; if the topic has two ideas, make two graphics.
2. **Find the analogy.** Search the categories below. It must click in under 3 seconds, work for a 10-year-old, map to at least 3 parts of the concept, and be fresh (no "it's like a brain" for AI, no "it's like a highway" for networks).

   | category | examples | fits |
   |---|---|---|
   | everyday objects | mailbox, closet, kitchen, remote control, filing cabinet | storage, organization, interfaces |
   | jobs and roles | receptionist, translator, librarian, bouncer, air-traffic controller | routing, filtering, gatekeeping |
   | construction | blueprint, foundation, scaffolding, plumbing, wiring | architecture, infrastructure |
   | cooking | recipe, ingredients, mise en place, oven, tasting | processes, combining inputs, iteration |
   | sports | playbook, coach, referee, relay baton, training camp | strategy, handoffs, teamwork |
   | games | skill tree, inventory, quest log, save point, power-up | progression, state, upgrades |
   | nature | roots, beehive, food chain, seasons, river delta | networks, hierarchies, cycles |
   | travel | passport control, boarding pass, GPS reroute, luggage tag | identity, access, routing |

3. **Map it.** Fill this table; every part of the concept must land on a part of the analogy, or pick another analogy.

   | real concept | analogy part | what to draw | why the mapping holds |
   |---|---|---|---|

4. **Pick the layout.** Split panel (real vs analogy, before/after) · Circular flow (cycles) · Stacked steps (sequence, funnel) · Comparison grid (2x2) · Pyramid (foundations) · Hub and spokes (one-to-many) · Timeline (evolution).
5. **Pick the size.** Square 1080x1080 (social), Story 1080x1920, Slide 1920x1080, Blog 1200x1600. Default: Square.
6. **Read `references/design-system.md`,** then draw the graphic per the spec below.
7. **Save** as `<concept-slug>-infographic.html` and reply with the path, the analogy in one line, and the mapping table. To export: open and screenshot, or `chrome --headless --screenshot=<name>.png --window-size=<W>,<H> <file>`. Print to PDF also works (`@page` is set to the artboard size).

## Artboard spec

- `<main class="board">` with fixed `width`/`height` in px equal to the chosen size, scaled to fit the viewport with `transform: scale()` (so it previews on any screen without reflow). Use exactly this positioning; do not center the board with flex or grid, because those size the track to the unscaled board and the scaled board then overflows the clipped body:

  ```css
  html, body { margin: 0; height: 100%; overflow: hidden; background: var(--bg) }
  .board { position: absolute; top: 50%; left: 50%; width: <W>px; height: <H>px;
           transform-origin: center; transform: translate(-50%, -50%) scale(var(--s, 1)) }
  @page { size: <W>px <H>px; margin: 0 }
  @media print { .board { position: static; transform: none } }
  ```
  ```js
  const fit = () => document.documentElement.style.setProperty('--s', Math.min(innerWidth / <W>, innerHeight / <H>));
  addEventListener('resize', fit); fit();
  ```
- Nothing inside the board may overflow it: `board.scrollHeight` and `scrollWidth` must equal the artboard size. Give the scene SVG a `viewBox` whose aspect matches the slot left after the title, callout, footer and gaps, so `width: 100%` never makes it taller than planned.
- Background `--bg`. A 48px safe margin all round. Title at the top: 6-8 words, `--font-display`, the claim ("API keys are VIP wristbands"), plus a one-line subtitle in `--ink-2`.
- The analogy scene is one drawn SVG filling the middle, in `--surface` and `--surface-2` with the section accent for the parts that matter. Each mapped part has a small mono label and, where the layout allows, a thin leader line to a 1-line "real meaning" caption. Connections are SVG paths with arrowheads; label the arrow only if the label adds meaning.
- One key-insight callout near the bottom: the single most important sentence, in a card with the accent left bar and soft fill, 18-24px. Styled differently from everything else.
- Footer line, mono 12px: source title if the input named one; otherwise nothing.
- One accent for the whole graphic (pick the one that fits the mood: blue neutral, amber attention, green growth, purple abstract, terracotta warning). Semantic colors only where they mean something.
- No photos, no emoji, no icon fonts, no gradients, no external requests. Everything is drawn.

## Rules

- Max 50 words on the whole graphic, including labels. Fewer is better.
- The graphic should make sense with the text covered. If it does not, the drawing is not carrying the analogy yet.
- Every mapped part is visible in the drawing; nothing in the drawing is unmapped decoration.
- Universal analogies only; nothing that needs local or niche knowledge.
- No invented numbers or claims. If the concept has a figure worth showing, it comes from the input.

## Done when

The mapping table has no gaps, the artboard is the chosen size, scales to the window with no part clipped, and nothing inside it overflows; the text is under 50 words, the drawing explains the concept without the text, and the design-system self-check passes.

## Origin

Rewritten from my earlier `explainer-graphic` skill, which stopped at a written brief for a designer. Kept the analogy categories, selection criteria, mapping table, and layouts; added the rendered HTML/SVG artboard, export path, the shared design system, and the no-emoji rule.
