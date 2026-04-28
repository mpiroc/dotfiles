---
name: Orphan means zero references, not self-references
description: When determining if files are orphaned, self-references and internal cross-references within the group don't count as external usage — but they also don't make something orphaned. A Storybook story file is never orphaned just because an MDX doc that embedded it was deleted; it still renders on its own.
type: feedback
---

A file is only orphaned if NOTHING references it AND it serves no standalone purpose. Storybook `.stories.tsx` files are standalone — they render in Storybook independently of any MDX overview page. Deleting an MDX that embeds stories does NOT orphan those stories.

**Why:** User was frustrated when I deleted 12 working story files + components that were self-contained, just because the MDX overview that referenced them was being removed. The stories still serve their own purpose.

**How to apply:** Before deleting files claimed to be "orphaned," ask: does this file have standalone value (e.g., it's a Storybook story, a test, an entry point)? If yes, it's not orphaned regardless of what was deleted. Only delete files that truly have no purpose without their parent reference.
