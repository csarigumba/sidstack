# Ship Harness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `ship` mode to the sidstack plugin that drives a goal to a PR with parallel worktree-isolated builders, real-app verification, and a fresh-context review; then prove it on a tic-tac-toe page.

**Architecture:** Plain-markdown skills (`skills/harness/`) plus three plugin subagents (`agents/`) and two principle skills. No orchestrator code; parallelism is Claude Code dispatching subagents, isolation is `isolation: worktree`. Run state lives in the target project under `.sidstack/runs/<run>/`.

**Tech Stack:** Markdown (Agent Skills format), Claude Code plugin manifest, bash validator, `claude plugin validate`.

**Spec:** `docs/specs/2026-10-16-ship-harness.md`

## Global Constraints

- Skill dirs: `skills/<category>/<name>/SKILL.md`; frontmatter `name` == dir name, lowercase-kebab, non-empty `description`; names global across categories (validator enforces).
- Agents: `agents/<name>.md`, frontmatter `name` == filename stem, `description` required; plugin subagents ignore `permissionMode`, `hooks`, `mcpServers`.
- Version bump to `0.15.0` in both `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`.
- Agent never merges; PR body carries evidence; done-gate = test output + evidence files + reviewer verdict + PR URL.
- Writing style of the repo: procedure first, one clause of why per rule, say what must not be invented, end with the gate that means done. No employer/project specifics. Adapted content gets `## Origin`.
- Autonomy relaxation under `ship`: dev-only verification deps allowed, listed in the PR. Nothing else in `AGENTS.md` relaxed.

## Review Focus

1. Builder worktrees branch from the default branch, not the ship branch — the ship skill must merge task branches into `ship/<slug>` rather than assume they stack. Pinned in Task 4 step 2 (integrate step text) and exercised in Task 6.
2. `-p` runs do not clean worktrees — ship must gitignore `.claude/worktrees/` and remove task worktrees after merge. Task 4 step 2, checked in Task 6 step 5.
3. A project with no git remote / no `gh` — ship must still finish with a branch and say the PR was skipped. Task 4 error table; Task 6 runs without a remote so this path is the one exercised.
4. A verify skill that was generated but never executed — `create-verification-skill` must run its own instructions once. Task 3 step 1 section 4; checked in Task 6 step 5 (evidence from the verify run exists).
5. Reviewer rubber-stamping — reviewer must list the done-when checks and cite an evidence path per check or return `fix`. Task 2 reviewer prompt; checked in Task 6 step 5 (review.md cites paths).

---

### Task 1: Principle skills

**Files:**
- Create: `skills/principles/principle-prove-it-works/SKILL.md`
- Create: `skills/principles/principle-fresh-eyes-review/SKILL.md`
- Modify: `docs/PHILOSOPHY.md` (principles table)

**Interfaces:**
- Produces: skill names `principle-prove-it-works`, `principle-fresh-eyes-review` (referenced by Tasks 2 and 4 via the plugin-scoped form `sidstack:principle-...` in `skills:` frontmatter).

- [ ] **Step 1: Write `principle-prove-it-works`** — format mirrors `principle-verify-before-claiming`: Rule / Why / How to apply / Smells. Rule: verify against the real artifact (run the feature, read the value, inspect the diff), not a proxy, self-report, or "it compiles"; script the check when you can and keep the output as an artifact a reviewer can re-run. `## Origin`: pstack `principle-prove-it-works`, Lauren Tan, MIT, reworded and shortened.
- [ ] **Step 2: Write `principle-fresh-eyes-review`** — Rule: the agent that wrote a change does not grade it; a reviewer with clean context reads the diff plus the evidence and returns a verdict. Why: the writer's context has already rationalized its gaps. How: reviewer gets diff, plan, evidence paths; nothing from the writer's conversation. Smells: "self-reviewed", reviewer and writer in the same session, verdict without a cited artifact.
- [ ] **Step 3: Add two rows to `docs/PHILOSOPHY.md`** (group `verification` for both).
- [ ] **Step 4: Run `scripts/validate.sh`** — Expected: `ok: 20 skills, ...` (18 existing + 2).
- [ ] **Step 5: Commit** `feat(principles): prove-it-works, fresh-eyes-review`

### Task 2: Subagents

**Files:**
- Create: `agents/builder.md`, `agents/verifier.md`, `agents/reviewer.md`
- Modify: `scripts/validate.sh` (agents check), `.gitignore` (no change needed; worktrees live in target projects)

**Interfaces:**
- Produces: subagents `sidstack:builder`, `sidstack:verifier`, `sidstack:reviewer` with the return contracts below; Task 4 dispatches them by these names and parses these returns.

- [ ] **Step 1: `agents/builder.md`** — frontmatter: `name: builder`, `description` ("One task from a ship plan, in an isolated worktree. Builds, tests, proves its slice, commits, reports the branch. Never merges or opens PRs."), `tools: Read, Edit, Write, Bash, Grep, Glob`, `isolation: worktree`, `skills: sidstack:principle-prove-it-works`. Body: input = task brief (goal, done-when check, files allowed, verify skill path, test command); procedure = read the files named, write a failing test where a test harness exists, implement, run tests, run the verify skill for its slice, commit on the worktree branch; return exactly: `branch`, `files_changed`, `test_output` (last 20 lines), `evidence` (paths), `assumptions`, `blocked` (reason or none). Must not: touch files outside `files allowed` without saying so, weaken tests, merge, push, open PRs, add non-dev dependencies.
- [ ] **Step 2: `agents/verifier.md`** — `name: verifier`, `tools: Read, Bash, Grep, Glob`, `skills: sidstack:principle-prove-it-works`. Body: input = branch, verify skill path, done-when checks, evidence dir; procedure = checkout is already on the branch, run the verify skill's launch → doctor → drive each done-when check → capture evidence → cleanup; return a table `check | pass/fail | artifact path`; a check with no artifact is `fail`. Must not edit source files.
- [ ] **Step 3: `agents/reviewer.md`** — `name: reviewer`, `tools: Read, Grep, Glob, Bash`, `skills: sidstack:principle-fresh-eyes-review`, `omitClaudeMd: false`. Body: input = base ref, head ref, plan path, evidence dir, verifier table; procedure = `git diff base...head`, read plan, read evidence; check list: every done-when check has a passing artifact; no test deleted/skipped/narrowed; diff stays inside the plan's files; no comment used to justify a workaround; no secrets; return `verdict: ship|fix|stop` plus findings, each with file:line and the fix; `Bash` limited to read-only git (state this in the body: no checkout, commit, push, merge).
- [ ] **Step 4: Extend `scripts/validate.sh`** — loop `agents/*.md`: first line `---`, frontmatter `name` equals filename stem, `description` non-empty; count agents in the ok line (`ok: N skills, M agents, ...`).
- [ ] **Step 5: Run `scripts/validate.sh`** — Expected: `ok: 20 skills, 3 agents, version 0.14.0 ...`.
- [ ] **Step 6: Commit** `feat(agents): builder, verifier, reviewer subagents; validator checks agents`

### Task 3: `create-verification-skill`

**Files:**
- Create: `skills/harness/create-verification-skill/SKILL.md`
- Create: `skills/harness/create-verification-skill/references/feature-map-example.md`

**Interfaces:**
- Produces: project-local `.claude/skills/verify-<app>/SKILL.md` with sections Launch / Doctor / Drive / Evidence / Cleanup / Helpers, plus `features/README.md` and `features/<feature>.md` (H2s: Sub-features, How to get to it (user POV), Driving it with <harness>, Gotchas). Task 4 looks for `.claude/skills/verify-*/SKILL.md` and invokes it.

- [ ] **Step 1: Write SKILL.md** — frontmatter `name: create-verification-skill`, `disable-model-invocation: true`, description: "Generate a project-local verify-<app> skill that drives the real app the way a user does and a feature map, for any surface. Use for /create-verification-skill or when a project has no scripted way to prove behavior." Sections, in order: 1 Interview the repo not the user (surface, run, drive, observe, isolate; fix a broken checkout first); 2 Generate the skill (the six sections, each grounded, no placeholders); 3 Seed the feature map (README index + top 3-5 features); 4 Prove it once end to end (launch, doctor, drive one feature, evidence survives cleanup; "a generated skill that was never executed is a draft"); 5 Report what was generated and the one feature proven. Default harness table: web/Electron → Playwright via `npx playwright` (install `@playwright/test` as a dev dep + `npx playwright install chromium`; say so in the report); CLI/TUI → tmux/PTY transcript; HTTP service → curl + response body. Evidence standard: real user path, action and resulting state, side effects. Must not invent selectors or commands: every one comes from the repo or from a run. `## Origin`: pstack `create-verification-skill`, Lauren Tan, MIT; changes: Claude Code paths (`.claude/skills/`), default harnesses, shorter.
- [ ] **Step 2: Write `references/feature-map-example.md`** — a complete example for a small web app (two features), showing the README index shape and one feature file with the four H2s and real-looking Playwright steps.
- [ ] **Step 3: Add `"./skills/harness/"` to `plugin.json` `skills`** (needed now or the validator flags the unlisted category).
- [ ] **Step 4: Run `scripts/validate.sh`** — Expected ok, 21 skills.
- [ ] **Step 5: Commit** `feat(harness): create-verification-skill (ported from pstack)`

### Task 4: `ship` mode

**Files:**
- Create: `skills/harness/ship/SKILL.md`
- Create: `skills/harness/ship/references/report-template.md`

**Interfaces:**
- Consumes: `sidstack:builder/verifier/reviewer` return contracts (Task 2), `verify-<app>` skill shape (Task 3).
- Produces: `.sidstack/runs/<ts>-<slug>/{plan.md,evidence/,review.md,report.md}` in the target project; branch `ship/<slug>`; PR or "PR skipped: <reason>".

- [ ] **Step 1: Write SKILL.md frontmatter** — `name: ship`, `disable-model-invocation: true`, description: "Drive a goal to a PR with no human in the loop: contract, verify skill, plan, parallel builders in worktrees, integrate, prove on the real app, fresh-eyes review, PR with evidence. Use for /ship <goal> or 'ship this'. Never merges."
- [ ] **Step 2: Write the eight steps from the spec as the procedure**, each with its gate. Pin these decisions in the text: run dir name `.sidstack/runs/$(date +%Y%m%d-%H%M%S)-<slug>/`; on first use append `.sidstack/` and `.claude/worktrees/` to `.gitignore` and commit that alone; if the repo has no commits, make an initial empty commit first (worktrees need a base); builders' worktree branches start from the default branch, so integration = create `ship/<slug>` from the default branch and `git merge --no-ff <builder-branch>` each, then `git worktree remove` each builder worktree and delete its branch; full test suite runs once on the merged branch before verifier; reviewer gets `base=<default-branch>` `head=ship/<slug>`; max two fix rounds; PR via `gh pr create --base <default> --head ship/<slug> --body-file .sidstack/runs/<run>/report.md`; no remote or no `gh` → skip and say so.
- [ ] **Step 3: Write the Contract rule** — ask once only for a product/preference call no experiment settles; otherwise decide, write the assumption into `plan.md`, continue. Under `/ship` the agent may install dev-only deps needed by the verify skill and must list them in the report.
- [ ] **Step 4: Write the done-gate and the error table** from the spec verbatim (builder fail → retry once with failure in brief → blocked; conflict → serialize; verifier cannot launch → not verified, no PR; reviewer stop → no PR).
- [ ] **Step 5: Write `references/report-template.md`** — headings: Goal; Done-when checks (table: check | result | evidence path); Tests (command + last lines); Review (verdict + findings); Assumptions; Dev dependencies added; Not verified; Branch / PR.
- [ ] **Step 6: Run `scripts/validate.sh`** — Expected ok, 22 skills, 3 agents.
- [ ] **Step 7: Commit** `feat(harness): ship mode`

### Task 5: Manifest, README, validation

**Files:**
- Modify: `.claude-plugin/plugin.json` (version `0.15.0`, keywords add `harness`), `.claude-plugin/marketplace.json` (version `0.15.0`)
- Modify: `README.md` (layout tree, new "Harness" section with the ship flow and the never-merge rule, tables: harness skills, agents, two principle rows)
- Modify: `docs/PHILOSOPHY.md` (mention `ship` as the routing skill that reads the index)

- [ ] **Step 1: Bump versions and edit README/PHILOSOPHY** as listed.
- [ ] **Step 2: Run `scripts/validate.sh && claude plugin validate . --strict`** — Expected: validator ok at version 0.15.0; plugin validate reports no errors (warnings allowed, list them).
- [ ] **Step 3: Run `hooks/test-guard.sh`** — Expected: all asserts pass (nothing touched, regression check).
- [ ] **Step 4: Commit** `feat: ship harness skeleton; v0.15.0` and push to `origin main` (personal remote via `gh auth switch -u csarigumba` / SSH alias `github-personal`).

### Task 6: Prove it on tic-tac-toe

**Files:**
- Create (outside sidstack): `/Users/apple/dev/priv/tictactoe-lab/` — `git init`, `README.md` with one line, initial commit on `main`, then `git checkout -b lab` (user-level guardrail hook blocks edits on `main`).

- [ ] **Step 1: Create the throwaway repo** as above. Expected: `git log --oneline` shows one commit; branch `lab`.
- [ ] **Step 2: Run the harness**
  `cd /Users/apple/dev/priv/tictactoe-lab && claude -p "/sidstack:ship build a tic-tac-toe web page: two players alternate X and O, win and draw detection, a reset button, plain HTML/CSS/JS with no frameworks" --permission-mode auto --plugin-dir /Users/apple/dev/priv/sidstack --max-turns 200 --output-format json > /Users/apple/.hermes/cache/scratch/ship-run.json`
  Expected: exit 0, `subtype: success`; capture `num_turns`, `total_cost_usd`, `duration_ms`.
- [ ] **Step 3: If `--plugin-dir` does not register the skill under `/sidstack:ship`**, fall back to installing from the local marketplace (`claude plugin marketplace add /Users/apple/dev/priv/sidstack && claude plugin install sidstack@sidstack`) and rerun; record which path worked in the final report.
- [ ] **Step 4: Inspect the result** — `git branch -a`, `git log --oneline ship/*`, `ls .sidstack/runs/*/evidence`, `cat .sidstack/runs/*/review.md`, `cat .sidstack/runs/*/report.md`, `ls .claude/skills/verify-*/features`.
- [ ] **Step 5: Final check by me** — open the built page in the browser tool, play one game to a win and one to a draw, press reset; screenshot. Pass criteria: ship branch exists, page works, verify skill + feature map exist, evidence files exist and were produced after the last commit, review.md cites evidence paths, report says "PR skipped: no remote", no leftover builder worktrees (`git worktree list` shows only the main checkout).
- [ ] **Step 6: Report to Sid** — what the harness did on its own, what it got wrong, turns/cost/time, and the first three things to iterate on.
