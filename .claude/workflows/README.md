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

## transcripts-to-notes

This workflow turns the transcripts that `media-ingest` leaves in `Transcripts/` into notes. It decides for each transcript whether it is a recipe, a zettel, or neither. It runs five phases: Classify, Recipes, Zettels, Link, and Cleanup.

Request the workflow in a Claude Code session. For example: "turn the new transcripts into notes". The session then calls `Workflow({name: "transcripts-to-notes", args: {}})`.

The first run only classifies. It writes nothing and returns the status `needs_approval` with a table. Each row holds the transcript, the kind, a title, the reason, the text quality, and any duplicate. Show the table to the human. Then run again with `apply: true`.

| Argument | Meaning |
|---|---|
| `apply` | Required to write any note. Without it the run stops after the table. |
| `only`, `skip` | Lists of transcript file names. They narrow the set. |
| `deleteSources` | Delete the processed transcripts and videos once the notes exist and every link resolves. |
| `transcriptsDir`, `recipesDir`, `vaultDir` | Override the defaults: `~/Projects/media-ingest/Transcripts`, `~/Projects/recipes`, `~/zettelkasten`. |

### What each kind becomes

| Kind | Test | Result |
|---|---|---|
| recipe | The speaker makes food or a drink and gives ingredients or steps | A note in the recipes repo, built from `_meta_/_templates_/Recipe.md`. The video is copied to `_attachments_/` and embedded. |
| zettel | Any other transcript with a usable idea, method, or claim | A Fleeting note in `zettels/Fleeting`, named `<title> - <nanoid>.md`, built from `zettels/_meta_/templates/Note.md`. |
| skip | No speech, a joke, a title with no method | Nothing. The files stay. |

A household mix such as a stain remover is a zettel, not a recipe. A transcript that repeats another one adds no note. Its sources are deleted with the original's.

### Rules the phases follow

- The workflow fixes the nanoid and uuid of each zettel before any agent runs. This lets every zettel link to every other one.
- A recipe never states a quantity or a temperature that the speaker did not give. The note names the gap.
- A speech-to-text loop (one phrase repeated many times) counts as lost text. The note says which steps are missing.
- A zettel holds one concept. Other concepts go in `extraConcepts` in the result.
- The Link phase appends one `Related:` line to each existing note that a new zettel points to. It then checks every wikilink in the new notes. Cleanup is skipped when a broken link remains.
- Notes and the result never cite the transcript path, because Cleanup may delete it.

### What it writes

1. Recipe notes in the root of the recipes repo, and video copies in its `_attachments_/`.
2. Zettels in `zettels/Fleeting`, and one `Related:` line in each linked existing note.
3. With `deleteSources`: the processed transcripts and videos in `media-ingest`.

It never stages, commits, or pushes. It never deletes the video copies in the recipes repo or the stub notes in the `media-ingest` root. Commit each repo yourself after you review the notes. Videos in the recipes repo go through Git LFS, so commit its `.gitattributes` first.
