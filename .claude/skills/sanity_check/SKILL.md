---
name: "sanity-check"
description: "Run the tests of this repository"
argument-hint: "changed|all|dependencies [args]"
disable-model-invocation: false
---

# Sanity Check

## Defaults Workflow

1. Read `README.md` to understand how the tests are run.
2. Read `Makefile` and `Justfile` to understand the test commands.
3. Whenever in conflict, consider `Makefile` as the source of truth.
4. Before testing the code always ask these questions:
    - Run only for the changes, the changed scripts + related dependencies or for the whole codebase?
    - Run using predefined settings or other custom command. For example, predefined in a `Makefile` or a `justfile`. If the user wants a custom command, suggest at lleast one for the user.

## Operations

### run [all]

Run the tests for the whole codebase.

### run [changed]

Run the tests only for the changed code.

### run [dependencies]

Run the tests for the changed code and related dependencies.
