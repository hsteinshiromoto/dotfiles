---
description: "Manage Jira tickets — create, update, change status, comment, search, view"
argument-hint: "create|update|status|comment|search|view [args]"
disable-model-invocation: false
---

# Jira Ticket Manager

Parse `$ARGUMENTS` to determine which operation to run. The first word is the action.

## Defaults

- **Project key:** `AS`
- **Default assignee:** `humberto.shiromoto@akordi.com`
- **Default issue type:** `Task`

## Operations

### create [title]

Create a new Jira story.

1. If only a title is provided, ask for a description. Priority and issue type are optional (default: Medium, Task).
2. Create the issue with `mcp__jira__jira_create_issue` using project key `AS`, assignee `humberto.shiromoto@akordi.com`.
3. Return the created ticket key and URL.

Example: `/jira create Fix embedding dimension mismatch in similarity scoring`

### update [ticket-key] [changes]

Update an existing ticket's fields.

1. Fetch the current issue with `mcp__jira__jira_get_issue` to show current values.
2. Parse what needs changing from the arguments (title, description, priority, labels, assignee).
3. Apply changes with `mcp__jira__jira_update_issue`.
4. Show a before/after summary of changed fields.

Example: `/jira update AS-1666 description "Rewrite all test files to use pytest fixtures"`

### status [ticket-key] [new-status]

Transition a ticket to a new status.

1. Get available transitions with `mcp__jira__jira_get_transitions`.
2. Match the requested status to an available transition (fuzzy match — "done", "Done", "DONE" should all work).
3. If no match, show available statuses and ask the user to pick one.
4. Execute the transition with `mcp__jira__jira_transition_issue`.
5. Confirm the new status.

Example: `/jira status AS-1666 "In Progress"`

### comment [ticket-key] [text]

Add a comment to a ticket. Both arguments are optional.

1. **Resolve ticket key.** Check whether the first word after `comment` matches the
   pattern `[A-Z]{2,3}-\d{2,5}`. If it does, use it as the ticket key and treat the rest as
   `[text]`. If it does **not** match `[A-Z]{2,3}-\d{2,5}`, treat the entire remainder as
   `[text]` and infer the ticket key from the current git branch: run
   `git branch --show-current` and parse the card ID from the second path component
   (branch follows git flow: `feature/<card_id>`, `bugfix/<card_id>`,
   `hotfix/<card_id>`, `release/<card_id>`). The card ID must match `[A-Z]{2,3}-\d{2,5}`; if it
   does not, ask the user for the ticket key.
2. **Resolve comment text.** If `[text]` is provided, use it directly. Otherwise
   auto-generate a comment:
   a. Fetch existing comments for the ticket to find the latest comment date.
   b. Run `git log --oneline --after="<latest_comment_date>"` on the current
      branch to collect commits made since that comment. If there are no prior
      comments, use all commits on the branch.
   c. Compose a Markdown comment summarising the commits (bulleted list of
      commit messages grouped by theme).
3. Add the comment with `mcp__jira__jira_add_comment`.
4. Confirm the comment was added and show a preview.

Examples:
- `/jira comment AS-1666 SDK migration complete, all tests passing`
- `/jira comment SDK migration complete, all tests passing` (infers ticket from branch)
- `/jira comment AS-1666` (auto-generates comment from recent commits)
- `/jira comment` (infers ticket from branch, auto-generates comment)

### search [query]

Search for tickets.

1. If the query looks like JQL (contains `=`, `AND`, `OR`, `ORDER BY`), use it directly.
2. Otherwise, convert natural language to JQL. Common patterns:
   - "my open tickets" → `assignee = "sean.nuttall@akordi.com" AND status != Done ORDER BY updated DESC`
   - "in progress" → `project = AS AND status = "In Progress" ORDER BY updated DESC`
   - A plain keyword → `project = AS AND text ~ "keyword" ORDER BY updated DESC`
3. Run with `mcp__jira__jira_search` (limit 15).
4. Display results as a table: Key | Summary | Status | Assignee | Updated.

Example: `/jira search my open tickets`

### view [ticket-key]

Show full details of a ticket.

1. Fetch with `mcp__jira__jira_get_issue` including description.
2. Display formatted:
   - **Key** and **Summary**
   - **Status** and **Priority**
   - **Assignee** and **Reporter**
   - **Description** (truncated if very long)
   - **Created** and **Updated** dates

Example: `/jira view AS-1666`

## Argument Parsing

The input is: `$ARGUMENTS`

- First word = operation (create, update, status, comment, search, view)
- If no operation is recognized, show a help summary of available operations
- Ticket keys match the pattern `[A-Z]{2,3}-\d{2,5}`

