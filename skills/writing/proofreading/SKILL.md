---
name: proofreading
description: Use when I ask to proofread, polish, "rewrite in my tone", "improve this", or draft a workplace message for me (chat reply, ticket comment, email, teammate reply, slide script). Smallest change that fixes it; keeps my voice.
---

# Proofreading and drafting in my voice

Three jobs: proofread my text, rewrite text "in my tone", and draft a new message I will send. All three return the text directly, with no preamble and no commentary unless I ask what changed.

## Procedure

1. **Name the job.** "Proofread" = smallest fix. "Rewrite in my tone" = same content, my phrasing. "Improve it" or "make it better" (often a raw transcript or dictation) = fuller rewrite that still sounds like me: fill the gaps I marked, cut restarts, then list what you wrote or changed. Draft = new message from my notes. The job decides how much you may touch; guessing a bigger job than I asked for is the most common failure.
2. **Keep what is mine.** Tone, wording, paragraph structure, and line breaks stay unless the job is "improve". Fix grammar quietly. Do not add headers, bullets, or line breaks that were not in the original. Do not change or shorten links.
3. **Apply the voice rules** below.
4. **Return the text only.** For "improve" and drafts, add a short list of what you added or changed after the text, so I can check it.

## Voice rules (all jobs)

- Polite and professional. Plain, simple words. No AI polish, praise, filler, or corporate phrasing.
- Commas or parentheses instead of em dashes.
- Active voice. Dictated input often slips into passive ("it will be synced once approved"); rewrite it active ("the job syncs it once the PR merges") and correct the fact while you are there.
- "Thanks" or "Thanks!" for casual and internal messages. "Thank you" for formal messages, instructions, or first contact with someone new.
- "!" only where real enthusiasm or emphasis fits.
- Bold only the key noun or product name. Ticket keys as plain text in parentheses. Prices and limits in inline code.
- Grammar correct but simple. Do not copy my small slips on purpose.
- A casual particle or rare emoji stays only if it was already in the original and the message is informal.

## Drafting a new message (my patterns)

- **Open with the context or the point.** "As discussed during our weekly meeting, ...", "I have checked the details.", "I would like to check if ...". When replying to someone's work, one short positive open: "Thank you for the detailed plan."
- **State my position in first person with soft hedges.** "I think ...", "I believe ...", "I would like to ...", "Moving forward, ...", "for now", "if we are aligned".
- **Give the reason plainly.** "As X becomes more frequent, it adds Y. In addition, Z." Tie it back to the goal when pushback is likely: "I believe this does not diminish our goal to ... while keeping ... in balance."
- **Say what I already did,** with the link on its own line: "I updated the wiki accordingly for your reference."
- **End with a clear ask on its own line.** "Please prioritize this over (TICKET-123).", "Should we need to extend it, please advise so we can ...", "Please confirm and close this ticket if there are no concerns."
- **Teammate drafts ask for their opinion, then give the next step.** "Please let me know your thoughts. If we are aligned, could you ...?"
- **Planning-stage replies to my team read as a senior reviewer:** the decision, one line of credit for what is good, the one rule that guides later changes, and the next steps. About 5-8 lines. Keep settings, evidence, and nits for the stage where they matter; keep the evidence ready in case of pushback.
- **Layout:** short lines, one or two sentences each, blank line between blocks. Short replies have no headers. Longer updates use `##` headers, bullets only for real lists.
- **Phrases I use:** "as of the moment", "for your reference", "accordingly", "Moving forward", "I have no further comments", "All noted and aligned".

## Technical root-cause comments (tickets)

- Shape: one-line urgency or context open, then `##` Root cause, Fix, Test results (table), Options (when I give them), a Question with the @mention, and "Thank you." on its own line.
- Label each claim by where it came from: "Based on our test, ..." for what we observed, and a primary vendor source (official technote or docs) with a short quote and the URL on its own line under "For your reference:". Use the vendor's own link, not only a secondary guide.
- A guess about who did what (e.g. which toolchain built a release) is not a fact. Write "we don't know X" and ask the owner.
- When I add my own decision and it has a logic gap, write it my way and flag the gap once after the text. Do not repeat the flag in later rounds unless I ask.
- State the root cause as the exact trigger condition, not the symptom ("apps built with toolchain N must ..." rather than "on OS N, apps must ..."); the loose version contradicts the line that says older builds still work. When I ask for a fact-check, check each sentence against the primary source and return a claim / verdict / source table plus corrected wording.
- Test-result tables: every label must match the evidence. Put a qualifier on the column it is true for, not the table title, and mark secondhand cells apart from tested ones.
- When I paste a newer draft from another agent and say "use this", merge its new facts into the last agreed version. Keep the fact-checked wording, sources, options, and ask already settled, because the pasted draft usually predates them. List what you kept after the text.
- Short summary version ("summary, bullets only"): bold-led bullets, **Cause:** one sentence, **Fix:** one line, **Our preference: Option N** with a one-line reason, the other option in one line, then the @mention ask as one sentence and "Thank you." No headers, tables, or links.
- Dictated input mis-hears words ("cost" for "cause"). Pick the reading that fits and add one line after the text saying which reading you used.

## Speaker scripts for slides

- Open with the slide's one key statement, usually its title in my words, then short proof. Do not walk every card or read numbers the audience can see. Say one strong proof number out loud.
- Assertive without hype. No "we noticed", no slogan lines. Plain facts.
- Sentences short enough to say in one breath. Drop words that are hard to stress aloud.
- Do not overstate evidence. Describe a survey by the question it asked, not by the conclusion I want. Keep caveats like "based on observations, formal metrics to follow".
- About 45-60 seconds per slide. One line per column or section, phrased as the advantage ("we build the right thing"), not the event ("AI makes mockups").

## Do not invent

A date, owner, number, link, or decision that was not in my input stays out. Leave a visible gap (`(date TBC)`, `(owner not agreed)`) rather than a plausible fill. I will not reread a field that looks filled in.

## Pitfalls

- Over-structuring: turning a 4-line comment into sections with headers and bullets. Match the length and shape of the original.
- Long paragraphs: mine are 1-3 short sentences.
- Em dashes.
- Doing "improve" when I asked "proofread".

## Done when

The text still reads as mine, every change is the smallest one that fixes a real problem, nothing in it is a fact I did not give, and the reply contains the text and nothing else (plus the change list when the job was "improve" or a draft).
