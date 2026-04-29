---
name: ADR-first for cross-cutting migrations
description: For cross-cutting migrations or conventions (e.g. API-wide ProblemJSON), create an ADR in product-os before creating migration issues
type: feedback
originSessionId: e1acfe78-d289-4ae0-879f-54367e114c98
---
For cross-cutting migrations or API-wide conventions, the first DevRev issue should be scoped to **authoring an Architecture Decision Record in the `product-os` repo**, not the migration itself. A separate follow-up issue (or issues) covers the actual implementation.

**Why:** The user corrected a plan that proposed a single "do the ProblemJSON migration" issue under ENH-398, asking instead for an ADR-creation issue. Signals that alignment on the decision comes before execution.

**How to apply:** When asked to create a DevRev issue for a cross-cutting change (new convention, API-wide behavior, migration pattern), default to drafting an "Author ADR in product-os" issue first. Keep the implementation work as a separate, later issue that references the merged ADR. ADRs live in a repo called `product-os` (separate from `pixee-platform`).
