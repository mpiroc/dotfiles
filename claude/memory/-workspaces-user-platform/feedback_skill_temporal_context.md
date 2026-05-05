---
name: Keep temporal context out of SKILL.md
description: Move "this is phase X" / migration framing into DevRev issues and sibling README.md, not into the SKILL.md body
type: feedback
originSessionId: 04d2e413-fb98-4917-946e-1e80f7a9a884
---
When authoring a Claude Code skill that captures patterns from an in-flight migration, do not embed "Phase 1 / Phase 2 / Phase 3" language (or other dated/temporal framing) in `SKILL.md`. The SKILL body is read by agents on every invocation and stale temporal qualifiers age badly.

**Why:** Anthropic's official skill-authoring guidance explicitly warns against time-sensitive content. Phases age the same way dates do — when the next phase ships, every "in Phase 1" qualifier is at best confusing and at worst wrong. Centralizing temporal context outside SKILL.md keeps the skill evergreen.

**How to apply:**

- **DevRev issues** for each future phase. Link them from the README, not the skill. Tracks the work and owns the schedule.
- **Sibling `README.md`** in the same skill directory for short human-reviewer context: "this captures the current shape; Phases X/Y are tracked in [issue links]; update the skill when each lands." Agents won't auto-load README; humans will.
- **`SKILL.md` body** stays evergreen — describe the current conventions in present tense without phase numbers. A "Not yet" / "Out of scope" section may list deferred capabilities, but framed by what's deferred, not by which phase number it lives in.

This separation also applies to other temporal framing patterns (deprecation timelines, migration windows, "until X is done" caveats).
