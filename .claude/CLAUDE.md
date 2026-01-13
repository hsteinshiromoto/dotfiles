# Global System Environment and Standards

## Start up

When you startup, do this things:
- Look at git log for the current branch.
- Look at the latest note in the folder `journal`. If this folder does not exist, create it on the project root folder.
Use these pieces of information as you long-term memory.

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

