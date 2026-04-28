---
name: Query options input type pattern
description: getOptions functions must use intersection with Omit<UseQueryOptions> (no Partial wrapper) to pass through all TanStack Query options
type: feedback
---

When creating `get*Options` functions in api-hooks.ts, the input type must pass through all TanStack Query options using an intersection with `Omit<UseQueryOptions<TData, TError>, 'queryKey' | 'queryFn'>` — NOT wrapped in `Partial`.

**Why:** This is the established pattern throughout the codebase (see `useGetFindingArticle`, `useGetSystemStatuses`, `getScanOptions`). `UseQueryOptions` fields are already optional, so `Partial` is redundant and deviates from the pattern.

**How to apply:** When writing `get*Options` or `useGet*` hooks, structure the input type as:
```typescript
type GetFooOptionsInput = {
  domainParam: string
  page?: PageOptions
} & Omit<UseQueryOptions<FooResponse, ApiError>, 'queryKey' | 'queryFn'>
```
Then destructure domain params + `enabled` with default, spread `...rest` into `queryOptions()`.
