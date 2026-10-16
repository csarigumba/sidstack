---
name: ship
description: Drive a goal to a pull request with no human in the loop. Contract, verify skill, plan, parallel builders in git worktrees, integrate, prove on the real app, fresh-eyes review, PR with evidence. Use for /ship <goal>, "ship this", or "build this end to end". Never merges.
disable-model-invocation: true
---

# Ship

You own the outcome, not the typing. Builders write code in parallel; a verifier proves it on the real app; a reviewer who did not write it grades it; you open the PR with the evidence. You never merge. The human merges.

Read `docs/PHILOSOPHY.md` if the repo has one. The principles that govern this run: **prove-it-works** (every claim has an artifact) and **fresh-eyes-review** (the writer never grades).

## Setup, once per repo

1. If the repo has no commits, make an empty initial commit; worktrees need a base.
2. If `.gitignore` lacks `.sidstack/` or `.claude/worktrees/`, append both and commit that alone (`chore: ignore sidstack run state and worktrees`).
3. `RUN=.sidstack/runs/$(date +%Y%m%d-%H%M%S)-<slug>`; `mkdir -p $RUN/evidence`. Everything this run writes goes there.
4. Note `DEFAULT=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#origin/##' || git rev-parse --abbrev-ref HEAD)`. Builders' worktrees branch from the default branch, so integration must too.

## Steps

### 1. Contract

Restate the goal as numbered **done-when checks**: each one a user-visible outcome a verifier can drive and capture. Write them to `$RUN/plan.md` under `## Done when`.

Ask the user only for a product or preference call that no experiment can settle, and ask once. Anything you can find out by running something is yours to find out. Otherwise decide, write the assumption under `## Assumptions`, and continue.

Under `/ship` you may add dev-only dependencies that the verify skill needs (a browser driver, a test runner). List each under `## Dev dependencies`. Nothing else in `AGENTS.md` is relaxed.

### 2. Verification first

Look for `.claude/skills/verify-*/SKILL.md`. If none exists, run `create-verification-skill` now, on the repo as it is (for an empty repo: scaffold the minimal runnable surface the goal implies first, commit it, then generate). No verify skill, no builders. Record the path as `VERIFY`.

### 3. Plan and split

Append to `$RUN/plan.md` a `## Tasks` table: `id | task | done_when (one check id) | files_allowed | test_command`. Split only along lines that share no files. A task that would need another task's file is one task. One task is a valid plan. Write this before dispatching anything; the plan is what the reviewer grades against.

### 4. Fan out

Dispatch one `sidstack:builder` per task, all at once, each with: `goal`, `task`, `done_when`, `files_allowed`, `verify_skill=VERIFY`, `test_command`. Builders run in their own worktrees and return a branch name.

When a builder returns `blocked`, re-dispatch that task once with the blocker text in the brief. A second block marks the task blocked in `$RUN/plan.md`; continue with the rest.

### 5. Integrate

```
git checkout -b ship/<slug> $DEFAULT
for each builder branch: git merge --no-ff <branch> -m "merge: <task id>"
```

A conflict between two builder branches: resolve it if it is a trivial overlap; otherwise abort that merge, re-dispatch the second task on top of `ship/<slug>` with `files_allowed` unchanged, and merge its new branch. Then remove every builder worktree (`git worktree remove <path>` and `git branch -D <branch>`); `-p` runs do not clean them up for you.

Run the full test suite once on `ship/<slug>`. Save output to `$RUN/tests.txt`. Red means fix (re-dispatch the owning task with the failure) before anything else.

### 6. Prove

Dispatch `sidstack:verifier` with `branch=ship/<slug>`, `verify_skill=VERIFY`, the done-when list, `evidence_dir=$RUN/evidence`. Save its table to `$RUN/verify.md`. A `cannot verify` result ends the run as not shipped; a `fail` row goes back to the owning builder.

### 7. Review

Dispatch `sidstack:reviewer` with `base=$DEFAULT`, `head=ship/<slug>`, `plan=$RUN/plan.md`, `evidence_dir`, and the verifier table. Save to `$RUN/review.md`.

- `ship` → step 8.
- `fix` → re-dispatch the owning builders with the findings, then repeat steps 5–7. At most two fix rounds; then stop and report.
- `stop` → no PR. Report the reason and the branch.

### 8. Ship

Write `$RUN/report.md` from `references/report-template.md`. Then:

```
gh pr create --base $DEFAULT --head ship/<slug> --title "<slug>" --body-file $RUN/report.md
```

No remote or no `gh`: skip, and write `PR skipped: <reason>` in the report. Never merge, never enable auto-merge.

## Done gate

You may say "shipped" only when all four exist and were produced after the last code change:

1. `$RUN/tests.txt` with the suite's own pass line.
2. Evidence files under `$RUN/evidence/`, one per done-when check, cited in `$RUN/verify.md`.
3. `$RUN/review.md` with `verdict: ship`.
4. A PR URL, or `PR skipped: <reason>`.

Missing any → say "not shipped", name what is missing, and give the branch name.

## When things go wrong

| situation | do |
|---|---|
| builder blocked twice | mark blocked in plan, continue, say so in report |
| merge conflict | trivial → resolve; otherwise serialize the second task on top of `ship/<slug>` |
| verifier cannot launch | stop; report "not verified"; no PR |
| reviewer `stop` | no PR; report reason and branch |
| no remote or no `gh` | commit to `ship/<slug>`; report "PR skipped" |
| budget or turn limit near | write `$RUN/report.md` with current state first; a partial report beats none |

## Final reply to the human

Short. Branch, PR URL or why not, the done-when table with pass/fail and evidence paths, assumptions, dev deps added, what was not verified. No narration of the steps.
