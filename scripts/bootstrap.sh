#!/usr/bin/env bash
set -euo pipefail

# TDD_setup bootstrap script
# Copies selected setup files from this repo into a target project directory
# without requiring any push access to the target project's remote.

usage() {
  cat <<'EOF'
Usage:
  ./scripts/bootstrap.sh [--force] [--yes] [--dry-run] <target-project-path>

Options:
  --force     Overwrite existing files in target project.
  --yes       Skip confirmation prompt.
  --dry-run   Show what would be copied, but do not write files.
  -h, --help  Show this help.

Examples:
  ./scripts/bootstrap.sh ../my-app
  ./scripts/bootstrap.sh --dry-run ../my-app
  ./scripts/bootstrap.sh --force --yes ../my-app
EOF
}

FORCE=0
ASSUME_YES=0
DRY_RUN=0
TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      FORCE=1
      shift
      ;;
    --yes)
      ASSUME_YES=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -* )
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

if [[ -z "$TARGET" ]]; then
  echo "Error: target-project-path is required." >&2
  usage
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="$(cd "$TARGET" 2>/dev/null && pwd || true)"

if [[ -z "$TARGET" || ! -d "$TARGET" ]]; then
  echo "Error: target path does not exist or is not a directory." >&2
  exit 1
fi

if [[ "$TARGET" == "$REPO_ROOT" ]]; then
  echo "Error: target cannot be this setup repository itself." >&2
  exit 1
fi

# Files/directories to copy from setup repo -> target project.
# Edit this list as your setup evolves.
COPY_ITEMS=(
  ".github"
  "scripts"
)

EXCLUDE_PATHS=(
  ".git"
  ".DS_Store"
)

exists_in_repo() {
  local rel="$1"
  [[ -e "$REPO_ROOT/$rel" ]]
}

copy_item() {
  local rel="$1"
  local src="$REPO_ROOT/$rel"
  local dst="$TARGET/$rel"

  if [[ ! -e "$src" ]]; then
    echo "[skip] missing in setup repo: $rel"
    return 0
  fi

  if [[ -e "$dst" && "$FORCE" -ne 1 ]]; then
    echo "[skip] exists (use --force to overwrite): $rel"
    return 0
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    if [[ -e "$dst" ]]; then
      echo "[dry-run] overwrite $rel"
    else
      echo "[dry-run] create $rel"
    fi
    return 0
  fi

  mkdir -p "$(dirname "$dst")"

  if command -v rsync >/dev/null 2>&1; then
    local rsync_excludes=()
    for ex in "${EXCLUDE_PATHS[@]}"; do
      rsync_excludes+=("--exclude=$ex")
    done

    if [[ -d "$src" ]]; then
      mkdir -p "$dst"
      rsync -a "${rsync_excludes[@]}" "$src/" "$dst/"
    else
      rsync -a "${rsync_excludes[@]}" "$src" "$dst"
    fi
  else
    # Fallback if rsync is unavailable.
    if [[ -d "$src" ]]; then
      mkdir -p "$dst"
      cp -R "$src/." "$dst/"
    else
      cp "$src" "$dst"
    fi
  fi

  if [[ -e "$dst" ]]; then
    if [[ -e "$src" && -e "$dst" ]]; then
      if [[ -e "$TARGET/.git" ]]; then
        echo "[ok] copied $rel"
      else
        echo "[ok] copied $rel"
      fi
    fi
  fi
}

echo "Setup repo: $REPO_ROOT"
echo "Target:     $TARGET"
echo "Mode:       $([[ "$DRY_RUN" -eq 1 ]] && echo 'dry-run' || echo 'apply')"
echo "Overwrite:  $([[ "$FORCE" -eq 1 ]] && echo 'yes' || echo 'no')"
echo

echo "Planned items:"
for item in "${COPY_ITEMS[@]}"; do
  echo "  - $item"
done

echo
if [[ "$ASSUME_YES" -ne 1 && "$DRY_RUN" -ne 1 ]]; then
  read -r -p "Proceed with copy into target project? [y/N] " reply
  case "$reply" in
    y|Y|yes|YES)
      ;;
    *)
      echo "Cancelled."
      exit 0
      ;;
  esac
fi

for item in "${COPY_ITEMS[@]}"; do
  copy_item "$item"
done

echo
if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "Dry-run complete. No files were written."
else
  echo "Bootstrap complete."
  echo "Next steps in target project:"
  echo "  cd '$TARGET'"
  echo "  git status"
  echo "  git add -p   # optional"
  echo "  git commit -m 'Add TDD setup'"
fi
