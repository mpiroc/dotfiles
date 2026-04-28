---
name: Reuse saved tool output
description: Never re-run lint/test/typecheck just to re-analyze output — read the saved file instead
type: feedback
originSessionId: bc3e291a-0dab-42e4-8735-09d413d89a46
---
Never re-run lint, tests, or typecheck just to re-analyze or filter results. Read the saved output file (e.g., `.scratch/lint-results.txt`) instead.

**Why:** Re-running is slow and wastes the user's time. The output is already available from the previous run.

**How to apply:** After any lint/test/typecheck run, use Read or Grep on the saved output file. Only re-run after making actual code fixes.
