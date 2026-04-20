---
name: detect-target-branch
description: Detect the target branch (merge base) for the current git branch.
when_to_use: When determining the base branch for diffs, PR creation, branch comparison, or upstream sync. When another skill needs to know what branch the current branch will merge into.
user-invocable: false
---

# Detect Target Branch

Detect the target branch for the current git branch.

## Current State

- Branch: !`git branch --show-current`

## Detection Procedure

### Step 1: Conversation Context

If the target branch is already unambiguously established in the current conversation (e.g., the user stated it, or a prior skill/agent set it), use that value. Skip the script and go directly to the output format below.

### Step 2: Run Detection Script

If the target branch is not known from context, run the helper script:

```bash
bash "$(dirname "$(readlink -f ~/.claude/skills/detect-target-branch/SKILL.md)")/detect-target-branch.sh"
```

The script outputs two lines: the branch name and the detection method. It checks, in order:
1. `vscode-merge-base` git config for the current branch
2. Base branch of an existing PR for the current branch
3. Default remote HEAD (`origin/HEAD`)
4. Falls back to `origin/main`

## Output Format

After detection, emit the result in exactly this format:

```
**Target branch:** `<branch>`
**Detection method:** <method>
```

Where `<method>` is one of: `conversation context`, `vscode-merge-base`, `PR base branch`, `default branch`, or `fallback (origin/main)`.
