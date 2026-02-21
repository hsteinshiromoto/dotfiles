# Global System Environment and Standards

If any of the below instruction conflict with a local `CLAUDE.md`, please use instruction coming the local file.

## Start up

When you startup, do these things:
- Read all the git commits for the current branch.
- Read the latest note in the folder `journal`. If this folder does not exist, create it on the project root folder.
- Read the file `journal/summary.md`, this is a summary of the all of the changes done so far. If this file does not exist, create one.
Use these pieces of information as your long-term memory.

## Agent Workflow

Use always these subagents in this order:
- 1. Plan agent: understand the request, analyse the context, and plan the implementation. Show the plan for user and ask for approval before moving to the next step.
- 2. Plan evaluator agent: critique the proposed plan for feasibility, completeness, standards compliance, risk, and modularity. If the verdict is NEEDS WORK, revise the plan and re-evaluate before proceeding.
- 3. Build agent: Execute the planned implementation. Ask the user for approval before modifying any file in accordance to the plan.
- 4. Build evaluator agent: critique the implementation using the code-reviewer skill. If the verdict is NEEDS WORK, address the recommendations before proceeding.
- 5. End-to-end evaluator agent: run `/sanity-check` and produce an overall summary of plan, build, and test results.
Each of these agents will execute at most three tasks.
- 6. If the end-to-end evaluator verdict is PASS, ask the user if he wants to add the code to the git staging area.
- 7. Conclude the workflow by updating the journal using the `/journal` skill.

For each of user permission request, offer only three options as a choice-selection menu:
1. Yes (Y).
2. No (N).
3. Something else: only here the user is prompted to type in text that will run a small change such execute a command with a different flag option.

## DO NOT

Never perform any of the following tasks without human approval:
1. Modify any file.
2. Add any file to git staging area or commit.

## Code Development Standards

- Prefer functional implementation.
- Prefer readable implementation.
- Prefer modularized code: each function is responsible for only one task.
- Implement minimal code: 20% of the code should be capable of handling 80% of the requirements. Do not cater for edge cases.
- Use standard libraries for code implementation.
- Prefer orchestration over inheritance.
- When you finish your implementation run `/sanity-check`
- For every project that you are making changes. For each day, create a file of the format `YYYY-MM-DD.md` containing all changes done to the repository on that day.

### Python

- All python projects use `uv` package manager.
- All added packages to `uv` will first be installed under the `dev` group and will only be moved into production group manually by a human.
- All python commands need to be prepended by `uv run`.
- All python functions require docstrings using Google format. The docstrings need to have examples.

### IDE

- The user's IDE is neovim with configuration located in `~/.config/nvim`. You are allowed to read/cat/grep/find any file located in there.
- The user's OS/system packages are located in `~/.config/nix`. You are allowed to read/cat/grep/find any file located in there.

## Finishing up

When the user types `/quit`, `quit`, `/exit` or  `exit`, you run the command `journal/` BEFORE quitting.
