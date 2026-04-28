---
name: Skip visual-verifier in codespaces
description: Do not invoke the visual-verifier subagent when working in this codespaces environment — it doesn't work there
type: feedback
originSessionId: 40b61b07-39f4-4aa7-9d0f-6d80e2623c03
---
Do not invoke the `visual-verifier` subagent in this user-platform repo (codespaces environment).

**Why:** The user told me directly that "visual-verifier doesn't work in codespaces." Invoking it wastes a turn and produces no usable output.

**How to apply:** When planning or doing UI work in this repo, skip the visual-verifier step entirely. Substitute manual verification: run `pnpm run dev:mocks` or `pnpm run storybook` and ask the user to spot-check, or rely on Playwright VRT in CI for regression coverage. The `visual-verification` skill / project-level guidance that recommends visual-verifier as "BLOCKING" should be treated as overridden by this preference.
