---
name: Pause for review on non-trivial refactors
description: Don't auto-commit after meaningful refactors — stage the work and let the user review before committing
type: feedback
originSessionId: a4c08453-6fa7-472c-ba4a-3f4ea7efb18b
---
Don't commit automatically after finishing a non-trivial refactor — especially ones that cross package boundaries, change public APIs, or redesign architecture. Stop, summarize what changed, and let the user review before committing.

**Why:** The user said "Don't commit when you're done, let me review first" after approving a design-system refactor (moving theme handling to a React context). They want a review checkpoint before history gets written.

**How to apply:** For anything beyond a small focused fix — refactors affecting multiple packages, architectural changes, new abstractions, public API changes — finish the edits, run typecheck/lint/tests, report status, and then WAIT for an explicit "commit" or "looks good" before running `git commit`. Routine one-off fixes (typo, lint nit, single file edit in response to a single review comment) can still auto-commit as part of a /address-pr-feedback flow.
