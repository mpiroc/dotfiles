---
name: figma-console-mcp doesn't fit Codespaces-primary use
description: Why the figma plugin in this repo intentionally does NOT include figma-console-mcp config, despite the gap being noticed
type: project
originSessionId: 71836c3e-2b1e-464e-bcbf-7167f152b02d
---
The `figma` plugin in `pixee-internal-claude-plugins` configures only the official Figma MCP server (`mcp.figma.com`, OAuth). Adding the third-party `southleft/figma-console-mcp` was considered and explicitly rejected on 2026-04-29.

**Why:** The user's primary Figma-skill use case is Codespaces. figma-console-mcp's value-add (write tools, real-time selection tracking, document change monitoring, console log streaming) all depend on the Desktop Bridge plugin running inside Figma Desktop and reachable via WebSocket on `localhost:9223–9232` — which is unreachable from a codespace. Without Desktop, the NPX server still serves REST-API-backed read tools (`figma_get_file_data`, `figma_get_variables`, `figma_get_design_system_kit`), but those overlap heavily with what the official server already provides via OAuth. Net value in Codespaces was judged not worth the extra `npx` runtime dep, the broader PAT scopes (Variables read + Comments read/write), and the inconsistent auth scheme (OAuth for official server, PAT for figma-console).

The OAuth-consistent alternative (figma-console SSE endpoint via `mcp-remote`) was also rejected: it drops to 9 read-only tools, which adds essentially nothing on top of the official server.

**How to apply:** If asked to add figma-console (or any other third-party Figma MCP server) to this plugin, surface the Codespaces/no-Desktop limitation up front before proposing a config. Don't re-propose the change without new information (e.g., user starts running Figma Desktop locally with port forwarding, or upstream ships an OAuth + Desktop-Bridge-free path).
