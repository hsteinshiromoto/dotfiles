---
description: Review an existing merge request against its target branch
agent: build
---

# Review Pull/Merge Request

Do a review for the existing merge request. Review committed changes on the current branch against the target branch.

## Instructions

### Setup

- Confirm which branch is being merged into which branch.
- Determine target branch by checking where the feature branch diverged.
- Use `git diff <target-branch>..HEAD` (exclude unstaged/staged local-only changes).
- Read all changed files fully, not only diff hunks.
- Use `code-reviewer` and `explain-code` workflows.
- Use Jira MCP to verify alignment with ticket requirements inferred from source branch.

### Structured Review

Produce a structured review in conversation first. For each issue found:

#### Severity Prefixes

- MUST — correctness/security/production break; blocks merge.
- #TechnicalDebt — quality/maintenance concern.
- QUESTION — unclear intent; may block depending on answer.
- NIT — style/naming/minor cleanup.
- PRAISE — something done well.

For each issue, reference file and line, and suggest a fix with code snippets.

#### Checklist

Check for:
- Bugs and edge cases
- Security issues (SQL injection, hardcoded secrets, command injection)
- Missing error handling (for example, missing directory creation, unhandled `None`)
- Missing docstrings (per project standards)
- Test coverage gaps
- Performance issues (N+1 queries, unnecessary loops)
- Unused imports, dead code, unused CLI args
- Dependency hygiene (unused packages still declared)
- Config consistency (duplicate or dead config sections)
- Alignment with Jira card description and acceptance criteria

### Interactive Walkthrough

- Walk through each MUST item interactively: explain the issue, show code, discuss fix.
- Batch #TechnicalDebt / QUESTION / NIT / PRAISE together.

## GitLab Inline Comments

When user is ready, generate copy-pasteable GitLab inline comments.
Tell user exactly which file and lines to highlight for each comment.

### Comment Structure

Each comment should include:
1. Severity prefix
2. Short heading
3. Problem explanation in plain language
4. Current code with file/line refs
5. Suggested fix (before/after; multi-step if needed)
6. Context for why fix works or what needs clarification

### Formatting Rules

- Use 4-space indented code blocks instead of fenced code blocks.
- Use tables for side-by-side comparisons when helpful.
- Keep each comment self-contained.

### GitLab Review Workflow

- Use "Start a review" to batch comments.
- After adding all inline comments, click "Submit review".
- Set status to "Request changes" when MUST items exist.
- Add a concise summary in review submission.
