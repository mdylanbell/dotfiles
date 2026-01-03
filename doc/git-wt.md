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
git-wt init <path> [remote] [--no-protect-main]
```

- Initializes the container layout under `<path>`.
- If `remote` is provided, clones into `main/`; otherwise converts an existing
  repo into the container layout.
- Installs safety hooks that block commits and pushes on `main` and `master`.
- Use `--no-protect-main` to skip safety hooks.

### `git-wt pr`

```
git-wt pr <PR_NUMBER> [slug]
```

- Creates a PR worktree under `wt/` and prints the path.
- If `slug` is omitted, it defaults to just the PR number.
- The worktree path is:

```
wt/pr-<num>[-<slug>]
```

- Uses `gh api` to fetch PR metadata based on the `origin` remote in `main/`.
- Checks out the PR head ref into a local branch named:

```
pr/<num>-<head-ref-slug>
```

- For fork PRs, creates a temporary remote named `pr-<num>` and fetches the PR
  head from the fork (SSH preferred, HTTPS fallback).
- Runs `hooks.pr_checkout` (if configured). If any hook fails, the worktree is
  removed and the command exits non-zero.
- Temporary PR remotes are cleaned up by `git-wt done` once no remaining
  worktrees reference that PR branch.
- Review mode in Neovim (see related docs) prefers the PR base branch for diffs.

### `git-wt new`

```
git-wt new [--base <branch>] <branch-name>
```

- Creates a new branch from `origin/<default>` (or `--base`) and checks it out
  to a worktree under:

```
wt/<branch-name-slug>
```

- Prints the resulting path.

### `git-wt sync`

```
git-wt sync [--prune]
```

- Fetches `origin` and fast-forwards `main/` to `origin/<default>`.
- Refuses to run if `main/` is dirty.
- `--prune` removes stale remote-tracking refs during fetch.

### `git-wt clean`

```
git-wt clean [--dry-run] [--verbose] [-i|--interactive]
```

- Removes worktrees whose branches are merged into `origin/<default>`.
- Skips `main/`, the current directory, dirty worktrees, and branches that are
  not merged.
- `--dry-run` shows what would be removed.
- `--verbose` shows why each skipped worktree was skipped.
- `-i/--interactive` prompts for each worktree removal, and optionally for
  branch deletion (default: remove worktree yes, delete branch no).

### `git-wt done`

```
git-wt done [path] [--delete-branch] [--force]
```

- Removes the worktree at `path` (defaults to current directory).
- If `--delete-branch` is set, deletes the branch after removing the worktree.
- `--force` passes through to `git worktree remove --force`.

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
