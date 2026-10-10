# sidstack

My personal agent stack: the skills, workflows, and principles I want every coding agent to follow when it works with me.

The content is plain `SKILL.md` folders (the Agent Skills format). Claude Code, Codex, and Hermes all read it. The Claude Code manifest is a thin pointer at the one `skills/` directory, so switching agents means adding a small manifest, not rewriting anything.

## Install

**Claude Code**

```
/plugin marketplace add csarigumba/sidstack
/plugin install sidstack@sidstack
```

Skills show up namespaced: `/sidstack:plain-writing`.

**Codex / Hermes / anything else that reads `SKILL.md`**: symlink or copy `skills/*` into the agent's skills directory. Nothing in `skills/` depends on a platform.

## Layout

```
skills/                 the only part that matters; one folder per skill
  principle-*/          one principle per folder, one rule each
docs/PHILOSOPHY.md      how I work + index of principles
hooks/                  dangerous-command guard (PreToolUse on Bash) + denylist + tests
.claude-plugin/         Claude Code manifest + single-plugin marketplace
scripts/validate.sh     structural checks (frontmatter, names, version drift)
.github/workflows/      runs the checks + `claude plugin validate --strict`
```

Naming: flat `skills/` with prefixes. `principle-*` for principles, `workflow-*` for multi-step playbooks, no prefix for ordinary skills.

## Skills

| skill | use it when |
|---|---|
| `plain-writing` | the general writing standard: short, direct, plain English, no filler, no invented facts. |
| `proofreading` | proofread, "rewrite in my tone", "improve this", or draft a workplace message or slide script for me. Smallest change that fixes it. |
| `ticket-writing` | write, improve, simplify, or split a ticket or issue for any tracker. No names, no invented facts, done-when checks. |
| `reply-to-thread` | I paste a thread or comment: what are they saying, what do they want from me, my position, then a reply in my voice. |
| `eng-knowledge-share` | turn a brainstormed topic into one visual HTML explainer page plus a short team post. Manual, `/sidstack:eng-knowledge-share <notes.md>`. |
| `bro` | the last message was jargon; restate it like one human talking to another. |
| `grill-me` | I have a plan or design and want it stress-tested one question at a time before building. |
| `show-me` | I would understand the topic faster as a diagram, call tree, diff, or one HTML page than as prose. |

Nothing in this repo is specific to an employer, a client, or a project; those skills stay in their own repos.

Skills adapted from someone else's work say so in an `## Origin` section at the bottom of the file, with the source and what changed.

## Hooks

`hooks/deny-dangerous.sh` runs before every shell command the agent executes (Claude Code `PreToolUse`, matcher `Bash`) and blocks anything matching `hooks/dangerous-patterns.txt`: `rm -rf` of `/` or home, `sudo rm`, raw disk writes, `curl | sh`, `git push --force`, branch deletes, history pruning, `gh ... delete`, making a repo public, and any read of a password manager (`op`, `bw`, `pass`, `lpass`, keychain dumps, secret-key exports). Blocked commands return exit 2 with the matched pattern, and the agent is told not to retry.

The hook is installed automatically with the plugin. It fails open: no `jq` or no patterns file means allow, so a broken hook never freezes every shell call.

Other agents that pass hook JSON on stdin and honor exit 2 (Codex) can point at the same script:

```json
{ "hooks": { "PreToolUse": [ { "matcher": "Bash", "hooks": [ { "type": "command", "command": "/path/to/sidstack/hooks/deny-dangerous.sh" } ] } ] } }
```

Every pattern has a case in `hooks/test-guard.sh` (151 asserts, runs in CI). To add a pattern: add the block case and a nearby allow case to the test first, then the regex. Override the list with `SIDSTACK_DANGEROUS_PATTERNS=/path/to/file`.

## Principles

| principle | rule |
|---|---|
| `principle-verify-before-claiming` | Check the real artifact after the last change before saying done, fixed, passing, or merged. If you did not check, say so. |

Full list and the reasoning behind them: [docs/PHILOSOPHY.md](docs/PHILOSOPHY.md).

## Adding a skill

1. `mkdir skills/<name>` and write `SKILL.md` with `name: <name>` and a `description` that states the trigger in the words I would actually say. The description is the only thing loaded until the skill fires.
2. Procedure first, in execution order. One clause of why per rule. Say what the skill must not invent. End with the gate that means done.
3. If it is adapted from elsewhere, add an `## Origin` section: source link, author, license, what changed.
4. Bump `version` in both manifests under `.claude-plugin/` (`scripts/validate.sh` checks they agree). Installed copies only update when the version changes.
5. `scripts/validate.sh && claude plugin validate . --strict`.

## License

MIT
