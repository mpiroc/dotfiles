---
name: Align spec and issue before planning implementation — spec via report, issue via MCP
description: For spec-driven features with material ambiguities, the plan may target artifact improvements (spec + DevRev issue) rather than implementation. Produce a spec-update report for the external product-os agent, but apply DevRev issue updates directly via MCP — don't generate an issue-update report.
type: feedback
originSessionId: 2ee8f8e0-dad5-4e21-9a61-0ac9a9cf69d0
---
When a feature is driven by an external design spec (e.g. `pixee/product-os/design/specs/*.md`) and/or a DevRev issue, the user may want the *entire plan* to focus on **improving those artifacts** rather than planning implementation. Implementation planning is deferred to a follow-up round, after the spec and issue are updated.

**Why:** The user runs a separate spec-editing agent (in the `product-os` repo) that takes a written report as input. DevRev issues, on the other hand, can be updated directly by the Claude Code session via `mcp__plugin_devrev_devrev__update_issue` — producing a "report" for the issue is redundant make-work when the update can just be applied. Producing authoritative, unambiguous artifacts before implementation means implementation planning can start from clean inputs — avoiding the decay loop where each future developer re-litigates the same ambiguities.

The user has said (paraphrased, 2026-04-24):
> *"The entire plan should be a plan for improving the spec and the devrev issue, not a plan for actual implementation."*
> *"For the devrev issue updates, you can just make the updates yourself instead of generating a report."*

**How to apply:**
- If planning surfaces ≥1 material ambiguity, contradiction, or missing detail in the spec/issue, default to producing an **artifact-improvement plan** rather than an implementation plan. Ask the user if unsure.
- **Spec updates** → produce a standalone markdown **report** and store it at a **regular location** — typically the repo root, e.g. `/workspaces/user-platform/ISS-XXXX-spec-updates.md`. **Do not** put it in `/home/node/.claude/plans/` — that directory is reserved for plan files only, not deliverable documents. For each change: quote what the spec currently says, state the resolution and decision source ("Figma confirms…", "user decision on YYYY-MM-DD"), propose exact new wording. Call out consequential edits (Acceptance Criteria cascades, user-flow diagrams, etc.). Include a "correct as-is" section. This report is the input for the product-os spec-editing agent.
- **DevRev issue updates** → **apply directly via `mcp__plugin_devrev_devrev__update_issue`** during plan execution (after `ExitPlanMode`). Do NOT produce any separate file for the issue updates — no report, no draft file, nothing at a regular location. If the drafted body needs to persist through planning (for visibility or to survive context compression), put it **inline in the plan file** under a section describing what the MCP call will apply. The plan file is the plan, not "a document for the issue updates" — that distinction matters to the user. Capture any field changes (priority, part, tags, etc.) alongside the body in the same plan section.
- **General principle:** when you can apply a change yourself via an available tool, do so. Reports are for cases where someone/something else applies them (e.g., external product-os agent, user pasting into a system you don't have tool access to).
- The meta-plan file summarizes both streams and their application paths, then defers implementation to a future round.
- Do not call `ExitPlanMode` with an implementation plan if the user has redirected you to artifact improvements.
