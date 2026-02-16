---
name: "sanity_check"
description: "Run the tests of this repository"
argument-hint: "specific files or modules"
---

Before testing the code always ask these questions:
1. Run only the changes or for the whole codebase?
2. Run using predefined settings or other custom command. For example, predefined in a `Makefile` or a `justfile`. If the user wants a custom command, suggest at lleast one for the user.
