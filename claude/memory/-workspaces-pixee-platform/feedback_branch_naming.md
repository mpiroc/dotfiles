---
name: Branch naming convention for issue branches
description: When creating a branch for a DevRev issue, preserve the capitalized ISS- prefix and append a short kebab-case title
type: feedback
originSessionId: 54f83f74-5173-4665-adaf-4dced819ff81
---
When creating a git branch for a DevRev issue, the branch name must:
1. Preserve the capitalized issue ID prefix (e.g. `ISS-6811`, not `iss-6811`)
2. Include a short kebab-case descriptive title derived from the issue's title after the ID (e.g. `ISS-6811-fix-bitbucket-workspaces-endpoint`)

**Why:** The user corrected me after I created `iss-6811` — they want the capitalization preserved and the title included so the branch is self-describing without needing to look up the issue.

**How to apply:** Before running `git checkout -b`, fetch the DevRev issue title (via `mcp__devrev__get_issue`) and build the branch name as `ISS-XXXX-<kebab-case-title>`. Keep the title short — drop filler words if needed.
