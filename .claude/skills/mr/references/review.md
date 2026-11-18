# Review a merge/pull request

Loaded by `/mr review`. Review the commits on the current branch against the target branch.

## Setup

1. Confirm which branch merges into which. Determine the target from the branch the feature branch came from.
2. Get the diff: `git diff <target-branch>..HEAD`. Do not include staged or unstaged working-tree changes.
3. Read each changed file in full, not only the diff hunks. A hunk hides its callers.
4. Find the Jira card ID in the branch name. If there is one, fetch the card with `mcp__claude_ai_Atlassian_MCP__getJiraIssue` and check the change against its description and acceptance criteria.

## Criteria

Rate each as Pass, Warn or Fail. Report only what is not a Pass, plus anything worth praise.

| Criterion | What to check |
|---|---|
| Correctness | Bugs, off-by-one errors, unhandled edge cases, wrong branch conditions |
| Error handling | Missing directory creation, unhandled `None`, swallowed exceptions, bare `except` |
| Security | Command injection, SQL injection, hardcoded secrets, path traversal, unvalidated input at trust boundaries |
| Tests | New non-trivial logic without a test. Tests that assert nothing |
| Standards | The project's CLAUDE.md rules. Docstrings where the project requires them. Type hints on Python signatures |
| Minimality | Dead code, unused imports, unused CLI arguments, premature abstraction, packages left in dependencies |
| Performance | N+1 queries, work inside a loop that belongs outside it, repeated file reads |
| Scope | Changes the card did not ask for. Changes the card asked for that are missing |

## Severity prefixes

Tag every finding with one:

- **MUST** — breaks correctness or security, or will fail in production. Blocks the merge.
- **#TechnicalDebt** — a maintenance cost. Worth fixing, breaks nothing today.
- **QUESTION** — the intent is unclear. May block, depending on the answer.
- **NIT** — naming, style, minor cleanup. Take it or leave it.
- **PRAISE** — done well. Say so.

Each finding names the file and line, states the problem in plain language before any code, and shows a fix.

## Produce the review

Write the structured review in conversation first, grouped by severity, MUST first.

Then walk through each MUST interactively: explain the problem, show the code, discuss it. Batch #TechnicalDebt, QUESTION, NIT and PRAISE together, because they rarely become merge request comments.

## GitLab: inline comments

Only for GitLab hosts. Skip this whole section on GitHub.

When the user is ready, generate comments they can paste. Name the exact file and lines to highlight for each one.

Each comment holds, in order:

1. Bold severity prefix: `**MUST FIX** —`, `**QUESTION** —`, `**#TechnicalDebt** —`, `**NIT** —`
2. A short heading, for example `### SQL injection risk`
3. The problem in plain language, before any code
4. The current code, with file and line references
5. The fix, labelled before and after. Number each step when the fix spans several files
6. Why the fix works, or what question needs an answer

Formatting rules:

- Use 4-space indented code blocks, not triple backticks. Nested fences render badly in GitLab.
- Use a table for side-by-side comparisons.
- Each comment stands alone. The reader must not need another comment to understand this one.

Workflow to give the user:

1. Use "Start a review", not "Add comment now", so every comment arrives in one notification.
2. Add all inline comments, then click "Submit review".
3. Set the status to "Request changes" when there are MUST findings.
4. Write a summary in the submission box, for example: "2 must-fixes, 1 question, 1 nit — see inline comments. Happy to approve once addressed."

## GitHub

Stop after the structured review in conversation. Do not produce GitLab comment formatting, and do not describe the GitLab review workflow. If the user wants inline comments on GitHub, point them at `/code-review --comment`.
