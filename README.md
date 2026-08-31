# TDD_setup

A drop-in Test-Driven Development toolkit for VS Code Copilot Chat, made of one **agent** and one **skill**, described in [plug.json](plug.json).

## Quickstart (for teammates)

```bash
# 1. Get the toolkit
git clone <this-repo-url> ~/tools/tdd-toolkit

# 2. Install into your project
cd ~/path/to/your-project
~/tools/tdd-toolkit/install.sh .

# 3. Commit it so the rest of your team gets it too
git add .github/agents/tdd.agent.md .github/skills/tdd-loop
git commit -m "Add TDD Agent + tdd-loop skill"
git push

# 4. Use it in chat
#    Open Copilot Chat -> pick "TDD Agent" from the agent picker -> describe your feature.

# 5. Use it in the terminal (no chat needed)
chmod +x .github/skills/tdd-loop/scripts/tdd-loop.sh   # first time only
.github/skills/tdd-loop/scripts/tdd-loop.sh            # run full suite, prints RED/GREEN
.github/skills/tdd-loop/scripts/tdd-loop.sh path/to/test  # run a subset

# 6. Later, pull updates to the toolkit and re-install
cd ~/tools/tdd-toolkit && git pull
~/tools/tdd-toolkit/install.sh /path/to/your-project
```

## What's included
- `.github/agents/tdd.agent.md` — **TDD Agent**: interviews you about the request, writes failing tests first, runs them, implements the minimal code, and loops (red → green) until everything passes.
- `.github/skills/tdd-loop/SKILL.md` + `.github/skills/tdd-loop/scripts/tdd-loop.sh` — **tdd-loop**: auto-detects your test runner (npm/yarn/pnpm, pytest, go test, cargo test, maven, gradle) and runs tests consistently.
- `plug.json` — manifest listing the agent/skill entry points, for reference or tooling that wants to discover them.

## How to use it in chat
1. Open Copilot Chat and pick **TDD Agent** from the agent/mode picker (or ask a normal request that mentions "TDD" / "test-driven" — it can also be invoked as a subagent).
2. Describe what you want built. The agent will ask clarifying questions first (behavior, edge cases, test framework) if anything is ambiguous.
3. It writes the tests, runs the `tdd-loop` skill to confirm they fail for the right reason (red), implements code, reruns tests, and repeats until green.
4. You'll get an iteration-by-iteration report: tests changed, run results, code changed, next step.

## How to use it in the terminal
```bash
# first time only
chmod +x .github/skills/tdd-loop/scripts/tdd-loop.sh

# run the full suite
.github/skills/tdd-loop/scripts/tdd-loop.sh

# run a subset (path or pattern, passed through to the underlying test runner)
.github/skills/tdd-loop/scripts/tdd-loop.sh path/to/test_file
```
Exit code `0` = all green, non-zero = red (failures) — useful in pre-commit hooks or CI steps.

## Using this toolkit in other projects

### Personal (just you, every workspace)
Copy `.github/agents/tdd.agent.md` into `<VS Code user profile>/prompts/agents/` so the agent shows up everywhere without copying per repo. The `tdd-loop` skill script still needs to exist in whichever project you run tests for.

### Team-wide (shared with everyone on a project)
This repo keeps the source of truth. Each teammate runs the bundled installer **once** inside their own project to pull the agent + skill in, then commits the result so it's versioned and pulled automatically by everyone.

1. Get a local copy of this `TDD_setup` repo (clone it, or have it available on disk/network share).
2. From inside their target project, run:
   ```bash
   /path/to/TDD_setup/install.sh            # installs into the current directory
   # or
   /path/to/TDD_setup/install.sh /path/to/their-project
   ```
   This copies `.github/agents/tdd.agent.md` and `.github/skills/tdd-loop/` into their project (and drops a reference `plug.json.tdd-toolkit` manifest).
3. They commit `.github/agents/tdd.agent.md` and `.github/skills/tdd-loop/` to their project's repo.
4. From then on, everyone who clones that project automatically gets the **TDD Agent** in their agent picker and the `tdd-loop` skill/script — no per-person setup needed.

Re-running `install.sh` later (e.g. after this toolkit is updated) overwrites the files with the newer version — treat this repo as the upstream source and re-sync teammates' projects periodically.

## Reuse this TDD setup in another repository (without pushing to their repo)

This repository provides a local bootstrap script that copies TDD setup files into a target project directory.

### 1) Clone this setup repo

```bash
git clone https://github.com/AKSHAYKUMAR_hubg/TDD_setup
cd TDD_setup
chmod +x scripts/bootstrap.sh
```

### 2) Preview what will be copied (recommended)

```bash
./scripts/bootstrap.sh --dry-run /path/to/target-project
```

### 3) Apply the setup

```bash
./scripts/bootstrap.sh /path/to/target-project
```

Options:
- `--force` : overwrite existing files in target project
- `--yes` : skip confirmation prompt
- `--dry-run` : preview only, no files written

### 4) In the target project, review and commit

```bash
cd /path/to/target-project
git status
git add -p
git commit -m "Add TDD setup"
```

## Notes

- This script **does not push** anything to the target repository.
- It only copies files locally into the target directory.
- The target team controls what they stage/commit/push.
