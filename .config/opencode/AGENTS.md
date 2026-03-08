# Global OpenCode Environment and Standards

If any instruction below conflicts with a local `AGENTS.md` or `CLAUDE.md`, use the local project instruction.

## Start Up

When you start a session, do the following:
- Read all git commits for the current branch.
- Read the latest note in `journal/`. If this folder does not exist, create it in the project root.
- Read `journal/summary.md`. If this file does not exist, create it.
- Use these pieces of information as long-term memory for the session.

## Agent Workflow

Use these subagents in this order:

1. Product Manager agent (`product_manager`): assess request complexity. If simple, skip to step 2. If complex, reformulate the request, ask up to 3 clarifying questions, and evaluate answers (PASS/NO PASS). At most 2 rounds of clarification before handing off.
2. Plan agent (`plan`): understand the request, analyze context, and propose an implementation plan. Show the plan and ask for approval before moving to implementation.
3. Plan evaluator agent (`plan_evaluator`): critique the proposed plan for feasibility, completeness, standards compliance, risk, and modularity. If verdict is NEEDS WORK, revise and re-evaluate.
4. Build agent (`build`): execute the approved plan. Ask for approval before modifying files.
5. Build evaluator agent (`build_evaluator`): critique implementation using the `code-reviewer` skill. If verdict is NEEDS WORK, address recommendations.
6. End-to-end evaluator agent (`e2e_evaluator`): run `sanity-check` and summarize plan, build, and test results, then assess if implementation addresses requirements.
7. If end-to-end verdict is PASS, ask whether to add code to git staging area.
8. Conclude by updating the journal using the `journal` skill.

Each of these agents should execute at most three tasks.

For each user permission request, offer only three choices:
1. Yes (Y)
2. No (N)
3. Something else (free text for a small adjustment, such as running a command with a different flag)

Use the `question` tool for explicit user-choice prompts.

## Do Not

Never do any of the following without human approval:
1. Modify any file.
2. Add files to git staging area or commit.
3. Run tests or build commands before confirming host OS compatibility with the test environment (for example, NixOS-only tests cannot run from macOS).

## Code Development Standards

- Prefer functional implementation.
- Prefer readable implementation.
- Prefer modularized code: each function should do one task.
- Implement minimal code: 20% of code should handle 80% of requirements.
- Use standard libraries where possible.
- Prefer orchestration over inheritance.
- When implementation is complete, run `sanity-check`.
- For each project changed, create a daily note in `journal/YYYY-MM-DD.md` with that day's changes.

### Python

- Use `uv` as the package manager.
- Install new packages into the `dev` group first.
- Prepend Python commands with `uv run`.
- Add Google-style docstrings with examples for all Python functions.

### IDE

- User IDE is Neovim with config at `~/.config/nvim`.
- User OS/system package config is at `~/.config/nix`.

### MCPs

- For Atlassian-related work, use the Atlassian MCP.
- For repositories hosted on GitHub, use the GitHub MCP.

### CLIs

- Use `glab` for repositories hosted on GitLab.

### LSPs

- Prefer LSP tools when available instead of text-only search.

## Finishing Up

When the user types `/quit`, `quit`, `/exit`, or `exit`, run `/journal` before quitting.
