---
name: Use real QueryClient in tests
description: When tests need a QueryClient (e.g. for MutationFunctionContext), use useQueryClient() from the provider — don't construct standalone mocks
type: feedback
originSessionId: 9a14bf92-cf3b-4e72-8ec8-783cbdeae598
---
Use the real QueryClient from the test/story provider (via `useQueryClient()`) instead of constructing a standalone `new QueryClient()` mock. The test infrastructure already provides a properly configured QueryClient through `WithQueryClient`/`renderHookWithQueryProvider`.

**Why:** The user explicitly corrected this approach — standalone mock QueryClients are the wrong pattern when a real one is available from the provider context.

**How to apply:** When a test or story needs a `QueryClient` reference (e.g. for `MutationFunctionContext`), render a composite hook that also calls `useQueryClient()` to grab the real client from the provider, rather than creating a new one at module scope.
