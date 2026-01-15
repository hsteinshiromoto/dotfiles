# Global System Environment and Standards

If any of the below instruction conflict with a local `CLAUDE.md`, please use instruction coming the local file.

## Start up

When you startup, do these things:
- Read all the git commits for the current branch.
- Read the latest note in the folder `journal`. If this folder does not exist, create it on the project root folder.
- Read the file `journal/summary.md`, this is a summary of the all of the changes done so far. If this file does not exist, create one.
Use these pieces of information as your long-term memory.

## Agent Flow

Use always these three subagents in this order:
- 1. Plan agent: understand the request, analyse the context, and plan the implementation. Show the plan for user and ask for approval before moving to the next step.
- 2. Build agent: Execute the planned implementation. Ask the user for approval before modifying any file in accordance to the plan.
- 3. Evaluation agent: Evaluate and changes and run the `/sanity_check` if applicable. Ask the user permission to run the tests, summarise the test results, and ask the user if he's happy with the test outcomes.
Each of these agents will execute at most three tasks.
- 4. If the results of `/sanity_check` are succesful, ask the user if he wants to add the code git staging area.

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
- When you finish your implementation run `/sanity_check`
- For every project that you are making changes. For each day, create a file of the format `YYYY-MM-DD.md` containing all changes done to the repository on that day.

### Python

- All python projects use `uv` package manager.
- All added packages to `uv` will first be installed under the `dev` group and will only be moved into production group manually by a human.
- All python commands need to be prepended by `uv run`.
- All python functions require docstrings using Google format. The docstrings need to have examples.

### IDE

- The user's IDE is neovim with configuration located in `~/.config/nvim`. You are allowed to read/cat/grep/find any file located in there.
- The user's OS/system packages are located in `~/.config/nix`. You are allowed to read/cat/grep/find any file located in there.
