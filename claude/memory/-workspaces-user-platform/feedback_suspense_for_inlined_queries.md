---
name: Suspense queries when inlining query data
description: When moving a query out of props into the component, prefer the suspense variant of the query hook
type: feedback
originSessionId: 24f9709c-bcec-44e5-a7ea-9cb9b7e362f1
---
When refactoring a component that previously received "definitely-defined" query data via props so it instead mounts the query itself (per the pure-impure-component-separation rule), use a **suspense** query hook (`useSuspenseQuery` / `useSuspenseGetXxx`), not a regular `useQuery`. Reasons:

- The component no longer needs to handle loading/undefined branches in its render tree — `data` is always defined under the suspense boundary.
- It avoids leaking loading-state ceremony (`if (!data) ...`) into business components.

**Why:** matthew called this out explicitly mid-refactor on AddFindingsDrawer (ISS-6781): "When refactoring a component like this that received definitely-defined query data, it should be refactored to use a *suspense* query rather than a regular query. If there is no existing suspense query hook for that query, create one, using the same options as a non-suspense query."

**How to apply:**
- If a non-suspense `useGetXxx` exists, refactor to extract a `getXxxOptions(...)` factory returning `queryOptions(...)` with everything (queryKey, queryFn, *and* `enabled`) inside the factory. Both `useGetXxx` and `useSuspenseGetXxx` then pass the unmodified options through. See `useGetIntegrations` / `useSuspenseGetIntegrations` in `src/utils/api-client/api-hooks.ts` for the canonical shape.
- **Suspense boundary placement is critical.** The suspense query call lives in an *inner* child component, and the outer (container) owns the `<Suspense fallback={...}>` boundary. A `<Suspense>` only catches suspends thrown by its descendants — putting it in the same component that calls `useSuspenseQuery` won't work, the throw walks past to the next ancestor boundary. So consumers do NOT need to wrap; the drawer/modal owns the boundary.
- **Move Dialog.Title and Dialog.Description into the inner component too**, alongside the form (and anything else that needs the fetched data). Don't render a static placeholder Title in the outer "for accessibility" — Radix is fine with the Title living inside Suspense, and it lets the inner render the data-aware Title (e.g. with the repo name). Visual layout is preserved; consumers stay simple.
- See `AddFindingsDrawer` (`src/components/drawers/add-findings-drawer.tsx`) and `AddRepositoryModal` (`src/routes/repositories-page/add-repository-modal.tsx`) for the canonical pattern.
