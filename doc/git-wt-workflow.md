# Git Worktree–Based PR Review Workflow

This document describes the **standard local PR review workflow** using:

- `git-wt` (worktree orchestration)
- `gh` + `gh-dash` (PR discovery and checkout)
- Neovim (LazyVim) with **work mode** vs **review mode**
- Diffview + Octo for in-editor review
- Poetry + direnv for monorepo environments

It is intended as a **practical reference** while building muscle memory.

---

## Goals

- Review PRs locally with **full IDE features** (LSP, tests, navigation)
- Avoid branch juggling and repo pollution
- Keep `main` clean and stable
- Make reviews disposable, fast to start, and fast to clean up
- Work naturally with a large Poetry-based monorepo

---

## Repository Layout (Container Model)

Each repository lives in a **container directory**:

```
~/code/work/<repo>/
  main/        # canonical checkout (always clean, tracks main)
  wt/          # all worktrees (PRs, tasks)
```

Examples:

```
wt/pr-1234-some-slug/
wt/JIRA-456-some-feature/
```

Rules:

- **Never do feature work in `main/`**
- Every PR or task gets its **own worktree**
- Worktrees are disposable

---

## Tooling Overview

### `git-wt`

Single entrypoint for all worktree operations:

- `git-wt init`
- `git-wt pr`
- `git-wt new`
- `git-wt env`
- `git-wt prepare`
- `git-wt done`

Internally uses:

- `git worktree`
- `gh-worktree` extension

### Neovim Modes

- **Work mode**: `nvim`
  - gitsigns enabled
- **Review mode**: `nvimr` (`NVIM_REVIEW=1 nvim`)
  - mini.diff enabled
  - gitsigns disabled
  - Diffview auto-opens for PR worktrees

---

## Initial Setup (One Time)

### Initialize / Upgrade a Repo to Container Layout

If the repo already exists as a normal clone:

```bash
git-wt init ~/code/work/repoA
```

If cloning fresh:

```bash
git-wt init ~/code/work/repoA git@github.com:ORG/repoA.git
```

Result:

```
repoA/
  main/
  wt/
```

---

## Reviewing a Pull Request

### 1. Discover PRs

Use `gh-dash` as the review inbox.

### 2. Create a PR Worktree

From anywhere inside the repo container or `main/`:

```bash
git-wt pr 1234 some-slug
```

This creates:

```
wt/pr-1234-some-slug/
```

The command prints the path (useful for gh-dash actions).

### 3. Enter Review Mode in Neovim

```bash
cd wt/pr-1234-some-slug
nvimr
```

What happens automatically:

- Review mode is enabled
- Diffview opens with:

  ```
  origin/main...HEAD
  ```

- You start in a PR-wide diff view

### 4. Review the Code

Recommended flow:

1. Scan the PR in **Diffview**
2. Jump into files to read code normally
3. Use **mini.diff overlay** for in-file change context
4. Comment inline using **Octo** when needed
5. Submit review (comment / approve / request changes) via Octo

Notes:

- Diffview is easy to close if opened accidentally
- Octo does **not** auto-open by design (invoke it when ready)

---

## Monorepo: Preparing Python Environments

### Why This Exists

- LSP requires component venvs to exist
- Monorepo has many nested Poetry projects
- Manual `cd` + `direnv allow` + `poetry install` is tedious

### Trusted Auto-Allow

`git-wt prepare` automatically runs:

```bash
direnv allow
```

**only** inside `~/code/work/**`.

You usually don’t need to run this manually; it’s called by other commands.

### Bootstrap Environments for a PR

From inside a PR worktree:

```bash
git-wt env
```

What this does:

1. Diffs against `origin/main...HEAD`
2. Finds **nearest parent directory containing `pyproject.toml`** for each changed file
3. Deduplicates components
4. For each component:
   - `direnv allow`
   - `poetry install`

This makes LSP/navigation usable without manually visiting each component.

Notes:

- This is **manual by design** (run once per PR)
- If a PR touches many components, you stay in control
- Shared libs without a `pyproject.toml` are intentionally skipped

---

## Creating a Feature / Task Worktree (Non-PR)

For arbitrary branch names:

```bash
git-wt new JIRA-456-some-feature
```

Creates:

```
wt/JIRA-456-some-feature/
```

Then:

```bash
cd wt/JIRA-456-some-feature
nvim
```

---

## Cleaning Up

When a PR or task is finished:

```bash
git-wt done wt/pr-1234-some-slug
```

Optionally delete the branch too:

```bash
git-wt done wt/pr-1234-some-slug --delete-branch
```

Rules:

- **Always remove the worktree before deleting the branch**
- Worktrees are meant to be deleted once the work is done

---

## Key Mental Models

- A **worktree is a disposable execution environment**
- `main/` is sacred and boring
- Reviews start in Diffview, not in files
- Environments are bootstrapped intentionally, not magically
- Cleanup is part of the workflow, not an afterthought

---

## Common Commands (Cheat Sheet)

```bash
git-wt init <repo-path> [remote]
git-wt pr <PR#> [slug]
git-wt new <branch-name>
git-wt env
git-wt done <path> [--delete-branch]
nvim        # work mode
nvimr       # review mode
```

---

## Final Note

This workflow is designed to scale:

- across many repos
- across large PRs
- across long-lived monorepo components

If something feels slow or noisy, it’s almost always fixable **without** abandoning the model—tune the automation, don’t give up the structure.
