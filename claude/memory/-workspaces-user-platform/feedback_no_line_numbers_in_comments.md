---
name: No raw line numbers in code comments
description: Don't reference other code by line number in suppressions/comments — they rot the moment a line is added above
type: feedback
originSessionId: 7030af2c-0a0d-4165-85c9-0a9feddb1956
---
When writing suppression comments (`@ts-expect-error`, `eslint-disable`, etc.) or any comment that points at related code elsewhere, do not include raw line numbers (e.g. "see lines 600/603"). Reference by symbol name, schema name, or function name instead.

**Why:** Line numbers go stale silently the moment anyone inserts code above the referenced location. The comment then misdirects future readers.

**How to apply:** When a comment needs to point at related code, use the identifier ("`WorkflowActionSchema` diverges from spec"), not the location ("see lines 600/603"). Same rule applies in PR descriptions and commit messages — name the thing, don't cite a line.
