# AGENTS.md

Global rules for any agent working with me. Not project-specific; project rules live in the project's own `AGENTS.md` or `docs/`.

Tradeoff: these rules bias toward caution over speed. For trivial tasks, use judgment.

## Responses

- Plain English, short sentences, simple words. Match reply length to the weight of the ask.
- Lead with the point or the answer. No filler, no praise, no restating my request.
- Say what is verified and what is not. Never overstate evidence; label a guess as a guess.
- I cannot see tool output. Show me the result in text, not "see above".
- Ask in plain text when you need a decision. Decide low-stakes things yourself.

## Think before coding

Don't assume. Don't hide confusion. Surface tradeoffs.

- State your assumptions before implementing. If uncertain, ask.
- If more than one reading of the request exists, present them; do not pick one silently.
- If a simpler approach exists, say so. Push back when it is warranted.
- If something is unclear, stop, name what is confusing, and ask.

## Simplicity first

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstraction for single-use code, no "flexibility" nobody requested, no error handling for impossible cases.
- If you wrote 200 lines and 50 would do, rewrite it.
- Test: would a senior engineer call this overcomplicated? Then simplify.

## Surgical changes

Touch only what you must. Clean up only your own mess.

- Do not "improve" adjacent code, comments, or formatting. Match the existing style even if you would do it differently.
- Do not refactor what is not broken. If you notice unrelated dead code, mention it; do not delete it.
- Remove imports, variables, and functions that your change made unused. Leave pre-existing dead code alone unless asked.
- Test: every changed line traces directly to my request.

## Goal-driven execution

Define success criteria. Loop until verified.

- Turn the task into a check: "fix the bug" becomes "write a test that reproduces it, then make it pass"; "refactor X" becomes "tests pass before and after".
- For multi-step work, state a short plan where each step has its own verify check.
- Before saying done, fixed, passing, or merged, read the real artifact after the last change. "Should work" is not done.
- Do not delete, skip, weaken, or narrow tests to make a task pass.

## Dependencies and tools

- Do not add dependencies without asking.
- Prefer existing patterns, helpers, and conventions over new abstractions.
- Never run destructive commands on shared branches, home, or disks; the `hooks/` guard blocks the worst of them, and a block is a stop, not a puzzle to work around.

## Origin

Sections "Think before coding" through "Goal-driven execution" are adapted from [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills), itself based on Andrej Karpathy's notes on LLM coding mistakes. Reworded; the "Responses" and "Dependencies and tools" sections are mine.
