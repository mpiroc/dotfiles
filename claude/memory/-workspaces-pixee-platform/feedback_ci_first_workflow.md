---
name: Push first, CI in background, work while waiting
description: Preferred workflow when a branch is ready to push — maximize CI overlap with other work.
type: feedback
originSessionId: db9f1cd5-47c9-4ba2-a834-3aa9ab5b1182
---
When a branch is ready to push (rebase clean, changes complete), follow this ordering:

1. **Push immediately.** Do NOT run local validation first. CI is slow (Build and Test typically 11-18 min on this repo), so kick it off as early as possible. Full local `./gradlew build` is redundant and the daemon OOMs here anyway.
2. **Monitor CI in the background** (e.g. `Bash(run_in_background=true)` with `gh pr checks --watch`), not in the foreground.
3. **Do useful work in the meantime** — code review of the branch, refactoring, writing follow-ups, etc. — while CI runs.
4. **Only run local validation if CI fails**, and only for the failing modules.

**Why:** CI wall-clock time dominates; overlapping it with review/refactoring work recovers most of that time. Local validation before push is wasted work if CI passes, and duplicates CI if it fails.

**How to apply:** Applies to pushes on this repo where there's meaningful independent work to do while CI runs (code review, addressing TODOs, drafting follow-up changes). For one-off fixes with nothing else queued up, foreground CI monitoring is fine.
