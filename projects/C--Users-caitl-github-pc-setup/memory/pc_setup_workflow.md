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
1. Commit the changes on a new branch
2. Push and create a PR on GitHub (repo: caitlin-a/pc-setup)
3. Tell Caitlin the PR URL so she can go review it

**Why:** She wants updates tracked without having to ask, and wants a review step (PR) before changes land on main. No Stop hook — do this manually as part of normal workflow.
