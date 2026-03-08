# git-wt Operator Reference

## Command Map

- Setup new container: `git-wt init <container_path> <remote_url>`
- Convert existing clean repo: `git-wt migrate <repo_path>`
- Create worktree from existing branch: `git-wt add <branch>`
- Create new branch + worktree: `git-wt add -b <new-branch> [--base <branch>]`
- Resolve a branch path: `git-wt path <branch>`
- Summarize worktrees: `git-wt list` or `git-wt status`
- Update main checkout: `git-wt sync [--prune]`
- Remove merged worktrees: `git-wt clean [--with-branches] [-i]`
- Remove one worktree safely: `git-wt remove [path] [--delete-branch] [--force]`
- Manage settings: `git-wt config show|get|set ...`

Note: `git-wt open <branch>` is human/editor-oriented and should be used by agents only when explicitly requested by the user.

Policy:

- `git-wt clean` is opt-in only. Run it only on explicit user instruction.
- Treat `git-wt remove` as destructive and confirm intent when ambiguous.
- Prefer `git-wt remove <path> --delete-branch` when the goal is to remove both local worktree and branch together.

## Non-PR Workflows

### Bootstrap repo in git-wt layout

Policy:

- Use `git-wt init` only when user confirms they want git-wt layout for a clone.
- Never run `git-wt migrate` unless explicitly instructed.
- If repo is not in git-wt container format and no explicit git-wt request exists, use normal git operations.

1. New clone path (with user confirmation):
   `git-wt init <container_path> <remote_url>`
2. Existing clean repo (explicit migration request only):
   `git-wt migrate <repo_path>`
3. Verify:
   `git-wt list --verbose`

### Start new branch work

1. `git-wt sync --dry-run`
2. `git-wt sync`
3. Confirm branch name strategy from context.
4. `git-wt add -b <new-branch>`

### Resume existing branch work

1. `git-wt path <branch>`
2. If missing, `git-wt add <branch>`

### Remove completed branch worktree

1. Run outside the target worktree.
2. `git-wt remove <path> --dry-run`
3. `git-wt remove <path> --delete-branch`

### Batch cleanup after merges

Run only when explicitly instructed.

1. `git-wt clean --dry-run --verbose`
2. `git-wt clean --verbose`
3. Optional branch cleanup: `git-wt clean --with-branches -i`

## Error Recovery

- `no git-wt container found`: pass `--container <path>` or run from container subtree.
- `main worktree is dirty`: inspect `main/` and commit/stash/reset before `sync`.
- `destination already exists`: remove/rename destination and rerun `add`.
- `no worktree found for branch`: create one with `git-wt add <branch>`.

## Hook Notes

- Hook names come from `git-wt.toml` under `[hooks]`.
- Failing hooks cause command failure.
- For `add`, a failing hook removes the just-created worktree automatically.
