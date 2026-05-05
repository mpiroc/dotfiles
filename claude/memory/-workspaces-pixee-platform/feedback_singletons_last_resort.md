---
name: Singletons are an anti-pattern and a last resort
description: Do not introduce @Singleton (or any shared-state global) to solve test mocking or convenience problems.
type: feedback
originSessionId: db9f1cd5-47c9-4ba2-a834-3aa9ab5b1182
---
Do not reach for `@Singleton`, `@ApplicationScoped`, or similar CDI bean scopes as a way to make a class mockable in tests. Test-driven architecture decisions are the wrong direction — refactor toward testability via pure functions / extracted helpers instead.

**Why:** Singletons introduce hidden global state and make dependency flows invisible. They're a last-resort pattern and should only appear when there's a clear architectural reason (shared resource, lifecycle management, intentional DI wiring) — never just to enable a mock.

**How to apply:** When a test requires controlling a collaborator that's currently instantiated inline (e.g. `new Foo()`), the default options are, in order:

1. Exercise the behavior through the component's public surface (the existing HTTP resource, event handler, etc.) — don't invent a new seam to poke at internal logic. See `feedback_test_public_surface.md`.
2. Use a real collaborator with test-shaped inputs (real file system via `@TempDir`, real records, etc.).
3. Extract the collaborator's role into a separate, domain-appropriate class **only** if it has a real architectural reason to exist (reuse, distinct concept, complex abstraction), not just a test reason.
4. Only as a last resort, consider turning the collaborator into an injected bean — and have an independent architectural justification for doing so.

Also: adding CDI annotations to a module that doesn't already have CDI usage is a new surface dependency; don't do it unless you're also prepared to defend introducing CDI there.
