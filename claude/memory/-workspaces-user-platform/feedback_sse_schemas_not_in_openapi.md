---
name: SSE schemas are hand-maintained, not from OpenAPI
description: In user-platform, SSE event Zod schemas are maintained by hand and are not part of the OpenAPI spec — don't assume /syncing-zod-schemas or OpenAPI regeneration applies to them
type: feedback
originSessionId: 257ea31e-072c-4d5c-ae8c-420f39c8a574
---
SSE event schemas in `packages/user-platform/src/utils/api-client/sse-schemas.ts` are hand-maintained. They are NOT generated from or synced with the OpenAPI spec.

**Why:** User corrected me when I wrote a DevRev issue acceptance criterion saying "OpenAPI spec is updated accordingly so the frontend Zod schemas can be regenerated" for an SSE event change — that's wrong because SSE events aren't in the spec.

**How to apply:** When proposing backend changes that affect SSE event shapes, don't suggest the change propagates via OpenAPI → Zod sync. The frontend schemas will need to be updated by hand, independent of any OpenAPI change. Do not invoke `/syncing-zod-schemas` for SSE schemas. The same likely applies to any other hand-authored schema files in `src/utils/api-client/` that aren't referenced by the OpenAPI type generator.
