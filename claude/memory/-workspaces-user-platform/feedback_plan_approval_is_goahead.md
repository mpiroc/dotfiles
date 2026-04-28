---
name: Plan approval via ExitPlanMode is the go-ahead
description: When the user approves a plan via ExitPlanMode, start implementing immediately — do not re-ask for confirmation
type: feedback
originSessionId: b18731de-a988-4f96-bf54-aa85179cfa00
---
When the user approves a plan via the ExitPlanMode flow, that IS the explicit go-ahead to implement. Do not follow up with "should I go ahead?" or "want me to hold off?" — just start executing the approved plan.

**Why:** After the user approved a plan to write two new e2e tests, I asked whether they wanted me to implement or hold off. The user pushed back: "Of course I want you to implement them. That's what I asked you to plan, and that's the plan I just accepted. Why would you think I wanted something else?" An auto-mode → non-auto-mode transition at the moment of approval is not a signal to doubt the approval itself.

**How to apply:** Treat ExitPlanMode approval as equivalent to "yes, do this." Proceed to implementation immediately. Save confirmation-asking for situations where scope is genuinely ambiguous or something about the situation has changed since the plan was written — not for plans the user just approved. This is distinct from `feedback_questions_vs_requests.md` (which is about *questions* vs. *requests*); approved plans are already requests.
