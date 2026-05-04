---
name: Branch before committing on user-platform
description: When asked to "commit" while HEAD is on main (or any default/integration branch) in user-platform, create a feature branch first — never commit directly on main.
type: feedback
originSessionId: fb5cb957-de81-4c71-98c8-d1868bf018de
---
When the user says "commit" / "commit and push" / etc. and HEAD is on `main` (or any other default/integration branch) in `pixee/user-platform`, **create a feature branch first** and commit there. Don't commit directly on `main` even when explicitly told to commit.

**Why:** The user got visibly upset ("Wha[t] the fuck, why did you commit on `main`?") when I committed a devcontainer config change directly on `main`. The repo's recent history is exclusively PR-merged commits (`#1640`, `#1634`, `#1617`, …) — direct-to-main is never the workflow here, regardless of how trivial the change. "Commit and push" is shorthand for "commit on a branch and push that branch," not literal commit-on-current-HEAD.

**How to apply:**
- Before committing, run `git branch --show-current`. If it returns `main` (or another default/integration branch), pause and either:
  1. Create a feature branch first (`git checkout -b <descriptive-name>`), then commit, OR
  2. Ask the user what branch name to use if the change isn't tied to an existing issue.
- If you've already committed on `main` and the push was rejected (so nothing leaked remotely), recover with: `git branch <feature-branch> HEAD`, `git fetch origin && git reset --hard origin/main`, then `git checkout <feature-branch>`. `git reset --hard` here is recovering from a mistake — surface the plan and get explicit approval before running it (per the CLAUDE.md rule).
- This is in addition to (not a replacement for) the existing "no auto-commit" rule — that one says don't commit without being asked; this one says even when asked, branch first.
