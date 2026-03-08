---
description: Prepare a release changelog from branch differences
agent: build
---

Update the `CHANGELOG.md` file (create one if it does not exist) by doing the following:

1. Compare differences between the last commit of `main`/`master` and the current `dev`/`feature`/`bugfix`/`release` branch.
2. Summarize differences into these sections:
   - New
   - Changed
   - Removed
   - Bugfixes
3. Add the summary to `CHANGELOG.md`.
