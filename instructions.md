# Simple Instructions

## Setup

1. Clone this repo:

```bash
git clone https://github.com/Akshay0112/TDD_setup
cd TDD_setup
```

2. Make bootstrap script executable:

```bash
chmod +x scripts/bootstrap.sh
```

3. Preview changes into your project:

```bash
./scripts/bootstrap.sh --dry-run /path/to/your-project
```

4. Apply setup into your project:

```bash
./scripts/bootstrap.sh /path/to/your-project
```

This copies the TDD setup locally. It does **not** push anything to the target repo.

## Important

Use this setup locally for testing/experimentation, but **do not commit these copied files** unless your team explicitly agrees to adopt them in that repository.

Optional local safety (prevents accidental commits):

```bash
printf "\n.github/agents/\n.github/skills/\nscripts/bootstrap.sh\n" >> .git/info/exclude
```

## Agent location

Agent files are in:

`https://github.com/AKSHAYKUMAR_hubg/TDD_setup/tree/main/.github/agents`

## Prompt template (simple)

Use this in Copilot Chat with the TDD Agent:

```text
Use TDD to implement: <feature name>

Files to change:
- <file1>
- <file2>

Requirements:
1. <req1>
2. <req2>

Edge cases:
- <case1>
- <case2>

Write tests first (RED), then implement (GREEN).
Run targeted tests first, then full suite.
Keep changes minimal and avoid unrelated files.
```
