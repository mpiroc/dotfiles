---
name: Nullability migration Phase 1 philosophy
description: How to reason about user-platform ISS-6843-style schema-widening branches during the REST API nullability migration
type: feedback
originSessionId: 114aefc4-9dbe-43ae-97a9-cd8839312073
---
Phase 1 of the REST API Response Field Nullability migration (ADR at `product-os/adrs/rest-api-response-field-nullability.md`) explicitly widens Zod schemas to accept **both** `null` AND `undefined`. The ADR's three-step rollout has a separate Phase 3 PR that narrows the schemas back down after the pixee-platform backend flip ships.

**Why:** widening in Phase 1 lets the server and client shift independently within a merge window. Without widening, the type broadens as soon as the schema changes, compiler-forcing call-site migration before the server flips. The `.nullable().optional()` union IS the correct Phase 1 shape — it's not excess, it's the point.

**How to apply:**
- Don't flag `.nullable().optional()` widenings as "over-widening" on Phase-1 branches. Even `.nullable()` added to a field that wasn't previously nullable is defensible — defensive permissiveness is the Phase 1 objective.
- Don't suggest narrowing any widening on a Phase-1 branch. Narrowing is the Phase 3 PR's job, after the backend flip ships.
- The real compliance question for a Phase-1 branch is "did it miss any schemas that will be flipped?" — not "did it widen too much?"
- Remember: product-os is the ADR/design repo only. The actual pixee-platform implementation (PR #5389 for the 63-field flip) has not shipped — it's still on a feature branch.
- The ADR explicitly names `user-platform #1617` as the canonical Phase 1 reference implementation (ADR line 185).
