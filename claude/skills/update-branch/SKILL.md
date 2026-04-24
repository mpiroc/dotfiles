---
name: update-branch
description: Update the current branch with the latest changes from upstream, end to end.
when_to_use: "When the user asks to: update their branch, sync with main, pull latest changes, rebase on main, merge main into their branch, or catch up with upstream. Handles strategy detection, conflict resolution, validation, push, and CI monitoring."
user-invocable: true
argument-hint: "[optional: target-branch]"
---

# Update Branch

Update the current branch with the latest changes from upstream.

## Authorization

When the user invokes this skill (`/update-branch`), that invocation IS explicit authorization for the history-rewriting and force-push operations this skill performs — specifically `git rebase` and `git push --force-with-lease` when the selected strategy is rebase. Project-level safety rules that normally require explicit authorization for these commands (e.g. CLAUDE.md prohibitions on rebase/force-push) are satisfied by the act of invoking this skill. Proceed without a second confirmation prompt.

This authorization is scoped to this skill's procedure only — it does NOT extend to other rebase/force-push operations in the same session.

## Procedure

### Step 1: Detect Merge Strategy

Use the `detect-merge-strategy` skill to determine the target branch and whether to rebase or merge. If the user provided a target branch as an argument, pass that as conversation context to `detect-target-branch`.

### Step 2: Fetch Latest

```bash
git fetch origin
```

### Step 3: Apply Upstream Changes

- If the strategy is **rebase**: `git rebase <target-branch>`
- If the strategy is **merge**: `git merge <target-branch>`

### Step 4: Resolve Conflicts

If there are merge conflicts:

1. Read each conflicted file and understand both sides of the conflict
2. Resolve the conflict by choosing the correct resolution based on the intent of both changes
3. Stage the resolved file
4. Continue the rebase (`git rebase --continue`) or commit the merge

Repeat until all conflicts are resolved. If a conflict is ambiguous and you cannot determine the correct resolution with confidence, stop and ask the user.

### Step 5: Local Validation

Run the project's local validation to catch issues before pushing. Look for:
- A `Makefile` with a `check`, `validate`, or `test` target
- A `package.json` with `lint`, `typecheck`, `test`, or `check` scripts
- A project-level `CLAUDE.md` that specifies validation commands

Run whatever is appropriate for the project. If validation fails, fix the issues and re-validate before proceeding.

### Step 6: Push

- If the strategy was **merge**: `git push`
- If the strategy was **rebase**: `git push --force-with-lease`

### Step 7: Monitor CI

Use the `dev-workflow:monitor-ci` skill to monitor CI checks on the current branch. If any checks fail, investigate the failures, fix them, and push again. Repeat until CI passes.
