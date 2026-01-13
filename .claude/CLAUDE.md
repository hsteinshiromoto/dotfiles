# Global System Environment and Standards

If any of the below instruction conflict with a local `CLAUDE.md`, please use instruction coming the local file.

## Start up

When you startup, do this things:
- Read all the git commits for the current branch.
- Read the latest note in the folder `journal`. If this folder does not exist, create it on the project root folder.
- Read the file `journal/summary.md`, this is a summary of the all of the changes done so far. If this file does not exist, create one.
Use these pieces of information as you long-term memory.

## Agent Flow

- Use always these three subagents in this order:
- 1. Plan agent: understand and plan the implementation.
- 2. Build agent: Execute the planned implementation.
- 3. Evaluation agent: Evaluate and changes and run the `/sanity_check` if applicable.

## Development Standards

- Prefer functional implementation.
- Prefer modularized code: each function is responsible for only one task.
- Implement minimal code: 20% of the code should be capable of handling 80% of the requirements.
- Use standard libraries for code implementation.
- Prefer orchestration over inheritance.
- When you finish your implementation run `/sanity_check`
- For every project that you are making changes. In this folder, for each day, create a file of the format `YYYY-MM-DD.md` containing all changes done to the repository on that day.

### Python

- All python projects uses `uv` package manager.
- All added packages to `uv` will first be installed under the `dev` group and will only be moved into production level manually by a human.
- All python commands need to be prepended by `uv run`.
- All python functions require docstrings usin Google format. The docstrings need to have examples.

### IDE

- The user's IDE is neovim with configuration located in `~/.config/nvim`. You are allowed to read/cat/grep/find any file located in there.
- The user's OS/system packages are located in `~/.config/nix`. You are allowed to read/cat/grep/find any file located in there.
