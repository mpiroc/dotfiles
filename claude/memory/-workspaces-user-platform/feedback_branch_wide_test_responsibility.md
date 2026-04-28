---
name: Branch-wide responsibility for test failures
description: Every failing test/lint/type error on the current branch is my responsibility regardless of which commit introduced it; reject the four common rationalizations
type: feedback
originSessionId: 7b3d1ba2-45ff-4356-841f-22d88de31598
---
Every failing test, lint error, and type error on the current branch is my responsibility — not just the ones introduced by my most-recent commit. The branch is one unit of work from the reviewer's perspective.

Reject these four rationalizations:

1. **"It wasn't introduced in the latest commit."** Irrelevant — responsibility is the branch tip, not `HEAD~1..HEAD`.
2. **"It was introduced by a different Claude session / by the user / before I got here."** Irrelevant — session boundaries are invisible to the reviewer. Fix it or escalate.
3. **"My change couldn't have caused this."** Expectation is not evidence. If we could predict which tests a change breaks, we would not need tests. Assume any failure is related to my change until proven otherwise by reading the code.
4. **"It's probably flaky."** Not acceptable without evidence **from the current commit** — a passing re-run of the specific failing test on current `HEAD`. A test that flaked on main or an earlier revision is not evidence about this commit. When citing a pass, record it in the response (test name + "passed on retry on `$SHA`") so the claim is falsifiable.

If a failure is genuinely pre-existing and I decide not to fix it, I must surface it explicitly to the user with the reasoning — not bury it or silently omit it. The user decides whether to accept a pre-existing failure, not me.

**Why:** The user has repeatedly observed me disclaim responsibility for failures I should have fixed, using exactly these four patterns. The remedy codified here ([root `CLAUDE.md` → "Branch-Wide Test Responsibility"](../../../workspaces/user-platform/CLAUDE.md)) and [per-skill pointers in `.claude/skills/{running-vitest-tests,running-e2e-tests,linting-code,typechecking-code}/SKILL.md`](../../../workspaces/user-platform/.claude/skills/) is what this memory is reminding me to honor.

**How to apply:** At any test, lint, or typecheck failure — from any skill, at any point in the task — default to "mine, fix it." Before reporting a failure as pre-existing or flaky to the user, check the four rationalizations above and confirm the claim is evidence-based. If escalating a genuinely pre-existing failure, state it explicitly.
