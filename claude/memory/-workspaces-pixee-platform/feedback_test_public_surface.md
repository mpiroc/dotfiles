---
name: Test through the public surface, not implementation details
description: Do not extract helpers or restructure code specifically to enable direct unit testing of internal logic — test the component's exposed surface area instead.
type: feedback
originSessionId: db9f1cd5-47c9-4ba2-a834-3aa9ab5b1182
---
Do not extract a helper (static method, package-private function, separate class) whose sole justification is "so it can be tested directly." Internal filtering logic, pure computations buried inside a larger method, and other implementation details should be exercised through the component's public/exposed surface — not lifted into a test-visible seam.

**Why:** Testing implementation details couples tests to how the code is written, not what it does. It creates test-driven architecture decisions (the same anti-pattern as introducing `@Singleton` just to enable mocking), produces dead test seams that have to be maintained alongside the real code, and encourages shallow unit tests that pass while the end-to-end behavior silently breaks. The exposed surface is what clients depend on; that's what tests should verify.

**How to apply:** When you're tempted to extract a static helper / package-private method to make a chunk of logic testable, stop and ask:
1. Is there already a public entry point (HTTP resource, event handler, CLI command, etc.) that exercises this logic? Add the test case there.
2. Is the logic trivial (a few lines of filter/map arithmetic)? If the pieces it composes are already covered by their own component tests, the composition itself often doesn't need a direct test.
3. Only extract when the helper has an independent architectural reason to exist — it's reused elsewhere, it represents a distinct domain concept, or it's complex enough that callers would benefit from it as a named abstraction. "Testability" alone is not that reason.

If you ever write a javadoc like "pulled out of X so the logic can be tested directly," delete the extraction — that javadoc is admitting the refactor was test-driven.
