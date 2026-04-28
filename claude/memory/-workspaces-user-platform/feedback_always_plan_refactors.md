---
name: Always plan before refactoring
description: User expects a plan before any non-trivial code changes — don't jump into implementation
type: feedback
originSessionId: f2fd790e-723a-4122-a3af-f4a487c40279
---
Always present a plan before starting non-trivial refactors, even when the task seems straightforward. The user explicitly called this out when I jumped into a `withForm` migration without planning first.

**Why:** The user wants to review the approach before code is written, especially for API/pattern changes that affect many components.

**How to apply:** For any refactor touching multiple components or changing architectural patterns, enter plan mode first and write a plan to the plan file. Only proceed to implementation after the user approves.
