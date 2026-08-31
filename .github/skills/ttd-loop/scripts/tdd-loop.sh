#!/usr/bin/env bash
# Auto-detects the project's test runner and runs it, printing a red/green summary.
# Usage: tdd-loop.sh [optional path/pattern to scope the test run]
set -uo pipefail

SCOPE="${1:-}"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

run() {
  echo "▶ Running: $*"
  eval "$@"
}

STATUS=1
RAN=0

if [[ -f package.json ]]; then
  PM="npm"
  [[ -f pnpm-lock.yaml ]] && PM="pnpm"
  [[ -f yarn.lock ]] && PM="yarn"
  if grep -q '"test"' package.json; then
    RAN=1
    run "$PM test -- ${SCOPE}"
    STATUS=$?
  fi
elif [[ -f pytest.ini || -f setup.cfg || -f pyproject.toml || -n "$(find . -maxdepth 3 -name 'test_*.py' -print -quit 2>/dev/null)" ]]; then
  RAN=1
  run "pytest ${SCOPE}"
  STATUS=$?
elif [[ -f go.mod ]]; then
  RAN=1
  run "go test ./... ${SCOPE}"
  STATUS=$?
elif [[ -f Cargo.toml ]]; then
  RAN=1
  run "cargo test ${SCOPE}"
  STATUS=$?
elif [[ -f pom.xml ]]; then
  RAN=1
  run "mvn -q test"
  STATUS=$?
elif [[ -f build.gradle || -f build.gradle.kts ]]; then
  RAN=1
  run "./gradlew test"
  STATUS=$?
fi

if [[ "$RAN" -eq 0 ]]; then
  echo "No known test runner detected (checked package.json, pytest/pyproject, go.mod, Cargo.toml, pom.xml, build.gradle)."
  echo "Tell the agent which command to use to run tests in this project."
  exit 2
fi

echo
if [[ "$STATUS" -eq 0 ]]; then
  echo -e "${GREEN}GREEN: all tests passed.${NC}"
else
  echo -e "${RED}RED: tests failed (exit code $STATUS). See output above for the failure report.${NC}"
fi

exit "$STATUS"
