---
description: Manage merge requests (create|review|update)
agent: build
---

# Manage Pull/Merge Requests

Parse `$ARGUMENTS` to determine which operation to run. The first word is the action.

## Defaults

- **Git server:** GitLab
- **CLI:** `glab`

## Operations

### create [pull-request]

Create a new merge request.

1. Ask user to select source branch.
2. Ask user to select destination branch.
3. Create merge request in GitLab with `glab`.
4. Use commit history to generate MR summary with sections below.

**Summary**

Description: One-line explanation of the main changes.

Jira Link: `https://akordi.atlassian.net/browse/<jira_card_id>` inferred from source branch.

Changes: Bullet points in broad strokes.

Validation: Test results, output parity, and relevant checks.

**Testing**

- Unit tests pass locally
- Output parity verified against baseline

**Database Changes**

- If applicable, else `N/A`

**Deployment Notes**

- Any env/dependency requirements
- Summarize impacts from `.nix`, `Dockerfile`, `Makefile`, `Justfile`

**Checklist**

- Use code review and MR review workflows before finalizing

### review [pull-request]

Run the MR review workflow from `/mr_review`.

### update [pull-request] [link]

Create an updated summary of changes since previous MR description.
