# Design system for generated visuals

One family across pages, decks, and graphics. Copy the token block, style only through the variables, and keep to these rules. The goal is calm and legible: it should pass as a screen from a well-made native app, not a template.

## Tokens (copy verbatim into `<style>`)

```css
:root {
  --bg: #FCFBF7;        /* warm paper */
  --surface: #F4F3F0;   /* cards, panels */
  --surface-2: #ECEAE4; /* nested fills, code */
  --border: #E6E3DC;    /* hairlines */
  --ink: #1C1C1E;       /* text, titles */
  --ink-2: #5F5F66;     /* secondary text (AA on --bg) */
  --ink-3: #8E8E93;     /* large labels only, never body text */
  --blue: #5B7FE8; --amber: #E2A33C; --green: #58A87C; --purple: #9A77C8; --terracotta: #E07856;
  --accent: var(--blue);
  --accent-soft: color-mix(in srgb, var(--accent) 14%, transparent);
  --font: -apple-system, BlinkMacSystemFont, "SF Pro Text", Inter, "Segoe UI", Roboto, system-ui, sans-serif;
  --font-display: ui-serif, "New York", Georgia, "Times New Roman", serif;
  --font-mono: ui-monospace, "SF Mono", Menlo, Consolas, monospace;
  --radius: 14px; --radius-sm: 8px;
  --shadow: 0 1px 2px rgba(28,28,30,.05), 0 8px 24px rgba(28,28,30,.04);
  --space: 8px;
}
@media (prefers-color-scheme: dark) {
  :root {
    --bg: #121214; --surface: #1C1C1E; --surface-2: #26262A; --border: #2C2C31;
    --ink: #F2F2EF; --ink-2: #B0B0B6; --ink-3: #8E8E93;
    --shadow: 0 1px 2px rgba(0,0,0,.4), 0 8px 24px rgba(0,0,0,.3);
  }
}
```

If `color-mix` support is a concern, precompute `--accent-soft` as an `rgba(...)` of the accent at 0.14 alpha.

## Color

- Background `--bg`, cards `--surface`, nested fills `--surface-2`, hairlines `--border`. No pure white, no pure black.
- One accent per section. Rotate Blue, Amber, Green, Purple, Terracotta in that order across sections; loop if there are more sections than accents. Within a section, that one accent carries every highlight, divider, chip, and figure emphasis.
- Semantic color only where meaning exists: green = good or done, amber = warning or degrading, terracotta = failure, gray = inactive.
- Keep out: gradients as decoration, glows, gradient text, neon, more than one accent in a section, accent used for body text.

## Type

- Body and UI: `--font`. Display titles may use `--font-display`. Captions, labels inside figures, eyebrows, code: `--font-mono`.
- Scale (pages): display 48-56px / 1.05 line height, h2 28px, h3 20px, body 18px / 1.6, caption 13px mono. Decks use larger steps: title 64, h2 44, body 26-28, stat 96.
- Measure: body text max 68 characters per line (`max-width: 68ch`).
- Eyebrow above each section: small uppercase mono, letter-spaced, numbered (`01  THE PROBLEM`), in the section accent.
- Left-align text. Center only a title slide or a single stat.

## Layout and spacing

- 8px grid. Section spacing 80px (pages) or the slide's own padding (decks). Card padding 24px. Grid gaps 16-24px.
- Max content width 960px for pages, 1100px for decks.
- Cards: `--surface`, 1px `--border`, `--radius`, `--shadow`. Nested elements use `--radius-sm`.
- Every grid or flex child gets `min-width: 0`. No horizontal page scroll at any width. Stack to one column under 720px.

## Figures (the reason the page exists)

- 2-4 purpose-built figures per artifact, drawn with inline SVG or CSS. Not Mermaid, not icon fonts, not emoji.
- Menu: capacity bar with a marked zone, blocks filling over time, before-vs-after pair, labeled flow (boxes joined by arrows), fan-out tree, layered stack, timeline with dots, comparison grid, hub and spokes, document glyph.
- Arrows are SVG paths with `<marker>` arrowheads. Never text characters like `->` or `→` as connectors.
- Every box holds a real label. No empty placeholder shapes. Labels sit next to what they describe.
- SVG uses `viewBox` plus `width:100%`; colors via CSS variables (`fill="var(--surface-2)"`, `stroke="var(--accent)"`) so dark mode works.
- Each figure sits in its own card with a mono caption underneath: `fig. 1  what it shows`.
- Icons, when needed, are 20-24px inline SVG strokes (1.75px, round caps) in `--ink-2` or the accent. Never emoji.
- Test: if the figure were removed, would the reader understand less? If not, remove it.

## Motion

- Optional fade-up on load, wrapped in `@media (prefers-reduced-motion: no-preference)`.
- Content is fully visible with animations off. Never leave anything at `opacity: 0` waiting for JS.

## File

- One self-contained `.html`: `<!DOCTYPE html>`, `<meta name="viewport">`, `<title>`, inline `<style>`, inline SVG. No external requests of any kind: no webfonts, no CDN, no remote images. Inline images as base64 only if small; total file under 300 KB.
- Semantic HTML (`header`, `main`, `section`, `figure`, `figcaption`). Alt text on any raster image. Contrast WCAG AA (4.5:1 body, 3:1 large).
- JavaScript only for navigation or optional enhancement. The content must read with JS disabled.

## Self-check before saving

- [ ] Only the token palette; one accent per section; no gradients, glows, or emoji.
- [ ] 2-4 drawn figures with `fig. N` captions, each explaining something.
- [ ] No text-character arrows, no empty boxes, no horizontal scroll.
- [ ] Light and dark both render from variables.
- [ ] Zero external requests (`grep -c "https://"` in `<link>`, `<script src>`, `<img src>`, `@import` is 0).
- [ ] Body copy under the word limits the skill sets; every claim and number came from the input.
