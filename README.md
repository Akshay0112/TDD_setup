# TDD_setup

## 1-Minute Quickstart

```bash
# 1) Clone toolkit
git clone https://github.com/Akshay0112/TDD_setup
cd TDD_setup

# 2) Install into your project
./install.sh /path/to/your-project

# 3) In your project, commit the toolkit
cd /path/to/your-project
git add .github/agents/tdd.agent.md .github/skills/tdd-loop
git commit -m "Add TDD toolkit"
git push
```

Then open **Copilot Chat**, select **TDD Agent**, and describe your feature.

Optional terminal usage:

```bash
chmod +x .github/skills/tdd-loop/scripts/tdd-loop.sh
.github/skills/tdd-loop/scripts/tdd-loop.sh
```

---

A lightweight Test-Driven Development (TDD) toolkit for GitHub Copilot Chat.

It includes:
- **TDD Agent** → guides a Red → Green workflow
- **tdd-loop skill** → runs your tests and reports RED/GREEN status

---

## Quick Start

### 1) Clone this repository

```bash
git clone https://github.com/Akshay0112/TDD_setup
cd TDD_setup
```

### 2) Install into your target project

```bash
./install.sh /path/to/your-project
```

> If `install.sh` is not executable:

```bash
chmod +x install.sh
```

### 3) In your target project, review and commit

```bash
cd /path/to/your-project
git status
git add .github/agents/tdd.agent.md .github/skills/tdd-loop
git commit -m "Add TDD toolkit"
git push
```

---

## What Gets Installed

- `.github/agents/tdd.agent.md`
- `.github/skills/tdd-loop/`
- `plug.json.tdd-toolkit` (reference manifest)

---

## Use in Copilot Chat

1. Open Copilot Chat.
2. Select **TDD Agent** from the agent picker.
3. Describe the feature you want.
4. The agent follows TDD: tests first (RED), then implementation (GREEN).

---

## Use in Terminal

From your target project:

```bash
# first time only
chmod +x .github/skills/tdd-loop/scripts/tdd-loop.sh

# run full suite
.github/skills/tdd-loop/scripts/tdd-loop.sh

# run a subset
.github/skills/tdd-loop/scripts/tdd-loop.sh path/to/test_file
```

- Exit code `0` = GREEN (all passing)
- Non-zero exit code = RED (failures)

---

## Local-Only Bootstrap (No Push)

If you only want to copy files locally (without automatically committing/pushing), use:

```bash
chmod +x scripts/bootstrap.sh
./scripts/bootstrap.sh --dry-run /path/to/target-project
./scripts/bootstrap.sh /path/to/target-project
```

Useful options:
- `--dry-run` → preview only
- `--force` → overwrite existing files
- `--yes` → skip confirmation prompt

**Note:** bootstrap only copies files on your machine. It does not push to GitHub.

---

## Update Later

When this toolkit changes:

```bash
cd /path/to/TDD_setup
git pull
./install.sh /path/to/your-project
```

Re-running install refreshes the copied toolkit files in your project.

---

## Agent Files Location

Source location in this repo:

`/.github/agents`
