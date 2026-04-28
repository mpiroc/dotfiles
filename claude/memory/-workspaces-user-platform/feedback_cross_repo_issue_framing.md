---
name: Frame cross-repo issues in the target team's codebase
description: When filing a DevRev issue for another team, ground the issue in their repo — file paths, symbol names, acceptance criteria in their codebase — not the consumer's
type: feedback
originSessionId: 257ea31e-072c-4d5c-ae8c-420f39c8a574
---
When creating a DevRev issue that asks another team to change their service, frame the body in terms of **their** codebase: specific file paths, specific function/class names, and acceptance criteria they can tick off within their own repo. The consumer-side context belongs at the bottom as "why" — not as the meat of the issue.

**Why:** User pushback ("The way this issue is written, it almost sounds like a user-platform change. The focus should instead be on analysis service.") when I drafted an issue for the analysis-service team using only user-platform file paths and frontend Zod schema references. The assignee opens the issue expecting concrete pointers into their own repo.

**How to apply:**
- Before drafting the issue body, locate the target service's repo and read the relevant code. For analysis-service, there is a local clone at `/workspaces/analysis-service`. Pull latest before reading.
- Lead with: the target team's file paths, the specific symbols (Python Pydantic / TypedDict / function / route) that need to change, and acceptance criteria evaluable in their repo (e.g. "tests in `tests/test_foo.py` assert the new field").
- Relegate the consumer-side context to a brief "why"/"consumer context" section at the end — enough to justify the ask, not enough to sound like the issue is about the consumer.
- This applies regardless of direction (frontend filing on backend, backend filing on frontend, either side filing on a shared service).
