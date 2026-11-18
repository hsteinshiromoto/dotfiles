---
name: mr
description: "Manage Pull/Merge Requests — create, update, review, comment, search, view"
argument-hint: "create|update|review|comment|search|view [args]"
disable-model-invocation: false
---

# Merge/Pull Request Manager

Parse `$ARGUMENTS`. The first word is the action.

With no arguments, print this line and stop:

```text
Usage: /mr create|update|review|comment|search|view [args]
```

There are no aliases. `new`, `open` and `close` are not actions.

## Host detection

Do this once per invocation, before any operation. Never assume GitLab.

1. Read the remote: `git remote get-url origin`.
2. If the host part is not a known forge domain, it is an SSH alias. Resolve it:
   `awk 'tolower($1)=="host" {h=$2} tolower($1)=="hostname" && h=="<alias>" {print $2; exit}' ~/.ssh/config`
3. Map the resolved host to a CLI:

   | Host contains | CLI | Noun |
   |---|---|---|
   | `gitlab` | `glab` | merge request |
   | `github.com` | `gh` | pull request |

4. If neither matches, stop and report the resolved host. Do not guess.

Use the matching CLI for every command in this skill. Use the matching noun in everything you write for the user.

## Jira

The Jira project key is `AS`. Branch names on work repositories carry the card ID, for example `feature/AS-1666/fix-scoring`.

1. Search the branch name for `[A-Z]{2,}-[0-9]+`.
2. No match: there is no card. Skip every Jira step below and omit the Jira Link section from the body.
3. Match: fetch the card with `mcp__claude_ai_Atlassian_MCP__getJiraIssue`. Do not use `mcp__jira__*`; that server is not connected.
4. The fetch fails: say so in one line, then continue from the commit messages alone.

The card link format is `https://akordi.atlassian.net/browse/<card-id>`.

## Plan

Work planned with `~/.claude/templates/PLAN.md` carries change ids of the form `ChX.YY`, where `X` is the phase number and `YY` is the change number inside it.

### Find the plan

1. Look in `.claude/plans/*.md`.
2. None found: there is no plan. Skip every plan step and omit the Changes Implemented section from the body.
3. One found: use it.
4. Several found: use the most recently modified, and name which one you used in one line. Accept `--plan <path>` as an override.

### Find the plan on Confluence

The plan may also be published as a Confluence page. Look for its URL in this order and stop at the first hit:

1. The `--confluence <url>` argument, when the user passed one.
2. A `confluence_url` key in the plan file's frontmatter.
3. A Confluence search with `mcp__claude_ai_Atlassian_MCP__searchConfluence`, when the branch carries a Jira card ID. Search for the card ID. Accept a result only when the page title or body names that card ID; a near match on wording is not the plan.

No hit after all three: there is no Confluence page. Omit it from the body and say nothing about it.

### Decide which changes this branch implements

A change id belongs in the body when either test passes:

- The id appears in a commit message on the branch: `git log <destination>..HEAD --format='%s%n%b' | grep -oE 'Ch[0-9]+\.[0-9]+'`
- The plan row's **Files to be changed** intersects `git diff --name-only <destination>..HEAD`

Read the phase tables for the title, the requirements addressed and the criticality of each matched id.

Report every matched id. Then compare against the full set of ids in the plan and report the gap, so a half-finished phase is visible:

- A `Blocker` or `Required` id in a phase this branch touches, with no matching commit and no changed file, is listed as outstanding.
- An `Optional` id in that position is listed as outstanding too, but marked as owing nothing.

Do not infer that a change is done because its phase is done.

## create

Raise a new merge/pull request.

### 1. Pick the branches

Source is the current branch. Destination is the repository default branch, or `dev` when the repository uses `dev` as its integration branch (check `git branch -r` and the README).

Show both in one confirmation. Accept an override. Do not ask two separate questions.

Stop if the source branch has no commits the destination lacks: `git log <destination>..HEAD --oneline`.

### 2. Build the title

Read the commits: `git log <destination>..HEAD --format='%s%n%b'`.

Write one line that says what the branch does. Base it on the Jira card description when there is a card, and on the commit messages. It is a summary, not a copy of the last commit subject.

With a card: `AS-1666: <summary>`. Without a card: `<summary>`.

Do not put `Draft:` in the title. The draft state comes from the CLI flag.

### 3. Build the body

Look for a template the repository already ships:

- `.gitlab/merge_request_templates/*.md`
- `.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `docs/pull_request_template.md`

If one exists, fill that template and use nothing else from the fallback below. The repository's own template wins, with one exception: the change table and the **Breaking Changes** section are required on every merge request. Put the change table under the template's own summary heading, and append Breaking Changes at the end, unless the template already has a section that covers the same ground.

If none exists, use this body:

```markdown
## Summary

<one line: the main change this merge request introduces. When any change below is breaking, say so here>

Plan: `.claude/plans/<file>.md` · [Implementation plan](<confluence-url>)

| Change Id | Change Title | Criticality | Requirements | Breaking |
| --------- | ------------ | ----------- | ------------ | -------- |
| Ch1.01    | <title>      | Blocker     | FR1          | Yes — <what stops working> |
| Ch1.02    | <title>      | Required    | NF5          | No       |

Outstanding in the phases this branch touches:

- Ch1.03 (Required) — <title>
- Ch1.04 (Optional) — <title>, nothing owed

## Jira Link

<https://akordi.atlassian.net/browse/AS-1666>

## Changes

- <broad strokes, one bullet per area touched>

## Breaking Changes

**Verdict**: Yes | No

**What breaks**: <who or what stops working, and at which call site. Omit when the verdict is No>

**Migration**: <what a caller must do to keep working. Omit when the verdict is No>

**Rollback**: <reversible, or what cannot be undone>

## Validation

<what proves the change works: output parity, manual check, screenshots>

## Testing

<result of /sanity_check, verbatim, or "not run: reason">

## Database Changes

<migrations, schema edits, or N/A>

## Deployment Notes

<env vars, dependency changes, build steps. Read flake.nix, Dockerfile, Makefile, Justfile to find them, or N/A>
```

Omit the Jira Link section when the branch carries no card ID. When no plan file was found, drop the change table, the plan line and the outstanding list, and leave the Summary as its one line. Breaking Changes stays either way.

The plan line holds whichever of the two is available. With a local plan and no Confluence page, drop the `·` and the link. With a Confluence page and no local plan file, keep the line and the link, and drop the local path. Both missing: no plan line.

### 4. Assess breaking changes

This section is required. It is never omitted and never left blank.

Read the diff, not only the commit messages. A commit that says "refactor" still breaks callers when it renames an exported name.

A change is breaking when something that worked before the merge stops working after it, without the caller changing. Check for each of these:

| Area | What makes it breaking |
| --- | --- |
| Public API | A removed or renamed exported function, class or constant. A changed signature: a parameter added without a default, removed, renamed or re-ordered. A narrowed return type |
| HTTP surface | A removed or renamed route. A changed status code. A field removed from or renamed in a response. A request field that becomes mandatory |
| CLI | A removed or renamed command, subcommand or flag. A changed default that alters what a bare invocation does |
| Configuration | A renamed or removed key or environment variable. A key that becomes mandatory. A changed default value |
| Data | A migration that drops or renames a column or table, narrows a type, or adds a `NOT NULL` column with no default. A changed serialisation format |
| Dependencies | A major version bump of a dependency this code exposes to its own callers |
| Behaviour | The same input now produces a different output, and callers depend on the old one |

Then:

1. For each hit, find its call sites with `grep` across the repository before you call it breaking. A renamed private helper with every caller updated in the same merge request is not breaking.
2. When a plan was found, read the **Risk** field of each matched change. The plan states what the author expected to break. Say so when the diff disagrees with it.
3. Grade each change id separately. Assess the files that change id touches, not the whole diff, and put the result in the **Breaking** column of the Summary table: `No`, or `Yes — <what stops working>` in a few words. With no plan, there are no change ids and no column to fill.
4. Write the overall verdict. It is `Yes` when any change id is breaking, or when the diff breaks something no change id covers. `Yes` needs the call site that breaks and the migration a caller must make. `No` needs nothing beyond the verdict and the rollback line.
5. The rollback line says whether reverting the merge restores the previous state. A migration that drops data does not, and that must be stated.

When the overall verdict is `Yes`, say so in the Summary line too. A reviewer must not have to reach this section to learn it.

### 5. Fill the Testing section

The user's CLAUDE.md forbids running tests before you confirm the host OS suits the project's test environment. For example, NixOS tests cannot run from a macOS host.

1. Check that the host suits the project's tests.
2. It does: run `/sanity_check` and paste what it returns.
3. It does not, or the run fails: write `not run: <reason>`.

Never write that tests pass unless you saw them pass.

### 6. Show the commands, then stop

Print the rendered title and body, then the exact commands the user must approve:

- the branch publish command, `git`, with the `-u origin <source-branch>` upstream flag
- the merge request command for the detected host:

```bash
# GitLab
glab mr create --draft --source-branch <source> --target-branch <destination> \
  --assignee @me --title "<title>" --description "<body>"

# GitHub
gh pr create --draft --head <source> --base <destination> \
  --assignee @me --title "<title>" --body "<body>"
```

The merge request opens as a draft, assigned to the user. Set reviewers, labels or assignees only when the user passes them as arguments. Do not invent a reviewer or label policy.

Wait for approval. Run nothing until the user approves. Publishing a branch and opening a merge request are both outward-facing, and publishing a branch needs approval under the user's CLAUDE.md.

## update

Refresh the description of an existing merge request.

1. Find the open merge request for the current branch: `glab mr view` or `gh pr view`.
2. Read its current description.
3. Rebuild the body with the `create` rules above, from the commits now on the branch.
4. Show the old description and the new one side by side, and name what changed.
5. Wait for approval, then apply with `glab mr update --description` or `gh pr edit --body`.

Never overwrite without approval. A description edited by hand in the web interface cannot be recovered through the CLI.

## review

Read `references/review.md` and follow it. Do not load that file for any other action.

## comment

Thin wrapper. Add no formatting of your own.

```bash
glab mr note <id> --message "<text>"
gh pr comment <id> --body "<text>"
```

## search

Thin wrapper.

```bash
glab mr list <args>
gh pr list <args>
```

## view

Thin wrapper.

```bash
glab mr view <id>
gh pr view <id>
```
