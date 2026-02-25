---
description: "Review Pull/Merge Request"
argument-hint: "create|update|status|comment|search|view [args]"
disable-model-invocation: false
---

# Review Pull/Merge Request

Do a review for the existing merge request. Review the committed changes on the current branch against the target branch.

## Instructions

### Setup

- Always confirm which branch is being merged into which branch.
- Determine the target branch by checking what branch this feature branch was created from.
- Use `git diff <target-branch>.. HEAD` to get the diff — do NOT include unstaged or staged changes.
- Read all changed files fully, not just the diff hunks.
- Use the skills `/code_reviewer` and `/explain_code`.
- Use JIRA mcp to check the alignment with card requirements, infer the JIRA card id from the source branch.

### Structured Review

Produce a structured review in conversation first. For each issue found:

#### Severity Prefixes

- MUST — Breaks correctness, security, or will crash in production. Blocks merge.
- #TechnicalDebt — Quality/maintenance concern. Recommended but won't break things today.
- QUESTION — Unclear intent, needs author clarification. May block depending on answer.
- NIT — Style, naming, minor cleanup. Take or leave.
- PRAISE — Something done well.
For each issue, reference the file and line, and suggest a fix with code snippets.

#### Checklist

Check for:
- Bugs and edge cases
- Security issues (SQL injection, hardcoded secrets, command injection)
- Missing error handling (e.g. missing directory creation, unhandled None)
- Missing docstrings (per project standards)
- Test coverage gaps
- Performance issues (N+1 queries, unnecessary loops)
- Unused imports, dead code, unused CLI arguments
- Dependency hygiene (unused packages still in deps)
- Config consistency (duplicate config, dead config sections)
- If the implementation matches the JIRA card description, and the acceptance criteria (if applicable).

### Interactive Walkthrough

- Walk through each MUST fix interactively: explain the problem, show the code, discuss with the user.
- Batch #TechnicalDebt / QUESTION / NIT / PRAISE together since they are unlikely to go into the MR comments.

## GitLab Inline Comments

When the user is ready, generate copy-pasteable GitLab inline comments.
Tell the user exactly which file and lines to highlight for each comment.

### Comment Structure

Each comment must be easy for the colleague to understand at a glance:

- 1. Severity prefix: Start with bold prefix: **MUST FIX** —, **QUESTION** —, **#TechnicalDebt** —, **NIT** —
- 2. Heading: Short descriptive heading (e.g. ### SQL injection risk)
- 3. Problem: Explain what's wrong and why it matters, in plain language, before showing any code
- 4. Current code: Show the relevant code with file/line references
- 5. Suggested fix: Show the fix with clear before/after labels. If the fix spans multiple files, number each step (1. SQL file, 2. Python function, 3. caller)
- 6. Context — End with why this fix works, or what question needs answering

### Formatting Rules

- Use 4-space indented code blocks (not triple backticks) to avoid nested fence rendering issues in GitLab
- Use tables for side-by-side comparisons (e.g. LIKE pattern differences)
- Each comment must be self-contained — the reader should not need to look at other comments to understand one

### GitLab Review Workflow

Guide the user through the GitLab review process:

- Use "Start a review" (not "Add comment now") to batch all comments into one notification
- After adding all inline comments, click "Submit review" in the top right
- Set the status to "Request changes" if there are MUST fixes
- Add a summary in the review submission box (e.g. "2 must-fixes, 1 question, 1 should — see inline comments. Happy to approve once addressed.")
