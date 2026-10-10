# sidstack

My personal agent stack: the skills, workflows, and principles I want every coding agent to follow when it works with me.

The content is plain `SKILL.md` folders (the Agent Skills format). Claude Code, Cursor, Codex, and Hermes all read it. Platform manifests are thin pointers at the one `skills/` directory, so switching agents means adding a small manifest, not rewriting anything.

## Install

**Claude Code**

```
/plugin marketplace add csarigumba/sidstack
/plugin install sidstack@sidstack
```

Skills show up namespaced: `/sidstack:plain-writing`.

**Cursor**: `.cursor-plugin/plugin.json` points at the same `skills/` directory. Add this repo as a plugin source.

**Codex / Hermes / anything else that reads `SKILL.md`**: symlink or copy `skills/*` into the agent's skills directory. Nothing in `skills/` depends on a platform.

## Layout

```
skills/                 the only part that matters; one folder per skill
  plain-writing/        write replies, drafts, and docs in my voice
  principle-*/          one principle per folder, one rule each
docs/PHILOSOPHY.md      how I work + index of principles
.claude-plugin/         Claude Code manifest + single-plugin marketplace
.cursor-plugin/         Cursor manifest
scripts/validate.sh     structural checks (frontmatter, names, version drift)
.github/workflows/      runs the checks + `claude plugin validate --strict`
```

Naming: flat `skills/` with prefixes. `principle-*` for principles, `workflow-*` for multi-step playbooks, no prefix for ordinary skills.

## Skills

| skill | use it when |
|---|---|
| `plain-writing` | drafting, rewriting, or proofreading anything in my voice: short, direct, plain English, no filler, no invented facts. |

## Principles

| principle | rule |
|---|---|
| `principle-verify-before-claiming` | Check the real artifact after the last change before saying done, fixed, passing, or merged. If you did not check, say so. |

Full list and the reasoning behind them: [docs/PHILOSOPHY.md](docs/PHILOSOPHY.md).

## Adding a skill

1. `mkdir skills/<name>` and write `SKILL.md` with `name: <name>` and a `description` that states the trigger in the words I would actually say. The description is the only thing loaded until the skill fires.
2. Procedure first, in execution order. One clause of why per rule. Say what the skill must not invent. End with the gate that means done.
3. Bump `version` in all three manifests (`scripts/validate.sh` checks they agree). Installed copies only update when the version changes.
4. `scripts/validate.sh && claude plugin validate . --strict`.

## Credits

Structure borrowed from [pstack](https://github.com/cursor/plugins/tree/main/pstack) by poteto. Content is mine.

## License

MIT
