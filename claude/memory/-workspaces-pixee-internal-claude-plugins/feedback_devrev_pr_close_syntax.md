---
name: DevRev issue-closing syntax in PR descriptions
description: In PRs that should auto-close a DevRev issue on merge, use "/close ISS-XXXX" — not GitHub's "Closes ISS-XXXX".
type: feedback
originSessionId: e00f4e47-890e-498b-b945-7ba01d1e0e23
---
When a PR should close a DevRev issue on merge, put `/close ISS-XXXX` in the PR body (on its own line). Do **not** use GitHub's `Closes #XXX` / `Closes ISS-XXXX` / `Fixes ISS-XXXX` syntax — those are for GitHub issues and will not close DevRev issues.

**Why:** DevRev's GitHub integration watches PR bodies for the literal command-style `/close <display-id>` to drive the close action. GitHub's closing keywords only resolve to issues tracked in GitHub itself, so using them for DevRev IDs silently does nothing on merge.

**How to apply:** Any time a PR is linked to a DevRev issue (IDs like `ISS-XXXX`, `INC-XXXX`, `TKT-XXXX`, etc.) and should auto-close it on merge, use `/close <display-id>` in the PR body. If the PR references but should *not* close the issue, just mention the ID (e.g. "Part of ISS-XXXX") without the slash command.
