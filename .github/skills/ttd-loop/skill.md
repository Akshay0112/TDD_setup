---
name: tdd-loop
description: 'Run the test suite and get a red/green report for Test-Driven Development. Use when running tests to check if newly written failing tests are red, or to verify an implementation turned tests green. Triggers: "run tests", "run the tdd loop", "check test status", "red green report".'
argument-hint: 'Optional: path/pattern of tests to run'
---

# TDD Loop

Runs the project's test suite via auto-detected test runner and prints a pass/fail summary, so it can be used identically from chat or the terminal.

## When to Use
- After drafting new (expected-to-fail) tests, to confirm the red state.
- After implementing code, to confirm tests turned green.
- Any time you need a quick pass/fail report without hand-picking the test command.

## Procedure
1. Run the [tdd-loop script](./scripts/tdd-loop.sh), optionally passing a path/pattern as an argument to scope the run.
2. The script auto-detects the test runner in this order: `npm`/`yarn`/`pnpm` (via `package.json` test script), `pytest`, `go test`, `cargo test`, `mvn`/`gradle`. If none are found, it exits with an error asking the user which command to use.
3. Read the script's exit code and printed summary: exit `0` = all green, non-zero = failures (red).
4. Report the summary back to the user (or, if in the TDD Agent loop, use it to decide the next code change).

## Terminal Usage
```bash
chmod +x .github/skills/tdd-loop/scripts/tdd-loop.sh   # first time only
.github/skills/tdd-loop/scripts/tdd-loop.sh             # run full suite
.github/skills/tdd-loop/scripts/tdd-loop.sh path/to/test # run a subset
```
