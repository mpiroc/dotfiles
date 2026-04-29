---
name: Don't take over pre-existing user state — defer, then resume
description: When automation hits in-progress state the user might own (pending review, draft, lock, etc.), do not silently reuse or overwrite it. Do the safe parts of the work now, queue the parts that conflict, ask the user to clear the conflict, and flush the queue once they confirm.
type: feedback
originSessionId: 7712bbb3-0401-427b-a4cd-8d9852589ed0
---
When designing a tool/skill that interacts with stateful external systems
(GitHub pending reviews, draft PRs, in-progress comments, locks, sessions,
etc.) and you find pre-existing state that *could* have been created by the
user manually, the default must be:

1. **Do not silently reuse, append to, or overwrite** that state.
2. **Do not abort the entire run.** Identify the narrowest set of steps that
   actually conflict with the pre-existing state. Continue executing every
   step that does *not* touch it.
3. **Queue, don't drop.** For the steps that do conflict, capture the data
   they would have produced (in conversation memory) so it isn't lost.
4. **Hand off to the user, then resume.** Once the safe work is done, ask
   the user to clear the conflict (e.g. "submit or discard your pending
   review") and pause. When they confirm it's resolved, retry the conflicting
   step and flush the queue. If the conflict is *still* there on retry, tell
   the user and stop — don't loop.

**Why:** While planning the `address-pr-feedback` rewrite I made two wrong
calls in a row before landing on this pattern. First I proposed silently
reusing the user's existing PENDING review (rejected — could clobber their
manual draft). Then I over-corrected to aborting the whole skill (rejected —
the user still wanted the code changes, commits, thread resolution, and
push, since none of those touch the pending review). The user's actual ask
was: do the safe work, remember what I owe them, ask them to clear the
conflict, then post the comments once they confirm. That third option — the
queue-and-resume pattern — is the one that respects both their state and
their goal.

**How to apply:**
- At the entry point that conflicts with user state, set a flag like
  `POST_NOW=false` instead of branching the whole flow.
- Replace conflicting in-loop side effects with appends to an in-memory
  queue. Resolution / commits / pushes typically don't conflict — keep them.
- After the unconditional work runs, if `POST_NOW=false`, surface a clear
  message naming the specific conflict, ask the user to clear it, and
  *actually wait* for confirmation before retrying.
- Reserve hard aborts for cases where continuing would produce a wrong
  result (not merely an incomplete one), or for retries where the conflict
  persists.
