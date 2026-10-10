# Design: iOS-clean base + explanatory figures

Two layers. The base keeps it clean. The figures make it explain.

## 1. Base: iOS look

- Copy the CSS token block from `ios-theme.md` verbatim; style only through its variables.
- Light and dark mode both required (`prefers-color-scheme`). Dark = black ground, `#1C1C1E` cards, not an inversion.
- Font: the system stack (`--font`); `--font-mono` for code and figure labels. The title may use the system serif (`ui-serif, "New York", Georgia, serif`) No webfonts, no `<link>` to fonts.
- Content in inset-grouped cards, 12-16px radius, hairline separators, barely-there shadows.
- System blue is the accent. Semantic colors carry meaning: green = good / in zone, orange = degrading / warning, red = failure, gray = clutter or inactive.
- Max content width ~760px, generous whitespace.
- Keep out: gradients, glows, gradient text, emoji, stock icon sets, three-dot window chrome, neon palettes.

## 2. Figures (the reason this page exists)

Draw figures that explain, in the page's own palette. The list below is the menu; pick what fits the idea.

- **2-4 purpose-built figures**, each drawn with inline SVG or CSS. Not Mermaid, not icons. Pick what fits the idea:
  - capacity bar with a marked zone (e.g. "smart zone" vs "focus degrades")
  - blocks that fill up over time (context, tokens, work items)
  - before vs after pair
  - document glyph for a handoff file / spec
  - fan-out tree (one task -> several pieces)
  - labeled flow: boxes joined by arrows
- Each figure sits in its own inset card with a monospace caption under it: `fig. 1 - <what it shows>`.
- Tiny labels inside figures in `--font-mono`, 11-12px, `--label-2`.
- Every figure must explain something. If you removed it, the reader would understand less.

### Figure quality rules

- Arrows and branches are drawn SVG paths/lines with arrowheads (`<marker>`), never text characters like "->" or "← ? →".
- Every box holds a real label; no empty placeholder boxes.
- No stray gaps; labels sit right next to what they describe.
- SVG uses `viewBox` + `width:100%` so it scales; colors via CSS variables so dark mode works (`fill="var(--card-2)"` or classes).
- No horizontal page scroll at any width; every grid/flex child gets `min-width: 0`.

## 3. Page furniture

- Small uppercase numbered eyebrow per section: `01  THE PROBLEM`, in accent color, monospace, letter-spaced.
- Section title (Title2, ~26px) + 1-3 short sentences before any figure (max ~50 words).
- At most one pull quote: left accent bar, serif italic, one or two lines.
- One "catch" or tip callout: left accent bar, tinted background, small uppercase label.
- Steps as a grouped list: number in accent color | step name | one-line detail.
- Closing "bottom line" card: 2-3 sentences + the key steps as small monospace pill chips joined by drawn arrows.

## 4. Motion

- Optional subtle fade-up on load, wrapped in `@media (prefers-reduced-motion: no-preference)`.
- Content must be fully visible with animations off: never leave elements at `opacity: 0` waiting for JS or an animation outside that media query.

## 5. File

- One self-contained `.html`: `<!DOCTYPE html>`, `<meta viewport>`, `<title>`, inline `<style>`, no external requests.
- Under ~60 KB.

## Self-check before saving

- [ ] Would pass as a screen in a polished Apple app (no off-palette colors, no webfonts).
- [ ] 2-4 figures, each with a `fig. N` caption, each explaining something.
- [ ] No text-character arrows, no empty boxes.
- [ ] Light and dark both use theme variables.
- [ ] Source footer present only if the input named a source, and it is one line.
