---
name: Always use testing skills for test commands
description: Never run pnpm test or playwright commands directly — always use the running-vitest-tests and running-e2e-tests skills
type: feedback
originSessionId: acabaa64-52f9-424c-ad02-e717700bfde0
---
Never include raw test commands (like `pnpm test -- --run ...`) in plans, instructions, or tool calls. Always use the designated skills:
- `running-vitest-tests` skill for unit/integration/component tests
- `running-e2e-tests` skill for Playwright e2e tests
- `typechecking-code` skill for typecheck
- `linting-code` skill for lint

**Why:** The skills handle edge cases like dev server lifecycle, browser installation, output capture, and failure categorization that raw commands miss. The CLAUDE.md explicitly requires this.

**How to apply:** In plans and during execution, reference skills by name rather than writing out commands. During execution, invoke the Skill tool.
