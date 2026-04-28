---
name: analysis-service local clone
description: Local clone of the pixee/analysis-service backend repo is available at /workspaces/analysis-service — use it when investigating backend behavior or filing issues against the analysis-service team
type: reference
originSessionId: 257ea31e-072c-4d5c-ae8c-420f39c8a574
---
A local clone of `pixee/analysis-service` is available at `/workspaces/analysis-service`. Use it when:

- Tracing backend behavior that the user-platform consumes (SSE events, REST endpoints, analysis orchestration)
- Writing DevRev issues for the `analysis-service` team — reference their file paths directly instead of speaking only in frontend terms
- Verifying backend contract assumptions before proposing frontend changes

**Important:** Pull latest before reading: `git -C /workspaces/analysis-service pull --ff-only`. The clone may be stale.

The analysis-service DevRev part is **CAPL-28** (`don:core:dvrv-us-1:devo/6OglRV4a:capability/28`), owned by Dan D'Avella (DEVU-19, `don:identity:dvrv-us-1:devo/6OglRV4a:devu/19`).

Relevant backend areas seen so far:
- SSE streaming layer: `src/pixee_analysis_service/streaming/`
- Workflow / result handlers: `src/pixee_analysis_service/workflow/`
- Main FastAPI app / routes: `src/pixee_analysis_service/app.py`
