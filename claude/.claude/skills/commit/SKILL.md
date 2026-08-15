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
8. Show the proposed commit message.
9. Ask the user:
   "Confirm commit? [y/n]"
10. Wait for the user's response.
11. If the user responds with "y" or "yes":
    - Immediately run:
      git commit -m "<proposed commit message>"
    - Do not ask for any further confirmation.
12. If the user responds with "n" or "no":
    - Cancel the commit.
