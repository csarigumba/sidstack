---
name: principle-prove-it-works
description: Principle. Apply after completing a task and before declaring it done. Verify against the real artifact (run the feature, read the actual value, inspect the diff), not a proxy, a self-report, or "it compiles". Script the check when you can and keep the output.
---

# Prove it works

**Rule:** Every task output is verified by checking the real thing directly. Run the feature the way a user would, read the actual value, open the actual diff. "It compiles", "the test file exists", "the subagent said it passed" are not proof.

## Why

Unverified work has unknown correctness. Indirect checks (file timestamps, a cached screenshot, an agent's own summary) feel cheaper than direct observation, but acting on a wrong inference costs far more than the check.

## How to apply

1. Name the observable outcome the task promised, from the user's point of view: the page shows the winner, the CLI exits 0 with this output, the row is in the table.
2. Produce it on the real artifact: launch the app, drive the path, read the result. Prefer the repo's verification skill (`verify-<app>`) over an ad-hoc script; prefer an ad-hoc script over a one-time eyeball.
3. Capture evidence a reviewer can re-run or re-read: the command, its output, a screenshot, a transcript. Save it at a named path and report that path, not a description of it.
4. Check side effects too: files written, rows inserted, messages sent. The final screen alone does not prove the action happened.
5. When a check fails, suspect the observation method before the system; then fix the system, not the check.

## Smells that mean you skipped this

- "Tests pass" with no test output in the report.
- Evidence produced before the last code change.
- A screenshot of the start state but not the end state.
- Proof that drove a test-only endpoint or an internal setter instead of the user path.
- Reporting what a subagent said instead of what its artifact shows.

## Origin

Adapted from [pstack](https://github.com/cursor/plugins/tree/main/pstack) `principle-prove-it-works` by Lauren Tan (MIT). Reworded, shortened, and tied to the `verify-<app>` skill this repo generates.
