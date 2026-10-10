---
name: anki
description: Create and/or curate Anki cloze-deletion flashcards. Auto-detects intent from input. (1) If the user pastes raw source material (text, transcript, YouTube transcript, code, uploaded PDF or document) or asks to "make flashcards", "turn this into Anki", "create study cards", "help me memorize this", create cloze-deletion cards from scratch and curate them in the same pass. (2) If the user pastes an existing flashcard deck (pipe-separated cloze, basic front/back, Q/A pairs) or types `/curate`, "apply 80/20", "pareto these cards", "trim this deck", "prune this deck", curate only — do not regenerate. Output is always a `.txt` file ready for Anki import.
---

# Anki Flashcard Creator + Curator

One skill, two modes. Detect which one applies, then run.

## Mode detection

Look at the input and pick **one** mode:

- **CREATE mode** — input is raw source material (an article, transcript, PDF, code, notes, pasted text on a topic). The user wants flashcards generated from it.
- **CURATE mode** — input is an existing flashcard deck (lines with `{{c1::...}}` syntax, `Q:`/`A:` pairs, pipe-separated front/back rows, numbered Q/A lists), OR the user explicitly typed `/curate`, "apply 80/20", "trim this deck", or similar pruning language.

If genuinely ambiguous (e.g., a short text that could be either), ask once.

In CREATE mode, curation is **built into the generation pass** — there is no separate cleanup step. Generate fewer, better cards from the start.

---

## Core principles for cards (applies to both modes)

These rules trace back to Piotr Wozniak's *20 Rules of Formulating Knowledge*. Every card must follow them.

### 1. One atomic fact per card (minimum information principle)

The brain remembers small, simple things far better than long passages. If a card tests more than one thing, split it.

- ❌ "{{c1::Mitochondria}} are the powerhouse of the cell, found in {{c2::eukaryotes}}, and contain their own {{c3::DNA}}." — three facts revealing together.
- ✅ Three separate cards, one fact each.

### 2. Cloze the *meaningful* word, not filler

Hide the term, number, or concept that's actually worth recalling. Not random nouns, not generic verbs.

- ❌ "The {{c1::capital}} of France is Paris."
- ✅ "The capital of France is {{c1::Paris}}."

### 3. Provide enough context for exactly one correct answer

A cloze must be unambiguous given the surrounding text. If multiple answers fit, the card is broken — add a qualifier or rephrase.

- ❌ "{{c1::Java}} is a programming language." — could be Python, Go, anything.
- ✅ "{{c1::Java}} is the programming language that runs on the JVM and was created at Sun Microsystems in 1995."

### 4. Avoid interference between similar cards

Don't make cards so close in wording that they blur together during review. If two cards share a sentence structure with only the answer swapped, you'll mix them up.

- ❌ "X was founded in {{c1::1990}}." / "Y was founded in {{c1::1991}}."
- ✅ Add distinguishing context: who founded it, where, what was happening at the time.

### 5. Understand before you memorize

Cards are a review layer on top of comprehension, not a substitute for it. If the user doesn't understand the material, cards will feel arbitrary and won't stick. When source material is unclear, flag it rather than producing cards that test surface wording.

### 6. Rewrite in your own words

Copy-pasted sentences from the source tend to be vague and over-long. Rewording forces the idea to be understood and compressed. Always rephrase — never lift sentences verbatim from the input.

### 7. Use simple, everyday language

Every card must be understandable in **one read**. The user should not have to re-read it.

- Use plain words. Replace jargon when possible.
- Keep sentences short. One idea per sentence.
- Avoid filler words and long clauses.
- If a technical term is the thing being tested, keep it — but explain it simply in the surrounding sentence or in the back-extra column.

Examples:

- ❌ "The French Revolution commenced in {{c1::1789::year}} with the storming of the Bastille, an event that symbolized the collapse of royal authority."
- ✅ "The French Revolution began in {{c1::1789::year}} when people stormed the Bastille, a royal prison in Paris."

- ❌ "A Python {{c1::decorator}} is a higher-order function that accepts another function as an argument and extends its behavior without modifying its source."
- ✅ "A Python {{c1::decorator}} is a function that takes another function and adds new behavior to it, without changing the original."

### 8. Use hints to disambiguate

Anki supports `{{c1::answer::hint}}` syntax. Use it when the cloze would otherwise be ambiguous or when a memory nudge helps.

- `{{c1::1789::year}}`
- `{{c1::6.626 × 10⁻³⁴ J·s::symbol h}}`

### 9. Cloze overlapping for ordered sequences and lists

For ordered items (steps, stages, ranks, chronology), don't hide everything in one card. Make a set of cards where each one tests a single item while the rest stay visible as scaffolding.

Example: stages of mitosis (Prophase → Metaphase → Anaphase → Telophase) becomes four cards:

- "Mitosis stages: {{c1::Prophase}}, Metaphase, Anaphase, Telophase."
- "Mitosis stages: Prophase, {{c1::Metaphase}}, Anaphase, Telophase."
- "Mitosis stages: Prophase, Metaphase, {{c1::Anaphase}}, Telophase."
- "Mitosis stages: Prophase, Metaphase, Anaphase, {{c1::Telophase}}."

This beats one giant card with all four hidden at once.

---

## CREATE mode

### Step 1: Read the input

The skill accepts multiple input types:

1. **Pasted text / transcript** — use directly.
2. **Uploaded PDF or document** — read it first using the appropriate method (`pdftotext` or `pymupdf` for PDFs, `python-docx` for `.docx`, the `view` tool for plain text). Confirm extraction succeeded before proceeding.
3. **YouTube transcript** — strip timestamp patterns (`0:00`, `1:23`) and speaker labels first.
4. **Code snippets** — focus on what the code demonstrates conceptually, not line-by-line syntax.

### Step 2: Classify the material

Read it through and pick a card focus:

| Material type | Card focus |
|---|---|
| Math / Physics / Engineering | Conceptual understanding, derivations, when and why formulas apply, variable meanings |
| Fact-heavy (history, biology, law) | Precise details, dates, definitions, chronological relationships, cause-effect |
| Programming / Technical | Concepts, syntax patterns, gotchas, when to use what, common pitfalls |
| Conceptual / Philosophy | Core ideas, distinctions between related concepts, key arguments, thinkers |
| Mixed | Blend per section |

### Step 3: Extract key points (with curation built in)

Walk the material in order of appearance. For each candidate fact, definition, or insight, ask before writing the card: **would forgetting this be a genuine loss?**

**Write a card if it tests:**

- A core mental model that frames how a topic works
- A decision framework ("when X, do Y")
- A non-obvious distinction between things easily confused
- A counterintuitive insight that goes against default intuition
- A foundational definition other concepts build on
- A practical default the user will reach for repeatedly

**Skip it if it's:**

- Trivia, one-off facts, exact numbers that can be looked up in 5 seconds
- Command syntax, shortcuts, flag names — reference material, not memory targets
- Obvious or filler facts the user already knows
- A list of items that doesn't encode a relationship (lookup table, not knowledge)
- Already covered by a card you've written — fold the secondary fact into that card's back-extra column instead

Favor quality over quantity. A lean deck the user reviews beats a bloated one they abandon.

### Step 4: Convert to cloze deletions

Apply the **9 core principles** above. In short:

- Hide the key piece of information inside `{{c1::answer}}` or `{{c1::answer::hint}}`.
- One atomic fact per cloze. Prefer separate cards over multi-cloze. Use `c2`, `c3` on the same card only for **cloze overlapping** on an ordered sequence (principle 9).
- Cloze the meaningful word, not filler.
- Rewrite the source in your own words.

**Quality checklist — every card must pass all of these:**

- ☐ Tests a single atomic fact (principle 1)
- ☐ Cloze hides a meaningful word, not filler (principle 2)
- ☐ Has exactly one correct answer given the context (principle 3)
- ☐ Won't be confused with a similar card in the same deck (principle 4)
- ☐ Rewritten in plain language, not copy-pasted (principles 6, 7)
- ☐ Understandable on a single read
- ☐ Will still make sense to the user 6 months from now

### Step 5: Tag

Add 1–3 tags per card. Use `::` for hierarchical tags (Anki convention).

Examples: `physics::quantum`, `history::french-revolution`, `programming::python::decorators`

### Step 6: Write the file

**Format:** A `.txt` file with three pipe-separated columns:

```
Cloze text | Back extra | Tags
```

**Rules:**

- No header row.
- One card per line.
- Column 1: the cloze sentence with `{{c1::...}}` syntax, in simple language.
- Column 2: brief context, mnemonic, formula reference, or "why this matters" note.
- Column 3: space-separated tags.
- Use ` | ` (space-pipe-space) as the delimiter.
- Maintain original order of appearance.
- Do not wrap content in code fences.

**Example output:**

```
The French Revolution began in {{c1::1789::year}} when people stormed the Bastille, a royal prison in Paris. | The fall of the Bastille marked the start of the revolution. It became a symbol of the people pushing back against the king. | history::french-revolution
In quantum physics, {{c1::Planck's constant}} (h) has a value of about 6.626 × 10⁻³⁴ J·s. | It links the energy of a photon to its frequency using E = hf. It is the base unit of all quantum effects. | physics::quantum::constants
A Python {{c1::decorator}} is a function that takes another function and adds new behavior to it, without changing the original. | Common ones are @property, @staticmethod, and @classmethod. You write them with the @ symbol above a function. | programming::python::decorators
```

Save next to the source material (or in the current directory) with a topic-based name (e.g., `anki-quantum-mechanics.txt`). Then give me the path.

---

## CURATE mode

### Step 1: Detect input format

Match the deck to one of these and **preserve it in the output**:

- **Anki cloze (pipe-separated)**: `Cloze text with {{c1::answer}} | Back extra | tags`
- **Anki basic (pipe-separated)**: `Front | Back | tags`
- **Q/A pairs**: `Q: ...` / `A: ...` blocks, or numbered Q/A lists
- **Other**: plain bullets, table rows

Do not convert formats. Pipe stays pipe. Q/A stays Q/A.

### Step 2: Score each card

Tag each card mentally as **KEEP**, **CUT**, or **MERGE**.

**KEEP** if the card tests:

- A core mental model
- A decision framework ("when X, do Y; when Z, do W")
- A non-obvious distinction between things easily confused
- A counterintuitive insight
- A foundational definition other concepts build on
- A practical default the user will reach for repeatedly

**CUT** if the card tests:

- Trivia, one-off facts, exact numbers — lookup-able in seconds
- Command syntax, shortcuts, flag names — reference material
- Information already covered by another card (keep the better-worded one)
- Filler or obvious facts the user already knows
- Wording-test cards (cloze hides a generic word any reader could guess from context)
- Niche features unlikely to be used often
- Lists of items that don't encode a relationship
- Compound cards testing multiple facts at once (flag as "split candidate" in summary instead of cutting outright)
- Cards that interfere with each other — same sentence structure, different answers, no distinguishing context (principle 4)

**MERGE** if:

- Two cards test closely related facets of the same idea
- One card defines a primitive and another describes one specific behavior of that primitive
- Several cards each carry one trait of the same concept

When merging, fold the secondary fact into the **back-extra column** (or the answer-side context for non-cloze formats). Keep the front/cloze focused on the single most important hook.

### Step 3: Curate

Walk through the deck once. Apply the rules above.

**Target reduction: roughly 40–60% of original cards removed.** If the deck is already tight, cut less. If it's bloated, cut more. Don't force a fixed ratio.

**Preserve original order** of surviving cards. Don't reshuffle.

**Do not rewrite kept cards** unless a merge requires it. The user wrote them a certain way — respect that.

### Step 4: Write the curated deck

Save next to the original deck with a descriptive name (e.g., `anki-<topic>-curated.txt`). Match the original format exactly:

- Same delimiter (` | ` with spaces for Anki pipe format)
- Same column order
- No header row unless the original had one
- No code-block fences in the file

Give me the path.

### Step 5: Summarize the cuts

After writing the file, give a tight summary in chat:

- **Original count → curated count** (e.g., "25 → 14 cards")
- **What was kept** — one sentence on the categories that survived
- **What was cut and why** — group cuts by reason ("4 command-lookup cards", "3 redundant cards folded into others", "2 trivia cards")

No preamble, no padding. Bullets only if they genuinely help.

### Curation examples

**Cutting a command card:**

❌ Original: `The {{c1::/compact}} command summarizes the conversation so you can keep going without losing your place. | /clear wipes everything. /rewind undoes to a prior turn. | claude-code::commands`

Cut reason: command-syntax trivia. Easy to look up. Not a memory target.

**Merging two related cards:**

❌ Original A: `A {{c1::Subagent}} is a separate Claude instance with its own context window. It does work and returns only a short summary. | ... | claude-code::primitives::subagents`

❌ Original B: `The killer feature of subagents is {{c1::context isolation}}. | Use them when a task would otherwise consume a ton of context... | claude-code::primitives::subagents`

✅ Merged: `A {{c1::Subagent}} is a separate Claude instance with its own context window. It does work and returns only a short summary to the main agent. | The killer feature is context isolation. The main session never sees the subagent's full scratch paper. Use subagents for large codebase searches, multi-file refactor exploration, or parallel investigations. | claude-code::primitives::subagents`

**Keeping a synthesis card:**

✅ Keep: `The Claude Code primitive decision tree: repeatable procedure → {{c1::Skill}}; forbidden action → {{c2::Hook}}; new external system → {{c3::MCP}}; context-heavy task → {{c4::Subagent}}.`

This is exactly the kind of card to keep — it encodes a decision framework the user will reach for in real situations.

---

## What this skill does NOT do

- It does not change the file format in CURATE mode. Pipe stays pipe. Q/A stays Q/A.
- It does not rewrite cards for clarity in CURATE mode. If wording is poor, flag it in the summary but leave it alone unless merging requires a rewrite.
