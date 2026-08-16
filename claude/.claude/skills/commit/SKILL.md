---
name: commit
description: Generate accurate git commit messages by re-reading the current staged diff.
---

Procedure

1. Ignore any previous assumptions about the changes.
2. Run:
   git status
3. Verify there are staged files.
4. Run:
   git diff --cached
5. Read the entire staged diff.
6. If the staged diff is empty:
   - Tell the user there is nothing to commit.
   - Stop.
7. Generate a concise commit message that reflects ALL staged changes.
8. Run immediately — do not ask the user to confirm first:
   git commit -m "<proposed commit message>"
