# Workflows

This directory contains Claude Code Workflow scripts. Each script runs a team of subagents in named phases.

The dotfiles repo mirrors `$HOME`. Run `stow . --adopt` to link this directory to `~/.claude/workflows/`.

## debug-ticket

This workflow finds the root cause of a JIRA bug in its GitLab repository.

Request the workflow in a Claude Code session. For example: "run the debug-ticket workflow for PROJ-123".
The session then calls `Workflow({name: "debug-ticket", args: {ticket: "PROJ-123", repo: "group/project"}})`. The `repo` argument is optional.

The workflow reads the ticket to find the repository. If the result status is `needs_repo`, run the workflow again and set `args.repo`.

The workflow is read-only. It writes in two places only:

1. A shallow clone of the repository, in a scratch directory.
2. The report `reports/<TICKET>-root-cause.md`, in your current directory.

## summarize-meeting

This workflow turns a meeting into minutes in the Obsidian vault and tasks in
tuxedo. It runs three phases: Read, Minutes, and Tasks.

Request the workflow in a Claude Code session. For example: "summarize the
rollback meeting". The session then calls
`Workflow({name: "summarize-meeting", args: {input: "<path or text>"}})`.

The `input` argument is optional and takes three forms:

| Form | What the workflow does |
|---|---|
| A path under `~/Notes/02_Calendar/Meeting_Notes` | Merges the full minutes into that stub note |
| Any other file path | Reads the file as a transcript and creates the note |
| The transcript text | Reads the text and creates the note |

Without `input`, the workflow reads the schedule in today's daily note and
returns the status `needs_input` with the meetings it found. Ask the user which
meeting to use, then run the workflow again with `input` set.

Four more arguments override what the source says: `title`, `date`, `attendees`,
and `chair`. Set `dryRun: true` to print the tuxedo commands and write no task.

The workflow writes three places and nothing else:

1. The meeting note under `~/Notes/02_Calendar/Meeting_Notes`.
2. One link line under `## Schedule` in today's daily note.
3. New tasks in `~/Notes/todo.txt`, through `tuxedo add`.

It deletes no task and no line. It runs no git command.

### How the Tasks phase builds a task

Every action item becomes one line. The priority comes from the importance and
urgency of the item:

| importance | urgency | priority |
|---|---|---|
| H | H | (A) |
| H | M, L, or N | (B) |
| M, L, or N | H | (C) |
| M | M | (C) |
| anything else | | (D) |

The owner becomes the context: `@me`, `@team`, `@<FirstName>`, or
`@unassigned`. The project comes from a `tuxedo lsprj` name that matches the
topic. The phase builds a project name from the meeting title when no name
matches.

Each command pins the list with `TODO_DIR=$HOME/Notes`. Without it, tuxedo
writes `./todo.txt` in the current directory.

Each task carries an explicit `due:YYYY-MM-DD`. This matters. A task text with
no `due:` field makes tuxedo pull the date words out of the text. The text
"Prepare the Monday standup deck" becomes "Prepare the standup deck
due:2026-09-21". The phase reads every new task back with `tuxedo ls --json` and
repairs a damaged line with `tuxedo replace`.
