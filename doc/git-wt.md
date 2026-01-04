# git-wt

This document is the canonical reference for the git-wt worktree workflow.

---

## Concepts

### Container layout

Each repository lives in a **container directory** with two fixed subfolders:

```
<repo>/
  main/        # canonical checkout (tracks default branch)
  wt/          # all worktrees
```

### Default branch

git-wt uses `origin/HEAD` to resolve the default branch. If `origin/HEAD` is not
set, it falls back to `main`.

---

## Commands

### `git-wt init`

```
git-wt init [--protect-default=chain|false] <path> <remote>
```

- Initializes the container layout under `<path>`.
- Clones `remote` into `main/` and creates `wt/`.
- Installs safety hooks that block commits and pushes on the default branch.
- If hooks already exist in `main/.git/hooks`, `init` fails unless you pass:
  - `--protect-default=chain` to wrap existing hooks, or
  - `--protect-default=false` to skip protection hooks.

### `git-wt migrate`

```
git-wt migrate [--protect-default=chain|false] <repo_path>
```

- Converts an existing **clean** repo into the container layout.
- Refuses to migrate linked worktrees (`.git` is a file), bare repos, dirty repos,
  or nested containers.
- Moves the repo to `main/` and creates `wt/`.
- Hook behavior matches `git-wt init` (see above).

### `git-wt pr`

```
git-wt pr checkout [--container <path>] <PR_NUMBER> [slug]
git-wt pr update [--container <path>] <PR_NUMBER>
git-wt pr update [--container <path>] --all
git-wt pr reset [--container <path>] <PR_NUMBER> [--force]
git-wt pr recreate [--container <path>] <PR_NUMBER> [--force]
git-wt pr info [--container <path>] <PR_NUMBER> [--fetch]
git-wt pr info [--container <path>] --all [--fetch]
```

- `checkout` creates a PR worktree under `wt/` and prints the path.
- If `slug` is omitted, it defaults to just the PR number.
- The worktree path is:

```
wt/pr-<num>[-<slug>]
```

- Uses `gh api` to fetch PR metadata based on the `origin` remote in `main/`.
- Checks out the PR head ref into a local branch named:

```
pr/<num>
```

- For fork PRs, creates a temporary remote named `pr-<num>` and fetches the PR
  head from the fork (SSH preferred, HTTPS fallback).
- Runs `hooks.pr_checkout` (if configured) during `checkout`. If any hook fails, the worktree is
  removed and the command exits non-zero.
- Temporary PR remotes are cleaned up by `git-wt remove` once no remaining
  worktrees reference that PR branch.
- Review mode in Neovim (see related docs) prefers the PR base branch for diffs.

`update` fast-forwards the checked-out PR worktree:

- Refuses if the PR worktree is dirty.
- Refuses if the update is not fast-forwardable.
- `--all` updates all checked-out PR worktrees in the container.

`reset` hard-resets the checked-out PR worktree to the PR head:

- Refuses if the PR worktree is dirty unless `--force` is set.
- Shows a confirmation prompt before running the reset.

`recreate` removes any existing PR worktree and recreates it from PR head:

- Works whether or not a PR worktree currently exists.
- Refuses if the PR worktree is dirty unless `--force` is set.
- Shows a confirmation prompt before removing and re-checking out the worktree.

`info` prints PR context for a single PR or all checked-out PR worktrees:

- Shows title, author, head/base refs, worktree path, and status vs PR head.
- `--fetch` updates PR refs before reporting status.

---

## Workflows and Recovery

This section covers common workflows and recovery scenarios. Each entry has a
context and a resolution path.

### PR branch was rebased (update fails)

Context:
- `git-wt pr update <num>` says the update is not fast-forwardable.

Resolution:
1) If you want to keep the same worktree path, run:
   - `git-wt pr reset <num>` (add `--force` if the worktree is dirty).
2) If you want a clean rebuild, run:
   - `git-wt pr recreate <num>` (add `--force` if the worktree is dirty).

### PR head branch was renamed upstream

Context:
- The PR’s head branch name changed on GitHub.

Resolution:
- `git-wt pr update/reset/recreate` always use fresh PR metadata, so rerun the
  desired command. The internal branch name remains `pr/<num>`.

### Worktree directory deleted, branch still exists

Context:
- The worktree folder was removed manually, but the local branch remains.

Resolution:
1) Recreate a worktree from the branch:
   - `git-wt add <branch>`
2) If you want to delete the branch instead, delete it manually.

### Worktree path conflicts

Context:
- `git-wt pr checkout` or `git-wt add` reports that the destination path already
  exists.

Resolution:
1) Remove or rename the existing directory.
2) Re-run the command.

### `git-wt add`

```
git-wt add [--container <path>] <branch>
git-wt add [--container <path>] -b <new-branch> [--base <branch>]
```

- For existing branches, checks out the worktree under:

```
wt/<branch-name-slug>
```

- With `-b`, creates a new branch from `origin/<default>` (or `--base`) and
  checks it out to a worktree under:

```
wt/<branch-name-slug>
```

- Prints the resulting path.

### `git-wt sync`

```
git-wt sync [--container <path>] [--prune]
```

- Fetches `origin` and fast-forwards `main/` to `origin/<default>`.
- Refuses to run if `main/` is dirty.
- `--prune` removes stale remote-tracking refs during fetch.

### `git-wt clean`

```
git-wt clean [--container <path>] [--dry-run] [--verbose] [--prune] [--with-branches] [-i|--interactive]
```

- Removes worktrees whose branches are merged into `origin/<default>`.
- Skips `main/`, the current directory, dirty worktrees, and branches that are
  not merged.
- `--dry-run` shows what would be removed.
- `--verbose` shows why each skipped worktree was skipped.
- `--prune` runs `git worktree prune` before scanning.
- `--with-branches` deletes merged branches that are not checked out.
- `-i/--interactive` prompts for each worktree removal, and for branch deletions
  when used with `--with-branches`.

### `git-wt remove`

```
git-wt remove [path] [--container <path>] [--delete-branch] [--force]
```

- Removes the worktree at `path` (defaults to current directory).
- `--container` lets you target a container even when invoked elsewhere.
- If `--delete-branch` is set, deletes the branch after removing the worktree.
- `--force` passes through to `git worktree remove --force`.
- If the worktree path is missing, `remove` errors and does not infer a branch.
  Delete the branch manually if needed.

---

## Hooks

Hooks allow repo-specific automation after PR worktrees are created.

### Configuration

Create `git-wt.toml` in the container root:

```toml
[hooks]
pr_checkout = ["poetry-install-changed"]

[hooks.poetry-install-changed]
direnv_allow = false
```

### Behavior

- Hooks run **serially** after a PR worktree is created.
- Hooks must exist at:

```
~/.local/libexec/git-wt/hooks/<hook-name>
```

- Missing or non-executable hooks cause `git-wt pr` to fail.
- Hooks run with `cwd` set to the new worktree.
- Hook failure removes the worktree and exits non-zero.

### Built-in hook: `poetry-install-changed`

Purpose:

- For monorepos with multiple Poetry projects, install only the components
  affected by the PR.

Rules:

- Diff base: `origin/<default>...HEAD`
- Triggers on changes to:
  - `*.py`, `*.pyi`
  - `pyproject.toml`, `poetry.lock`, `poetry.toml`
- For each changed file, walks upward to the nearest `pyproject.toml` and
  runs `poetry install` for that component.
- If `direnv_allow = true`, runs `direnv allow` in each component that has
  `.envrc`.

---

## Related docs

- `doc/git-wt-pr-review-workflow.md` for the PR review flow and Neovim usage.
