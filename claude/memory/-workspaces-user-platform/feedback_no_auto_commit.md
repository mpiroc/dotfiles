---
name: No auto-commit
description: User prefers to control when commits are made — don't commit unless explicitly asked
type: feedback
---

Don't commit automatically when finishing a task. Wait for the user to explicitly ask for a commit.

**Why:** User wants to review changes before committing, and interrupted a commit attempt.

**How to apply:** After completing code changes and running verification (typecheck, lint, tests), stop and report results. Only commit when the user says to.
