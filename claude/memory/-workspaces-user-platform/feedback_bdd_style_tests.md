---
name: BDD style for new tests
description: New test suites should use BDD-style structure with nested describe blocks and natural-language it assertions
type: feedback
originSessionId: f2fd790e-723a-4122-a3af-f4a487c40279
---
New test suites should use BDD-style structure, not just `it` instead of `test`.

**Why:** User wants tests that read as specifications — organized by scenario with natural english descriptions.

**How to apply:**
- Use nested `describe` blocks to group by scenario or feature area
- Use `it('should ...')` with natural english for behaviors
- Don't just flat-list tests under a single `describe` — group related assertions together
- Existing test files using `test()` should not be changed unless being rewritten
