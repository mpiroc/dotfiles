---
name: TanStack Form migration is phased
description: Forms are being moved to TanStack Form in stages — state first, validators next, Field API last
type: project
originSessionId: 04d2e413-fb98-4917-946e-1e80f7a9a884
---
The user-platform TanStack Form migration is a multi-phase plan, not a finished shape:

- **Phase 1 (in progress, where we are now):** Move existing form state into TanStack Form. Forms use `useStore(form.store, s => s.values.x)` for reads and `form.setFieldValue` for writes. No `validators`, no `form.Field` / Field API, no field-level error binding. Validation is computed inline; ProblemJSON errors surface as toasts.
- **Phase 2 (planned):** Add validators (`validators.onChange` / `onSubmit`, likely Zod-backed). Will replace the inline-helper validation pattern. The `/writing-forms` skill will be updated as part of this phase.
- **Phase 3 (planned):** Adopt the Field API (`form.Field`, `<field.Input />`, etc.). Will likely change how field components are written and where errors are surfaced. The `/writing-forms` skill will be updated again.

**Why:** Each migration phase is being shipped separately so the diffs stay reviewable and forms stay shippable between phases.

**How to apply:** When creating, reviewing, or planning form work, treat the current "no validators, no Field API" pattern as deliberately scoped to Phase 1 — not a permanent anti-pattern. Anti-pattern guidance in the `/writing-forms` skill (and any reviews) should be framed as "not in this phase yet" rather than "never." When ISS-6876 ships the skill, expect it to grow as Phases 2 and 3 land.
