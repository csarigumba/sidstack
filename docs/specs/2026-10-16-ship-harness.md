# Ship harness — design

Date: 2026-10-16. Status: draft for review.

## Goal

A mode in sidstack that takes a goal and drives it to a PR with no human in the loop: plan, split into independent tasks, run them in parallel, prove each one on the real app, review with fresh eyes, open the PR with evidence. I merge; the agent never does.

Two things matter most: **parallelization** (independent tasks run at the same time in isolated worktrees) and **trust** (nothing is called done without evidence from the real artifact; the review is done by an agent that did not write the code).

Inspiration: Lauren Tan's pstack (`/poteto-mode`, playbooks, `create-verification-skill`, prove-it-works) and her talk on trust layers. Bare skeleton now; iterate later.

## Approaches considered

| | Approach | Trade-off |
|---|---|---|
| **A (chosen)** | Markdown skills + Claude Code subagents. `ship` is a skill that routes to a playbook and dispatches subagents; parallelism comes from Claude Code running several subagents at once, isolation from `isolation: worktree`. | Zero new code, matches the repo (plain markdown, agent-agnostic skills). Parallelism is as good as the model's dispatching; no hard scheduler. |
| B | A script orchestrator (bash/node) that loops `claude -p` per task in its own worktree. | Deterministic fan-out and budgets, but it is a new program to maintain, Claude-only, and duplicates what subagents already do. Revisit if A's parallelism proves unreliable. |
| C | Hooks first: a `Stop` hook that refuses to end a session until a verify report exists. | Strongest trust layer (enforcement, not guidance), but it needs per-project test commands. Planned as the next iteration, not the skeleton. |

## Components

All inside the sidstack plugin. New category `skills/harness/`, new `agents/` dir, two new principles.

### 1. `skills/harness/ship/SKILL.md` — the mode

Trigger: `/sidstack:ship <goal>` or "ship this: ...". Not invoked by the model on its own (`disable-model-invocation: true`).

Steps, in order:

1. **Contract.** Restate the goal as done-when checks. If the goal is a product or preference call no experiment can settle, ask once; otherwise decide, note the assumption, and continue. A question that can be answered by running something is not the human's to answer.
2. **Verification first.** Look for a project-local `verify-*` skill (`.claude/skills/verify-*/SKILL.md`). If missing, run `create-verification-skill` before building anything. No verify skill, no build.
3. **Plan and split.** Write `.sidstack/runs/<ts>-<slug>/plan.md`: tasks with files touched and the done-when check each one owns. Split only along lines that do not share files. One task is a valid plan.
4. **Fan out.** Dispatch one `builder` subagent per task, in parallel, each in its own worktree, with the task brief, the verify skill, and the rule set. Builders do not merge or open PRs.
5. **Integrate.** Merge the task branches into one `ship/<slug>` branch. Run the full test suite once on the merged result.
6. **Prove.** Dispatch `verifier` on the merged branch: drive the real app per the verify skill, save evidence under `.sidstack/runs/<run>/evidence/`.
7. **Review.** Dispatch `reviewer` with a clean context on the diff and the evidence. A blocking finding goes back to step 4 for that task, at most two rounds; then stop and report.
8. **Ship.** Open the PR (never merge). PR body = done-when checks with evidence per check, reviewer verdict, assumptions, and what was not verified. Report the PR URL and the evidence paths.

Done-gate: the mode may not say done without (a) test output read after the last change, (b) evidence files at a named path, (c) a reviewer verdict, (d) a PR URL. Missing one means report "not shipped" and why.

Autonomy grant: under `ship`, the agent may add dev-only dependencies needed for verification (for example a browser driver) and must list them in the PR body. Nothing else in `AGENTS.md` is relaxed.

### 2. `skills/harness/create-verification-skill/SKILL.md`

Adapted from pstack (MIT, Lauren Tan; `## Origin` section). Generates `.claude/skills/verify-<app>/SKILL.md` plus `features/README.md` and one file per top feature (the feature map). Interviews the repo, not the user: surface, run command, drive harness, evidence, isolation, cleanup. Proves the generated skill once end to end before handing it over. For web surfaces the default harness is Playwright via `npx`; CLIs use a PTY/tmux recipe; services use curl.

### 3. Subagents (`agents/*.md`)

| agent | model | tools | isolation | job |
|---|---|---|---|---|
| `builder` | inherit | Read, Edit, Write, Bash, Grep, Glob | worktree | One task from the plan. TDD where tests exist. Runs the task's tests and the verify skill on its own slice. Returns: branch name, files changed, test output, evidence paths. Never merges, never opens PRs. |
| `verifier` | inherit | Read, Bash, Grep, Glob | none | Drives the real app per the verify skill against the integrated branch. Writes evidence (screenshots, transcripts, exit codes) under the run dir. Returns pass/fail per done-when check with the artifact path for each. |
| `reviewer` | inherit | Read, Grep, Glob, Bash (read-only git) | none | Fresh context. Reads the diff, the plan, and the evidence. Looks for: done-when checks without evidence, tests weakened or skipped, scope creep, patterns the repo forbids, comments used as band-aids. Returns: ship / fix (with the list) / stop. |

### 4. Principles (`skills/principles/`)

- `principle-prove-it-works` — verify against the real artifact (run it, read the value, inspect the diff), not a proxy or self-report. Script the check when you can and keep the output. (Adapted from pstack.)
- `principle-fresh-eyes-review` — the agent that wrote the code does not grade it; a reviewer with clean context does. A claim of done arrives with evidence, never alone.

Both added to `docs/PHILOSOPHY.md`.

### 5. Manifest and docs

- `plugin.json`: add `"./skills/harness/"` to `skills`, add `"agents": "./agents/"`. Bump version to `0.15.0` in both manifests.
- `README.md`: new "Harness" section (what `ship` does, what it will not do), rows in the tables, layout tree updated.
- `scripts/validate.sh`: also check that every `agents/*.md` has frontmatter `name` matching the filename.

## Data flow

```
goal ─▶ ship ─▶ plan.md ─▶ builder ×N (worktrees) ─▶ ship/<slug> branch
                                                        │
                      PR (evidence, verdict) ◀── reviewer ◀── verifier
```

Run state lives in `.sidstack/runs/<ts>-<slug>/` inside the target project, gitignored by `ship` on first use. It holds `plan.md`, `evidence/`, `review.md`, `report.md`.

## Error handling

- Builder fails its own check: it reports the failure with output; `ship` retries that task once with the failure in the brief, then marks it blocked and continues with the rest.
- Merge conflict between task branches: `ship` resolves if trivial, otherwise serializes the conflicting tasks (one builder after another).
- Verifier cannot launch the app: stop, report "not verified", do not open the PR.
- Reviewer says stop: no PR; report the reason and the branch name.
- No `gh` or no remote: commit to `ship/<slug>` and report; say the PR step was skipped.

## Testing the skeleton

1. `scripts/validate.sh` and `claude plugin validate . --strict` pass.
2. Throwaway repo `/Users/apple/dev/priv/tictactoe-lab` (git init, empty, feature branch). Run:
   `claude -p "/sidstack:ship build a tic-tac-toe web page: two players, win and draw detection, reset button, no frameworks" --permission-mode auto --plugin-dir /Users/apple/dev/priv/sidstack --max-turns 150 --output-format json`
3. Success = a `ship/*` branch with a working page, a `verify-*` skill with a feature map, evidence files on disk, a review verdict, and either a PR or a clear "PR skipped: no remote". I open the page in a browser myself as the final check.

## Out of scope (next iterations)

Stop hook enforcement (approach C), evals for the skills, auto-merge, cloud/scheduled triggers, multi-model routing, PR budget hook, `/swarm` as a standalone skill.
