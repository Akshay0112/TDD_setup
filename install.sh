#!/usr/bin/env bash
# Installs the TDD toolkit (agent + skill) into a target project's .github/ folder.
# Usage:
#   ./install.sh                 install into the current directory
#   ./install.sh /path/to/repo   install into a specific project
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-.}"

if [[ ! -d "$TARGET" ]]; then
  echo "Target directory does not exist: $TARGET" >&2
  exit 1
fi

TARGET="$(cd "$TARGET" && pwd)"

mkdir -p "$TARGET/.github/agents" "$TARGET/.github/skills"
cp "$SRC_DIR/.github/agents/tdd.agent.md" "$TARGET/.github/agents/tdd.agent.md"
cp -R "$SRC_DIR/.github/skills/tdd-loop" "$TARGET/.github/skills/tdd-loop"
chmod +x "$TARGET/.github/skills/tdd-loop/scripts/tdd-loop.sh"
cp "$SRC_DIR/plug.json" "$TARGET/plug.json.tdd-toolkit"

echo "Installed TDD Agent + tdd-loop skill into: $TARGET"
echo "  - $TARGET/.github/agents/tdd.agent.md"
echo "  - $TARGET/.github/skills/tdd-loop/"
echo "  - $TARGET/plug.json.tdd-toolkit (reference manifest; merge into your own plug.json if you have one)"
echo
echo "Commit these files so your whole team gets the TDD Agent when they pull."
