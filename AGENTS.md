# Dotfiles Agent Guide

This repository is a personal dotfiles repo managed with `dfm`.

## Core Model

The repo lives at `~/.dotfiles` and is not itself the live config tree.

`dfm` is the mechanism that maps tracked files from this repo into `$HOME`.

Default behavior is simple:

- if a tracked path is not marked `skip` or `recurse` in `.dfminstall`, `dfm` symlinks it into the corresponding location under `$HOME`
- `skip` keeps the tracked file only in the repo
- `recurse` means `dfm` creates the target directory and installs the contents entry-by-entry instead of symlinking the directory itself

Examples:

- repo paths like `.config/zsh/.zshrc` are symlinked into `$HOME/.config/zsh/.zshrc`
- repo paths like `.local/bin/bootstrap_env` are symlinked into `$HOME/.local/bin/bootstrap_env`
- top-level paths like `.zshenv` are symlinked into `$HOME/.zshenv`

This mapping is controlled by `.dfminstall` files:

- `.dfminstall` files work the same way at the repo root and inside subdirectories
- the file applies to entries in its own directory
- root `.dfminstall` governs top-level repo entries
- nested `.dfminstall` files govern entries inside that subtree after recursion reaches it

Read `.dfminstall` and nested `.dfminstall` files before changing how a path is installed.

## Bootstrap

`.local/bin/bootstrap_env` is the main machine bootstrap mechanism.

It is primarily for first-time machine or environment initialization, not a routine day-to-day command. It should remain accurate, deterministic, and error free because it is the path used to stand up a new environment from scratch.

At a high level it:

1. loads the repo XDG/env setup
2. installs base system dependencies
3. installs Homebrew/Linuxbrew if needed
4. clones or updates the dotfiles repo
5. runs `dfm install`
6. runs `brew bundle`
7. runs `mise install`, `mise run setup`, and `mise run secrets:render`

There is also a containerized bootstrap harness in `Dockerfile.test.local`. It may lag slightly behind day-to-day bootstrap behavior, but it is the repo’s explicit bootstrap test artifact and worth keeping in mind before large bootstrap changes.

## Important Tools

- `dfm`: installs tracked repo contents into `$HOME` via symlinks and recursive directory installs
- `.local/bin/bootstrap_env`: main bootstrap mechanism
- `mise`: tool/runtime/task orchestrator; used here for setup, update, cleanup, and secret-render tasks

## Filesystem Conventions

- Prefer XDG locations where the tool supports them:
  - `XDG_CONFIG_HOME` -> `~/.config`
  - `XDG_DATA_HOME` -> `~/.local/share`
  - `XDG_STATE_HOME` -> `~/.local/state`
  - `XDG_CACHE_HOME` -> `~/.cache`
- Do not force XDG placement when a tool does not support it cleanly; use the least-bad conventional fallback in that case
- Keep tracked source/config templates in the repo
- Keep generated machine-local files out of git
- For secret-backed configs:
  - tracked template lives in the repo
  - generated secret file lives in the real XDG path under `$HOME`
  - `.gitignore` should protect the repo-shadow path if the generated file ever appears there
  - new secret-backed configs should add explicit render/clean tasks in `.config/mise/conf.d/tasks-secrets.toml`

## Local Overrides

This repo already supports machine-local overrides in a few places:

- git: `.config/git/config.local`
- zsh: `.config/zsh/env.local.zsh` and `.config/zsh/local.zsh`
- tmux: `.config/tmux/local.conf`
- mise local files are ignored through git ignore rules

Do not commit local override files. If you add a new local-override mechanism, also add ignore protection and, if appropriate, a small contract test.

## Testing

Shell tests live in `tests/`.

Run the full suite with:

```bash
bash tests/run_all.sh
```

Also validate `mise` task definitions with:

```bash
mise tasks validate
```

## Formatting Conventions

Write files to match the formatter behavior configured in this repo so opening them in Neovim does not cause avoidable formatting churn.

Prefer these commands and their resulting style:

- Shell (`.sh`, bash, sh):
  - `shfmt -w -i 2 -ci -bn <file>`
- Lua:
  - `stylua --config-path .config/nvim/stylua.toml <file>`
- JSON / JSONC / JSON5:
  - `prettier --write <file>`
  - use standard pretty-printed JSON with 2-space indentation
- YAML:
  - `prettier --write <file>`
- Markdown:
  - `prettier --write <file>`
  - note: Neovim may also involve `markdownlint-cli2` and `markdown-toc`
- TOML:
  - `taplo format <file>`
- Python:
  - `ruff format <file>`
  - `ruff check --fix --select I <file>`
  - prefer Ruff-compatible formatting, including import sorting

Shell formatting is explicitly overridden in this repo, and Lua formatting comes from `.config/nvim/stylua.toml`. JSON, YAML, Markdown, and TOML behavior are inherited from the current LazyVim/conform setup plus enabled extras. Python is configured around Ruff in this repo, so prefer Ruff-style output.

Formatting conventions should agree with the active Neovim configuration unless there is a strong reason to preserve an existing local style in a specific file.

## Editing Guidance

- Preserve the distinction between tracked repo files and generated/local files
- Do not casually change `.dfminstall` behavior; it changes what appears in `$HOME`
- If you add a new config subtree, decide explicitly whether it should be symlinked, recursively installed, or skipped
- If you add a new local override pattern, add matching `.gitignore` protection
- If you add a new secret-backed config, keep the `mise` task focused and app-specific
- Prefer small structural shell tests for invariants like bootstrap flow, `dfm` scope, env defaults, and local override contracts
