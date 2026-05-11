---
name: pc-setup-workflow
description: "How to handle README updates, commits, and PRs for the pc-setup repo"
metadata: 
  node_type: memory
  type: project
  originSessionId: 1160ebae-aa29-491d-9a66-64bb8cb28599
---

The pc-setup repo (https://github.com/caitlin-a/pc-setup) documents Caitlin's Windows PC configuration so she can replicate it on a new machine.

**Tracking updates:** During any conversation, watch for new tools, software, or programs being installed or used that aren't in the README. Flag them and offer to update the README.

**After editing README.md:**
1. Show Caitlin the changes (she sees the diff inline from the Edit tool)
2. Ask for approval before committing
3. On approval: commit and push directly to main (no branches, no PRs)

**Why:** She wants a review step before changes are committed, but doesn't need the overhead of PRs and branches. No Stop hook — do this manually as part of normal workflow.
