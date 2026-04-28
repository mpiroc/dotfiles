---
name: Context is for dependencies, not data
description: When replacing Pure/Impure splits, use context providers for cross-cutting dependencies (QueryClient, toast service, form state) — not a general preference for context over props
type: feedback
originSessionId: 29d07933-8db6-4891-9bcd-8e5951d36a3a
---
When the user says Pure/Impure splits are obsolete, the intent is narrow: cross-cutting *dependencies* (QueryClient, toast service, form state via `<form.AppForm>`) should be injected via context providers at the test/story level so a component can be exercised directly without a Pure wrapper. Regular *data* should still flow through props.

**Why:** Previously I framed this as "prefer context-based decoupling for non-leaf components" — too broad, reads as a general context-over-props preference. The user pushed back: it's specifically about dependency injection, not about avoiding props for data.

**How to apply:** When advising on refactors that eliminate Pure/Impure splits:
- Call out QueryClient / ToastService / form context as the things that should come through providers
- Do not recommend replacing ordinary prop drilling of data with context
- Keep the test/story framing front-and-center (the Pure wrapper existed to make these testable; context providers solve the same problem without the split)
- **Preserve the leaf-component exception**: Pure/Impure is still fine for leaf presentational components where prop-based isolation is simpler than setting up context providers. Don't drop this nuance when tightening the rule.
