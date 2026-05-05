---
name: Don't claim Bash tool calls run in parallel
description: User has observed that Bash tool calls in a single tool-use block execute sequentially, not concurrently — don't claim otherwise
type: feedback
originSessionId: ec7bf55b-695d-4d8e-a2bc-3312d518147a
---

When multiple Bash tool calls are sent in a single tool-use block, do not tell the user they are running "in parallel" or "concurrently." The user has directly observed that in their environment, each Bash call waits for the previous one to complete before starting.

**Why:** I claimed parallel execution based on the system prompt's guidance about batching independent tool calls; the user corrected me — they can see actual execution timing and the calls are serialized. I have no visibility into real execution timing, so I should not assert it.

**How to apply:**

- Don't say "pulling in parallel" / "running concurrently" / "in parallel" when batching Bash calls. Say "batching these together" or just describe what's being done without claiming a timing model.
- If the user asks why something is slow, don't defend with a parallelism claim — defer to their observation.
- This applies specifically to Bash; behavior for Read/Edit/etc. may differ, but don't speculate.
