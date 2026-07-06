---
description: Manage Jira tickets (create|update|status|comment|search|view)
agent: build
---

# Jira Ticket Manager

Parse `$ARGUMENTS` to determine which operation to run. The first word is the action.

## Defaults

- **Project key:** `AS`
- **Default assignee:** `humberto.shiromoto@akordi.com`
- **Default issue type:** `Task`

Use available Jira/Atlassian MCP tools for all ticket operations.

## Operations

### create [title]

Create a new Jira story.

1. If only title is provided, ask for description. Priority and issue type are optional (default: Medium, Task).
2. Create issue with project key `AS` and assignee `humberto.shiromoto@akordi.com`.
3. Return created ticket key and URL.

Example: `/jira create Fix embedding dimension mismatch in similarity scoring`

### update [ticket-key] [changes]

Update an existing ticket's fields.

1. Fetch current issue to show current values.
2. Parse requested changes (title, description, priority, labels, assignee).
3. Apply changes.
4. Show before/after summary of changed fields.

Example: `/jira update AS-1666 description "Rewrite all test files to use pytest fixtures"`

### status [ticket-key] [new-status]

Transition a ticket to a new status.

1. Get available transitions.
2. Match requested status with fuzzy matching.
3. If no match, show available statuses and ask user to pick one.
4. Execute transition.
5. Confirm new status.

Example: `/jira status AS-1666 "In Progress"`

### comment [ticket-key] [text]

Add a comment to a ticket.

1. Resolve ticket key:
   - If first token matches `[A-Z]{2,3}-\d{2,5}`, use it.
   - Otherwise infer key from current branch (`feature/<card_id>`, `bugfix/<card_id>`, `hotfix/<card_id>`, `release/<card_id>`).
   - If inference fails, ask user for ticket key.
2. Resolve comment text:
   - If text is provided, use it.
   - Otherwise auto-generate from commits since latest ticket comment (or all branch commits when no prior comments).
3. Add the comment.
4. Confirm success and show a preview.

Examples:
- `/jira comment AS-1666 SDK migration complete, all tests passing`
- `/jira comment SDK migration complete, all tests passing`
- `/jira comment AS-1666`
- `/jira comment`

### search [query]

Search for tickets.

1. If query looks like JQL, use directly.
2. Otherwise convert natural language to JQL.
3. Run search (limit 15).
4. Display as table: Key | Summary | Status | Assignee | Updated.

Example: `/jira search my open tickets`

### view [ticket-key]

Show full details of a ticket.

1. Fetch issue including description.
2. Display key fields:
   - Key and Summary
   - Status and Priority
   - Assignee and Reporter
   - Description (truncate if very long)
   - Created and Updated dates

Example: `/jira view AS-1666`

## Argument Parsing

- First word = operation (`create`, `update`, `status`, `comment`, `search`, `view`)
- If operation is not recognized, show help summary of available operations
- Ticket keys follow `[A-Z]{2,3}-\d{2,5}`
