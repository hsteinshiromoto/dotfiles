---
description: "Meeting Minutes Management"
argument-hint: "[transcript file, meeting note, or nothing]"
disable-model-invocation: false
---

# Meeting Minutes

Run the `summarize-meeting` workflow. It reads the meeting source, writes the
minutes into the Obsidian vault, and adds every action item to tuxedo.

## Run it

Call the workflow. Pass `$ARGUMENTS` as the input:

```
Workflow({name: "summarize-meeting", args: {input: "$ARGUMENTS"}})
```

Pass `args: {}` when `$ARGUMENTS` is empty.

The `input` field takes three forms:

| Form | What the workflow does |
|---|---|
| A path under `~/Notes/02_Calendar/Meeting_Notes` | Reads the stub note and merges the full minutes into it |
| Any other file path | Reads the file as a transcript and creates the note |
| The transcript text | Reads the text and creates the note |

Add more fields when the user gives them: `title`, `date`, `attendees`,
`chair`. These four win over the transcript. Add `dryRun: true` to print the
tuxedo commands and write no task.

## Handle the result

The workflow returns a status.

1. Status `ok`: report the note path, the number of tasks added, and the number
   skipped. Name each skipped task and its reason.
2. Status `needs_input`: the caller gave no input. The result holds
   `candidates`, the meetings on today's schedule. Ask the user which meeting to
   summarize. Run the workflow again with `input` set to the path of that
   meeting.
3. Status `read_failed`, `minutes_failed`, or `tasks_failed`: show the `error`
   field. Do not retry without a fix.

## What it writes

The workflow writes three places and nothing else:

- the meeting note under `~/Notes/02_Calendar/Meeting_Notes`
- one link line in today's daily note under `~/Notes/02_Calendar/Daily_Notes`
- new tasks in `~/Notes/todo.txt`, through `tuxedo add`

The workflow deletes no task and no line. It runs no git command.
