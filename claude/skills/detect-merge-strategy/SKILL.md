---
name: detect-merge-strategy
description: Determine whether to use rebase or merge when pulling in upstream changes.
when_to_use: When pulling, syncing, or updating a branch from its target. When another skill needs to decide between rebase and merge. Checks for merge commits on the current branch to avoid flattening them with a rebase.
user-invocable: false
---

# Detect Merge Strategy

Determine whether to use rebase or merge when pulling in upstream changes.

## Procedure

### Step 1: Detect Target Branch

Use the `detect-target-branch` skill to determine the target branch.

### Step 2: Check for Merge Commits

Run the helper script, passing the detected target branch as an argument:

```bash
bash "$(dirname "$(readlink -f ~/.claude/skills/detect-merge-strategy/SKILL.md)")/detect-merge-strategy.sh" "<target-branch>"
```

The script checks for merge commits between the merge-base and HEAD:
- If merge commits exist, it selects **merge** (rebasing would flatten them)
- If no merge commits exist, it selects **rebase** (for a clean linear history)

## Output Format

After detection, emit the result in exactly this format:

```
**Merge strategy:** `<rebase|merge>`
**Reason:** <reason>
```
