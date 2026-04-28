---
name: Answer questions before implementing
description: When the user asks "can we...?" or "is it possible to...?", answer first; do not jump to implementation
type: feedback
originSessionId: b18731de-a988-4f96-bf54-aa85179cfa00
---
When the user asks a question phrased as "can we X?", "is it possible to Y?", or "is there a way to Z?", they are asking for information — not requesting implementation. Answer the question first. Implement only after they confirm they want it done.

**Why:** The user pushed back after I answered "can we also disable the visual-verifier agent?" by immediately building and installing a PreToolUse hook workaround. They wanted to know whether settings.json supports it natively; they didn't ask me to construct a workaround.

**How to apply:** For a question, respond with the factual answer (yes/no + mechanism) and — if there's no direct solution — list options for the user to choose from. Wait for explicit go-ahead before editing files, running tools, or building workarounds. This applies even in auto mode: a question is not a request for action.
