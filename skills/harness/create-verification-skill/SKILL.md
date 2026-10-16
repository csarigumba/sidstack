---
name: create-verification-skill
description: Generate a project-local verify-<app> skill that drives the real app the way a user does, plus a feature map, for any surface (web, Electron, CLI, TUI, HTTP service). Use for /create-verification-skill, "make a verify skill for this repo", or when a project has no scripted way to prove behavior. /ship runs this first when the project has none.
disable-model-invocation: true
---

# Create a verification skill

Every project that agents work on needs one scripted way to launch the real app, drive a feature the way a user would, and capture evidence. Without it the human is the verifier and nothing can run unattended. This skill generates that as a project-local skill at `.claude/skills/verify-<app>/`, written for the next agent: it will be read cold, mid-task, by an agent that has never seen the app.

## 1. Interview the repo, not the user

Answer from the codebase. Ask the user only what you cannot observe.

- **Surface.** What does a user touch? Web UI, CLI/TUI, desktop app, HTTP API, mobile app, library. Pick the primary one; note the rest.
- **Run.** How does it start locally? Use the repo's own documented command (package scripts, Makefile, README). Note ports, env vars, seed data, auth. A static site with no build runs under `python3 -m http.server <port>` from its directory; say so.
- **Drive.** How can an agent interact programmatically? Existing harnesses first (Playwright or Cypress specs, expect scripts, curl-able endpoints, a debug port). Otherwise the default for the surface:

| surface | default harness | evidence |
|---|---|---|
| web, Electron | Playwright via `npx playwright` (dev dep `@playwright/test`, then `npx playwright install chromium`) | screenshots, page text, console errors |
| CLI, TUI | tmux session or PTY transcript | terminal transcript, exit code |
| HTTP service | curl | response body, status, side-effect check |
| library | its test runner on a small driver script | runner output |

- **Observe.** What proves a result: screenshot, transcript, response body, log line, exit code, DB row, file on disk.
- **Isolate.** Can two instances run side by side (ports, data dirs, profiles)? If not, the generated skill must say so and refuse to double-drive a shared instance.

If the checkout does not build or start as-is, fix that first or report it precisely. A skill written against a broken base teaches wrong steps.

## 2. Generate the skill

Write `.claude/skills/verify-<app>/SKILL.md` with frontmatter `name: verify-<app>` and a `description` that names the app, the surface, and when to use it. Then these sections, each grounded in what step 1 found. No placeholders. Every selector, command, port, and path comes from the repo or from a run you did.

- **Launch.** The exact command, how to tell it is ready (a log line, a port answering), and teardown. For a short-lived CLI, launch means build once; each drive is its own PTY.
- **Doctor.** One read-only check that answers "is this instance worth driving?": process up, right build, port owned by us, auth valid. Run it first whenever anything looks off.
- **Drive.** The harness recipe with real selectors and commands. Prefer stable handles (ARIA roles, `data-testid`, prompt strings, routes) over coordinates.
- **Evidence.** What to capture and where: `.sidstack/runs/<run>/evidence/` when run under `/ship`, else `.sidstack/evidence/`. Standards: drive the real user path, not internal setters or test-only endpoints; capture the action and the resulting state, not only the final screen; verify side effects alongside what is visible; mocks only where a production boundary already isolates the external system.
- **Cleanup.** Tear down what the run created. Kill what you started, never by process name. Cleanup removes instances and scratch state, never evidence.
- **Helpers.** Any script the skill ships is executable and its invocation is shown in the skill body.

## 3. Seed the feature map

Create `.claude/skills/verify-<app>/features/README.md` as an index, plus one file per user-facing feature for the top 3–5 (from routes, commands, menus, docs). Each feature file has exactly these H2s: `Sub-features`, `How to get to it (user POV)`, `Driving it with <harness>`, `Gotchas`. The map is the repo's maintained verification source: a proof that drives one convenient entry point is incomplete when the map lists others. Shape: `references/feature-map-example.md`.

## 4. Prove it once before handing it over

Run the generated skill's own instructions end to end: launch, doctor, drive one mapped feature, capture evidence, cleanup. Then confirm the evidence file still exists at the named path. Fix what fails; run cleanup after every failed attempt so broken runs do not strand processes and ports.

A generated skill that was never executed is a draft, not a deliverable.

## 5. Report

List: the skill path, the features mapped, the one feature proven and its evidence path, dev dependencies installed, and anything step 1 could not determine from the repo.

## Must not

- Invent a selector, command, port, or path that was not read from the repo or observed in a run.
- Mark a feature as drivable without having driven it or a sibling that uses the same harness.
- Leave a server running after step 4.

## Origin

Adapted from [pstack](https://github.com/cursor/plugins/tree/main/pstack) `create-verification-skill` by Lauren Tan (MIT). Changes: Claude Code paths (`.claude/skills/`), evidence paths under `.sidstack/`, a default-harness table per surface, and shortened.
