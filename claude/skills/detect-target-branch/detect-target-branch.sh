#!/usr/bin/env bash
set -euo pipefail

# Detect the target branch for the current git branch.
# Outputs two lines: the branch name and the detection method.

branch=$(git branch --show-current)

# 1. vscode-merge-base
merge_base=$(git config --get "branch.${branch}.vscode-merge-base" 2>/dev/null || true)
if [ -n "$merge_base" ]; then
  echo "$merge_base"
  echo "vscode-merge-base"
  exit 0
fi

# 2. Existing PR
pr_base=$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null || true)
if [ -n "$pr_base" ]; then
  case "$pr_base" in
    origin/*) echo "$pr_base" ;;
    *)        echo "origin/$pr_base" ;;
  esac
  echo "PR base branch"
  exit 0
fi

# 3. Default remote HEAD
default_branch=$(git symbolic-ref refs/remotes/origin/HEAD --short 2>/dev/null || true)
if [ -n "$default_branch" ]; then
  echo "$default_branch"
  echo "default branch"
  exit 0
fi

# 4. Fallback
echo "origin/main"
echo "fallback (origin/main)"
