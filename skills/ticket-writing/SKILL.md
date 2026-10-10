---
name: ticket-writing
description: Use when I ask to write, improve, simplify, or split a ticket or issue: "improve this title/description", "remove the name", "create sub-tickets", "make a parent ticket", "write a ticket for this". Works for any tracker (Jira, Backlog, GitHub Issues, Linear).
---

# Ticket writing

A ticket is read by someone who was not in the conversation, often weeks later. It states the problem, the goal, the scope, and what done looks like, with nothing that only makes sense to the people who were there.

## Procedure

1. **Collect the facts from the source.** Read the thread, comment, screenshot, or notes I gave. List: the problem or request, why it matters, who is affected, constraints already decided, anything explicitly out of scope. If a fact is missing, keep it missing; a ticket with a visible gap gets fixed, an invented fact ships.
2. **Write the title.** One line, under ~70 characters, stating the outcome or the defect, not the activity. "Failed uploads leave orphaned videos" beats "Investigate upload issue". Keep the team's prefix convention (`[Bug]`, `[Parent]`, component tag) if the tracker uses one.
3. **Write the description** in this shape, dropping any section that would be empty:

   ```markdown
   ## Background
   2-4 sentences: what is happening today and why it is a problem. Link the source thread or ticket.

   ## Goal
   One sentence: the state we want after this ticket is done.

   ## Scope
   - In: ...
   - Out: ...

   ## Tasks (if known)
   1. ...

   ## Done when
   - Observable checks, not activities. "Upload failures leave no orphaned asset within 5 minutes", not "fix the cleanup".

   ## Notes
   Constraints, decisions already made, open questions marked as questions.
   ```

4. **Remove people.** No personal names in title or description; refer to roles ("the reviewer", "the AI team") or link the comment instead. Names date the ticket and turn a work item into a conversation log.
5. **Cut filler.** No "we need to", "it would be nice", "as discussed", or restating the title in the first line. Each sentence carries a fact or a decision.
6. **Splitting.** When asked for sub-tickets or a parent: the parent holds Background, Goal, and the list of children; each child gets its own Goal and Done-when and links the parent. One deliverable per child. Do not create a child for work that is not yet decided; list it under Notes in the parent as an open question.
7. **Improving an existing ticket.** Keep the tracker's existing key, labels, and links. Change the smallest amount that makes the title and description accurate; list what you changed and why when returning it.

## Rules

- Plain English, short sentences, no jargon the team did not already use.
- Facts over adjectives. "Misleading" becomes what is wrong and what it should say instead.
- Ticket keys as plain text; links on their own line.
- Do not state priority, estimate, assignee, or due date unless I gave them. Leave the field blank or write `(not set)`.

## Done when

A teammate who was not in the thread can read the title and know what the ticket is about, read Done-when and know how to verify it, and finds no name, no invented fact, and no sentence that only makes sense to the people who were in the room.
