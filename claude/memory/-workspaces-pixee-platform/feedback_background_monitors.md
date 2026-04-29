---
name: Background long-running monitor commands
description: Run CI/log watchers (gh pr checks --watch, tail -f, etc.) with run_in_background=true so the session stays unblocked
type: feedback
originSessionId: 54f83f74-5173-4665-adaf-4dced819ff81
---
Long-running monitor commands — `gh pr checks <PR> --watch`, `tail -f`, log tails, anything that polls until a terminal state — must be launched with `run_in_background=true` on the Bash tool (or via the Monitor tool). Do not run them in the foreground.

**Why:** The user interrupted me when I ran `gh pr checks 5691 --watch` in the foreground during `/dev-workflow:monitor-ci` — it blocks the turn for up to 20 minutes when I could be doing other work in parallel, and Claude Code sends a completion notification automatically.

**How to apply:** Whenever a command's job is to watch/wait/poll (not produce a one-shot result), set `run_in_background: true`. The harness notifies when the task exits. Foreground is only appropriate for commands whose results I need synchronously to decide the next step.
