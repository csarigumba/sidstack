# iOS Theme — Design Tokens & Component Patterns

The single source of truth for every page this skill generates. Values follow Apple's HIG and the UIKit system palette. Copy the CSS token block verbatim, then style components only through the variables.

## CSS token block

```css
:root {
  color-scheme: light dark;

  /* grounds (light) */
  --bg: #F2F2F7;              /* systemGroupedBackground */
  --card: #FFFFFF;            /* secondarySystemGroupedBackground */
  --card-2: #F2F2F7;          /* tertiary fill inside cards */
  --fill: rgba(120,120,128,0.12);   /* systemFill — pill/track backgrounds */
  --separator: rgba(60,60,67,0.29); /* hairline separators */

  /* text */
  --label: #000000;
  --label-2: rgba(60,60,67,0.60);   /* secondaryLabel */
  --label-3: rgba(60,60,67,0.30);   /* tertiaryLabel */

  /* system colors */
  --blue:   #007AFF;
  --green:  #34C759;
  --red:    #FF3B30;
  --orange: #FF9500;
  --yellow: #FFCC00;
  --teal:   #30B0C7;
  --indigo: #5856D6;
  --purple: #AF52DE;
  --pink:   #FF2D55;
  --gray:   #8E8E93;

  --accent: var(--blue);
  --accent-fill: rgba(0,122,255,0.12);  /* tinted background for the accent */

  /* type */
  --font: -apple-system, BlinkMacSystemFont, 'SF Pro Text', 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
  --font-mono: ui-monospace, 'SF Mono', 'Cascadia Mono', 'Roboto Mono', Menlo, monospace;

  /* shape & spacing */
  --radius: 12px;             /* grouped cards */
  --radius-sm: 8px;           /* badges, code chips */
  --radius-lg: 16px;          /* hero cards, modals */
  --inset: 16px;              /* standard layout margin & cell padding */
  --gap: 20px;                /* between grouped sections (use 35px above section labels) */
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg: #000000;
    --card: #1C1C1E;
    --card-2: #2C2C2E;
    --fill: rgba(120,120,128,0.24);
    --separator: rgba(84,84,88,0.60);

    --label: #FFFFFF;
    --label-2: rgba(235,235,245,0.60);
    --label-3: rgba(235,235,245,0.30);

    --blue:   #0A84FF;
    --green:  #30D158;
    --red:    #FF453A;
    --orange: #FF9F0A;
    --yellow: #FFD60A;
    --teal:   #40C8E0;
    --indigo: #5E5CE6;
    --purple: #BF5AF2;
    --pink:   #FF375F;
    --gray:   #8E8E93;

    --accent-fill: rgba(10,132,255,0.16);
  }
}
```

To lead a page with a non-blue accent, redefine only `--accent` and `--accent-fill` in both themes; never restyle components directly.

## Type scale (iOS text styles)

| Role | Style | CSS |
|---|---|---|
| Page header | Large Title | `font-size:34px; font-weight:700; letter-spacing:-0.4px; line-height:1.2` |
| Major section | Title 2 | `font-size:22px; font-weight:700; letter-spacing:-0.3px` |
| Subsection / card title | Title 3 | `font-size:20px; font-weight:600` |
| Emphasized row text | Headline | `font-size:17px; font-weight:600` |
| Body | Body | `font-size:17px; font-weight:400; line-height:1.5` |
| Secondary body | Subheadline | `font-size:15px; color:var(--label-2)` |
| Meta, captions | Footnote | `font-size:13px; color:var(--label-2)` |
| Section label (above a group) | Footnote caps | `font-size:13px; text-transform:uppercase; letter-spacing:0.05em; color:var(--label-2); padding:0 var(--inset); margin-bottom:8px` |
| Hero numbers | Large Title + | `font-size:clamp(34px,5vw,48px); font-weight:700; font-variant-numeric:tabular-nums` |

Body text column: max ~65ch. Headings get `text-wrap: balance`.

## Component patterns

**Page scaffold** — centered column, `max-width: 880px`, padding `0 var(--inset) 120px`. Body background `var(--bg)`, plain — no gradients or grid textures.

**Large-title header** — Large Title + one Subheadline line below it, 60-80px top padding. Optionally preceded by a Footnote-caps eyebrow in `var(--accent)`.

**Sticky header / nav** (pages with 4+ sections) —
```css
position: sticky; top: 0;
background: color-mix(in srgb, var(--bg) 75%, transparent);
backdrop-filter: blur(20px) saturate(180%);
border-bottom: 0.5px solid var(--separator);
```

**Inset-grouped card** — the workhorse surface:
```css
background: var(--card); border-radius: var(--radius); overflow: hidden;
```
No border, no shadow in light mode (the ground/card contrast is the boundary). If depth is truly needed (hero card): `box-shadow: 0 1px 3px rgba(0,0,0,0.06)`.

**List rows inside a card** — `padding: 12px var(--inset)`, hairline between rows:
```css
.row + .row { border-top: 0.5px solid var(--separator); }
```
Leading icon (optional): 29×29 rounded-square (`border-radius:7px`) in a system color with a white inline-SVG glyph, like Settings. Trailing detail: Subheadline in `var(--label-2)`, or a chevron `›` in `var(--label-3)`.

**Pill badge** — `font-size:13px; font-weight:600; padding:3px 10px; border-radius:100px; background:var(--accent-fill); color:var(--accent)`. Semantic variants swap in green/orange/red pairs.

**Status dot** — 8px circle in `--green`/`--orange`/`--red` + Footnote label. Never emoji.

**Callout row** — grouped card with a leading 29px icon square in the semantic color; body in Subheadline. Use for warnings, tips, notes.

**Segmented look** (for showing options/modes) — a `--fill` track, `border-radius:9px; padding:2px`; selected segment `background:var(--card); border-radius:7px; box-shadow:0 1px 2px rgba(0,0,0,0.08); font-weight:600`.

**Code block** — `background:var(--card-2)` inside cards or `var(--card)` on the ground; `font-family:var(--font-mono); font-size:13px; white-space:pre-wrap; border-radius:var(--radius-sm); padding:12px var(--inset)`. Header bar: Footnote filename in `var(--label-2)` with a hairline underneath. Inline code: `background:var(--fill); border-radius:4px; padding:1px 5px`.

**Table as grouped list** — wrap in an inset-grouped card with `overflow-x:auto`. `thead th`: Footnote-caps styling, hairline bottom border, sticky with the material-blur recipe. Rows: hairline separators, hover `background:var(--fill)`. Numerics right-aligned `tabular-nums`.

**Buttons/links** — text buttons in `var(--accent)`, weight 600, no underline; filled buttons `background:var(--accent); color:#fff; border-radius:12px; padding:12px 20px; font-weight:600`. Visible keyboard focus: `outline: 2px solid var(--accent); outline-offset: 2px`.

## Mermaid themeVariables

```js
mermaid.initialize({
  theme: 'base',
  themeVariables: {
    fontFamily: '-apple-system, BlinkMacSystemFont, sans-serif',
    primaryColor: isDark ? '#1C1C1E' : '#FFFFFF',        // node fill = card
    primaryBorderColor: isDark ? 'rgba(84,84,88,0.6)' : 'rgba(60,60,67,0.29)',
    primaryTextColor: isDark ? '#FFFFFF' : '#000000',
    lineColor: isDark ? '#8E8E93' : '#8E8E93',
    secondaryColor: isDark ? 'rgba(10,132,255,0.16)' : 'rgba(0,122,255,0.12)',
    tertiaryColor: isDark ? '#2C2C2E' : '#F2F2F7',       // subgraph fill
  }
});
```
Set `isDark` from `matchMedia('(prefers-color-scheme: dark)')`. Highlighted/primary nodes: `classDef accent fill` in the accent-fill color with an accent border.

## Chart.js palette

Series order: blue, green, orange, indigo, teal, pink (theme-appropriate variants). Grid lines `var(--separator)`, axis labels Footnote-size in `var(--label-2)`, no chart borders, 2px line width, area fills at 12% opacity of the series color.

## SF-Symbol-like glyphs

Inline SVG, `stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"`, on a 24×24 viewBox, rendered at 16-20px. Simple geometric forms only (chevrons, checkmark, exclamation, gear, doc, arrow). Color via the parent's `color`.

## Motion

```css
@media (prefers-reduced-motion: no-preference) {
  .fade { opacity:0; transform:translateY(8px); animation:fadeUp .35s cubic-bezier(.25,.1,.25,1) forwards; }
  @keyframes fadeUp { to { opacity:1; transform:none; } }
}
```
Stagger siblings by 0.05s. Hover transitions ≤0.2s. Nothing loops after load.
