---
description: "Manage Pull/Merge Requests — create, update, review, comment, search, view"
argument-hint: "create|update|status|comment|search|view [args]"
disable-model-invocation: false
---

# Manage Pull/Merge Requests

Parse `$ARGUMENTS` to determine which operation to run. The first word is the action.

## Defaults

- **Git server**: gitlab
- **Interact with the git server**: Use gitlab cli (glab).

## Operations

### create [pull-request]

Create a new pull/merge request

1. Ask user to select the source branch from the repository.
2. Ask user to select the destination branch from the repository.
3. Create a pull/merge request in gitlab using gitlab cli (glab).
4. Use the following instruction to create a summary of the pull/merge request.

**Summary**

Description: An one-liner explaining the main changes introduced by this pull/merge request. Use the git commit messages to create this summary.

Jira Link: Inset link using the format `https://akordi.atlassian.net/browse/<jira_card_id>`. Infer the `<jira_card_id>` from the repository's source branch.

Changes: Bullet points, broad strokes.

Validation: Test results, output parity, etc.

**Testing**

- Unit tests pass locally
- Output parity verified against baseline

**Database Changes**

- If applicable, else add N/A

**Deployment Notes**

- Any env/dependency requirements
- Create a summary based on the `.nix`, `Dockerfile`, `Makefile`, `Justfile`.

**Checklist**

Use the `/code_reviewer` and `/mr_review` skills.

### review [pull-request]

Use the skill `/mr_review`

### update [pull-request] [link]

Create a summary of the updated changes.
