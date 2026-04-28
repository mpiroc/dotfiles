---
name: Stay within issue scope
description: Don't add features from dependent/future issues — refactoring issues should be behavioral no-ops
type: feedback
originSessionId: 321cece5-e86e-460a-b940-ab8f58db6dd3
---
When an issue is a refactor (e.g., "migrate to TanStack Form"), keep it as a pure refactor with no behavioral changes. Don't pull in work from dependent issues (e.g., adding validation, error display) even if the issue description mentions they're related.

**Why:** The user structures issues with dependencies. Adding out-of-scope features conflates the refactor with the next issue's work and makes review harder.

**How to apply:** Read the issue scope carefully and distinguish between what this issue does vs. what dependent issues will do. If in doubt, ask.
