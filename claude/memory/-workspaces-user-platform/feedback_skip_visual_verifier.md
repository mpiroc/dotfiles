---
name: Skip visual-verifier / visual-verification
description: Do not invoke the visual-verifier subagent or visual-verification skill — they never work for this user
type: feedback
originSessionId: b18731de-a988-4f96-bf54-aa85179cfa00
---
Never launch the `visual-verifier` subagent or invoke the `visual-verification` skill. The user has explicitly said it "never works."

**Why:** The user has repeatedly found this tool unreliable. Suggesting or launching it wastes the user's time.

**How to apply:** If a task would normally warrant a visual verification pass (UI component changes, CSS edits, "check how X looks"), skip the verification step or explicitly state "I can't verify the UI — you may want to eyeball it in Storybook." Do NOT reach for `subagent_type=visual-verifier` in the `Agent` tool. If visual confirmation is critical, suggest the user open Storybook themselves.
