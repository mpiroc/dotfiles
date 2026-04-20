#!/usr/bin/env bash
set -euo pipefail

# Detect whether to use rebase or merge based on existing merge commits.
# Takes the target branch as the first argument.
# Outputs two lines: the strategy ("rebase" or "merge") and the reason.

target="$1"

merge_base=$(git merge-base HEAD "$target" 2>/dev/null || true)
if [ -z "$merge_base" ]; then
  echo "rebase"
  echo "no common ancestor found with $target"
  exit 0
fi

merge_commits=$(git rev-list --merges "$merge_base"..HEAD)
if [ -n "$merge_commits" ]; then
  echo "merge"
  echo "merge commits exist since $target"
else
  echo "rebase"
  echo "no merge commits since $target"
fi
