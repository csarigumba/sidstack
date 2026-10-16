# Feature map example

A small web app (a notes page) with two features. The index lists every feature file; each feature file has the same four H2s. Selectors and commands below were read from that app's source; yours come from your repo.

## `features/README.md`

```markdown
# Feature map: notes

Harness: Playwright (`npx playwright test --config .claude/skills/verify-notes/playwright.config.ts`).
Launch: `npm run dev` on http://localhost:5173, ready when the log prints `ready in`.

| feature | file | entry point |
|---|---|---|
| Create a note | create-note.md | "New note" button on / |
| Search notes | search-notes.md | search box on / |
```

## `features/create-note.md`

```markdown
# Create a note

## Sub-features
- Title and body fields; body is optional.
- Save with the Save button or Cmd+Enter.
- The new note appears at the top of the list on /.

## How to get to it (user POV)
1. Open http://localhost:5173/.
2. Click the button labeled "New note".
3. Type a title, optionally a body, click "Save".

## Driving it with Playwright
- `page.getByRole('button', { name: 'New note' }).click()`
- `page.getByLabel('Title').fill('Buy milk')`
- `page.getByRole('button', { name: 'Save' }).click()`
- Proof of end state: `page.getByRole('listitem').first()` has text `Buy milk`; screenshot to `evidence/01-create-note.png`.
- Side effect: `curl -s localhost:5173/api/notes | jq '.[0].title'` returns `"Buy milk"`.

## Gotchas
- The list re-renders after save; wait for the list item, not for a timeout.
- Dev server seeds three notes on start; the new one is index 0, not index 3.
```
