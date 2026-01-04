# Git Worktree PR Review Workflow

This document describes the standard PR review flow using `git-wt`, `gh-dash`,
and Neovim review mode.

For git-wt command details, see `doc/git-wt.md`.

---

## Goals

- Review PRs locally with full editor tooling
- Avoid branch juggling in a single working tree
- Keep `main/` clean and stable
- Make reviews fast to start and easy to discard

---

## Repository layout

```
<repo>/
  main/        # canonical checkout (tracks default branch)
  wt/          # PR and task worktrees
```

---

## PR review flow

### 1) Find a PR

Use `gh-dash` as the review inbox.

### 2) Create a PR worktree

From anywhere inside the container or `main/`:

```bash
git-wt pr checkout 1234 search
```

This prints the created worktree path, for example:

```
wt/pr-1234-search
```

### 3) Open Neovim in review mode

From inside the PR worktree:

```bash
cd wt/pr-1234-search
nvimr
```

What happens automatically:

- `:ReviewPR` runs at startup
- Diffview opens against the PR base branch (`<base>...HEAD`)
- Octo PR view opens in a separate tab

### 4) Review the code

Recommended flow:

- Start in Diffview for a PR-wide scan
- Dive into files for deeper reads
- Use inline review tooling as needed (Octo)

---

## Review shortcuts

### Dashboard review picker

From the container root, open Neovim and use the dashboard shortcut:

- Press `R` to open the PR worktree picker
- Select a PR to open the review tabs for that worktree

You can also run:

```
:ReviewPR
```

If you run `:ReviewPR` outside a git-wt container, it will warn and exit.

### Leader key review group

Inside a git-wt container, the review group is available under:

```
<leader>R
```

---

## Cleanup

When a review is finished, remove the worktree:

```bash
git-wt remove wt/pr-1234-search
```

If the branch should be deleted too:

```bash
git-wt remove wt/pr-1234-search --delete-branch
```

---

## Mental model

- Worktrees are disposable environments
- `main/` is sacred and boring
- Reviews start in Diffview, not in files
- Cleanup is part of the workflow, not an afterthought
