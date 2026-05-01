---
name: ucs must preserve local edits, never abort
description: The `ucs` command's purpose is to sync local memory edits across machines; it must never abort or discard local changes.
type: feedback
originSessionId: 48182aed-e6c1-4771-ab2d-dd1fe9e818b9
---
`ucs` MUST preserve local working-tree changes — especially memory file edits under `claude/memory/`. It must NEVER abort with "uncommitted changes; commit or stash first" or any equivalent.

**Why:** The user designed `ucs` specifically to sync local memory edits across machines. Memory edits are written by Claude sessions through symlinks (`~/.claude/projects/<slug>/memory` → `claude/memory/<slug>/`), so they appear as unstaged changes in the dotfiles working tree by design. If `ucs` refuses to run on a dirty tree, it has no value — that's the only state it's ever invoked from. The user said: "If it discards local edits, it has no value whatsoever."

**How to apply:** Whenever changing `ucs` (`shell/aliases.sh`), the no-abort, no-discard invariant is non-negotiable. The expected pattern is auto-stash-and-pop around the rebase, plus auto-commit of memory-file dirt as part of `_ucs_sync_local_memories`. Non-memory dirt should round-trip through the stash and end up back in the working tree, untouched. Don't propose "abort with a clearer message" as a fix — aborting is the bug.
