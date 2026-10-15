# sidstack

My personal agent stack: the global rules, skills, principles, and guard hook I want every coding agent to follow when it works with me.

The content is plain markdown: an `AGENTS.md` for the standing rules and `SKILL.md` folders for the skills (the Agent Skills format). Claude Code installs it as a plugin; Hermes loads the same folder through `skills.external_dirs`; Codex reads the files directly. The Claude Code manifest is a thin pointer at the one `skills/` directory, so switching agents means adding a small manifest, not rewriting anything.

## Install

**Claude Code**

```
/plugin marketplace add csarigumba/sidstack
/plugin install sidstack@sidstack
```

Skills show up namespaced (`/sidstack:proofreading`) and the guard hook is active immediately.

**Global rules** (`AGENTS.md`) are not delivered by the plugin; a plugin cannot inject instructions into other projects. Copy or import them once per machine:

```
# Claude Code: import into your user-level CLAUDE.md
echo '@/path/to/sidstack/AGENTS.md' >> ~/.claude/CLAUDE.md
# Codex
cp /path/to/sidstack/AGENTS.md ~/.codex/AGENTS.md
```

**Hermes Agent**: point Hermes at the `skills/` folder; it already walks the `category/skill/SKILL.md` layout. No copy, no symlink; `git pull` is the update.

```
hermes config set skills.external_dirs '["/path/to/sidstack/skills"]'
hermes skills list        # source = external
```

If a skill with the same name already exists in `~/.hermes/skills/`, the local copy wins and the sidstack one is logged as shadowed. Delete the local copy to use the repo version. For the global rules, Hermes reads `AGENTS.md` only from the current directory; put the standing rules in `~/.hermes/SOUL.md` or keep them in `~/.claude/CLAUDE.md` for Claude Code.

**Codex / anything else that reads `SKILL.md`**: symlink or copy `skills/*/*` into the agent's skills directory (or point it at `skills/` if it walks folders). Nothing in `skills/` depends on a platform.

## Layout

```
AGENTS.md               global rules: responses, think before coding, simplicity, surgical changes, verify
.claude/CLAUDE.md       imports AGENTS.md (one source; a root CLAUDE.md fails plugin validation)
skills/                 one folder per skill, grouped by category
  writing/              drafting, proofreading, replies, tickets
  thinking/             grilling, sparring, diagrams in chat, knowledge share, flashcards
  visuals/              HTML pages, slide decks, infographics; one shared design system
  principles/           one principle per folder, one rule each
docs/PHILOSOPHY.md      index of principles + how to add one
hooks/                  dangerous-command guard (PreToolUse on Bash) + denylist + tests
.claude-plugin/         Claude Code manifest + single-plugin marketplace
scripts/validate.sh     structural checks (frontmatter, names, version drift, hook regexes)
.github/workflows/      runs the checks, guard tests, shellcheck, `claude plugin validate --strict`
```

Each category folder is listed in `plugin.json` under `skills` (an array of directories). Claude Code only loads what is listed, so `scripts/validate.sh` fails when a category is missing from the manifest. Skill names are global in the plugin namespace (`/sidstack:proofreading`, no category in the name), so two categories cannot share a name; the validator checks that too.

## Skills

**Writing and communication**

| skill | use it when |
|---|---|
| `plain-writing` | the general writing standard: short, direct, plain English, no filler, no invented facts. |
| `proofreading` | proofread, "rewrite in my tone", "improve this", or draft a workplace message or slide script for me. Smallest change that fixes it. |
| `reply-to-thread` | I paste a thread or comment: what are they saying, what do they want from me, my position, then a reply in my voice. |
| `ticket-writing` | write, improve, simplify, or split a ticket or issue for any tracker. No names, no invented facts, done-when checks. |
| `status-update` | share a status update or proposal in a meeting: What / So What / Now What to report, PREP when I need to win the point. Under a minute, out loud. |
| `bro` | the last message was jargon; restate it like one human talking to another. |

**Thinking and teaching**

| skill | use it when |
|---|---|
| `grill-me` | I have a plan or design and want it stress-tested one question at a time before building. |
| `show-me` | I would understand the topic faster as a diagram, call tree, diff, or one HTML page than as prose. |
| `eng-knowledge-share` | turn a brainstormed topic into one visual HTML explainer page plus a short team post. Manual, `/sidstack:eng-knowledge-share <notes.md>`. |
| `sparring-partner` | `/spar`: I must state my position first, then it attacks it hard before giving its own view. For judgment calls, not lookups. |
| `tarantino-method` | monthly night review: I dump what stresses or blocks me plus my own fix, it returns a three-column table with a direct verdict and checkable actions, and checks last month's actions first. |
| `anki` | turn source material into Anki cloze cards (Wozniak's 20 rules), or `/curate` an existing deck down 40-60%. Outputs a pipe-separated `.txt`. |

**Visuals** (one design system across all three: warm paper, five accents rotated per section, system fonts, drawn SVG figures, auto dark mode, no external requests, no emoji)

| skill | use it when |
|---|---|
| `explainer-page` | one concept, system, comparison, process, or recap as a multi-section HTML page with drawn figures. |
| `slide-deck` | a presentation as a self-contained HTML deck: keyboard/touch nav, speaker notes, print to PDF, under 15 slides. |
| `analogy-infographic` | one graphic that explains one concept through a real-world analogy, on a fixed-size artboard ready to screenshot. |

**Principles**

| skill | rule |
|---|---|
| `principle-verify-before-claiming` | Check the real artifact after the last change before saying done, fixed, passing, or merged. If you did not check, say so. |

Full index and reasoning: [docs/PHILOSOPHY.md](docs/PHILOSOPHY.md).

Nothing in this repo is specific to an employer, a client, or a project; those skills stay in their own repos. Skills adapted from someone else's work say so in an `## Origin` section at the bottom of the file, with the source and what changed.

## Hooks

`hooks/deny-dangerous.sh` runs before every shell command the agent executes (Claude Code `PreToolUse`, matcher `Bash`) and blocks anything matching `hooks/dangerous-patterns.txt`: `rm -rf` of `/` or home, `sudo rm`, raw disk writes, `curl | sh`, `git push --force`, branch deletes, history pruning, `gh ... delete`, making a repo public, and any read of a password manager (`op`, `bw`, `pass`, `lpass`, keychain dumps, secret-key exports). Blocked commands return exit 2 with the matched pattern, and the agent is told not to retry.

The hook is installed automatically with the plugin. It fails open: no `jq` or no patterns file means allow, so a broken hook never freezes every shell call.

Other agents that pass hook JSON on stdin and honor exit 2 (Codex) can point at the same script:

```json
{ "hooks": { "PreToolUse": [ { "matcher": "Bash", "hooks": [ { "type": "command", "command": "/path/to/sidstack/hooks/deny-dangerous.sh" } ] } ] } }
```

Every pattern has a case in `hooks/test-guard.sh` (151 asserts, runs in CI). To add a pattern: add the block case and a nearby allow case to the test first, then the regex. Override the list with `SIDSTACK_DANGEROUS_PATTERNS=/path/to/file`.

## Adding a skill

1. `mkdir skills/<category>/<name>` and write `SKILL.md` with `name: <name>` and a `description` that states the trigger in the words I would actually say. The description is the only thing loaded until the skill fires.
2. Procedure first, in execution order. One clause of why per rule. Say what the skill must not invent. End with the gate that means done.
3. If it is adapted from elsewhere, add an `## Origin` section: source link, author, license, what changed.
4. Add it to the right table above. New category: add `"./skills/<category>/"` to `plugin.json` `skills`.
5. Bump `version` in both manifests under `.claude-plugin/` (`scripts/validate.sh` checks they agree). Installed copies only update when the version changes.
6. `scripts/validate.sh && claude plugin validate . --strict`.

## License

MIT
