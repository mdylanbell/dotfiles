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

1. installs missing native stage-0 capabilities
2. installs mise
3. clones or updates the repository and submodules
4. runs `dfm install`
5. resolves and persists a profile/feature environment selection
6. creates a one-time, Arch-only local manager policy file when `pacman`
   is present and none exists yet
7. trusts and runs built-in mise bootstrap

Step 5 runs after `dfm install` and before the repository environment is
loaded, so the composed `MISE_ENV` it produces is available immediately for
the same `mise bootstrap` run. Each dimension resolves independently in this
order: an explicit flag, an inherited `DOTFILES_ENV` or
`DOTFILES_FEATURES`, the saved live value, then a numbered `/dev/tty` prompt
or the computed default. Flags therefore override environment variables, and
environment variables override saved values. The final validated pair is
always persisted.

The profile default is `personal`. Features default to `workstation,gui` on
macOS or graphical Linux and to `workstation` elsewhere. An empty
`DOTFILES_FEATURES` and `--features=none` both select no features.

The managed block uses conditional exports so a normal shell invocation may
still override saved values. Bootstrap unsets an inherited `MISE_ENV` and
recomputes it from the resolved profile/features before running mise.

This live selection can persist in `$XDG_CONFIG_HOME/zsh/env.local.zsh`
(normally `$HOME/.config/zsh/env.local.zsh`) only because `dfm` recursively
installs `.config/zsh` instead of symlinking the directory itself, so the
live file is real (not a symlink) and bootstrap can create or edit it
directly. Never add a corresponding `$DOTDIR/.config/zsh/env.local.zsh`
inside the repository — like the other local overrides below, it must stay
a generated, machine-local file.

Mise owns login-shell convergence through
`[bootstrap.user] login_shell = "/bin/zsh"`. Do not duplicate `/etc/shells`,
`chsh`, or login-session reminder handling in `bootstrap_env`.

The containerized bootstrap harnesses live at `tests/Dockerfile.ubuntu` and
`tests/Dockerfile.arch`; enter `tests/` and run them with `mise run ubuntu`
and `mise run arch` (see Testing below).
Both harnesses pass `--profile=personal --features=none` explicitly so
platform acceptance stays a minimal baseline instead of installing the much
larger workstation catalog that the noninteractive default would otherwise
select on headless Linux.

## Important Tools

- `dfm`: installs tracked repo contents into `$HOME` via symlinks and recursive directory installs
- `.local/bin/bootstrap_env`: main bootstrap mechanism
- `mise`: tool/runtime/task orchestrator; used here for setup, update, cleanup, and secret-render tasks

## Package Ownership and Operations

`mise` is the authoritative catalog for development tools and direct-manager
packages. Profile and feature overlays extend the base `bootstrap.packages`
declarations, and `mise bootstrap` converges both those declarations and the
configured tools. Keep package additions as direct mise `apt:`, `pacman:`,
`brew:`, `brew-cask:`, or `mas:` declarations as appropriate; do not create a
second package catalog for anything mise's direct managers can already own.

The root `Brewfile` is a second, narrower catalog reserved for packages that
need the real Homebrew CLI and Bundle semantics (for example, a custom tap
with its own trust boundary) instead of mise's direct `brew:`/`brew-cask:`
backends. It currently declares only `FelixKratz/formulae/borders`, gated
behind `OS.mac?`. Prefer a direct mise declaration first; add to the Brewfile
only when a package genuinely needs `brew`/`brew bundle` itself.

Real Homebrew is a platform _capability_, not a per-host toggle. The base
`vars.dotfiles_homebrew_enabled` defaults to the _string_ `"false"` in
`config.toml`, and the automatic `config.macos.toml`/`config.linux.toml`
platform configs set it to `"true"` and prepend the canonical Homebrew
`bin`/`sbin` paths for every macOS and Linux host. Arch/CachyOS is the one
exception: when `pacman` is present, `bootstrap_env`'s `configure_arch_policy`
creates a machine-local `config.linux.local.toml` that pins
`system_packages.managers = ["pacman"]` and
`dotfiles_homebrew_enabled = "false"`, keeping those hosts fully Brew-free
even though the Linux platform config would otherwise enable it. This is a
one-time refinement: the file is created only when it does not already
exist, and an existing file — whatever it contains — is left completely
untouched from then on and becomes user-owned; `bootstrap_env` no longer
re-validates its content on later runs. The value is
a string, not a boolean, on purpose: mise's `[vars]` merge treats a boolean
`false` as that type's zero value and silently drops it, so a boolean local
override could raise `false` to `true` across config files but could never
lower `true` back to `false` again. `tasks-homebrew.toml` compares the string
explicitly (`{% if vars.dotfiles_homebrew_enabled == "true" %}`) rather than
relying on Tera truthiness, so a typo or unexpected value fails closed
(disabled) instead of silently enabling real Homebrew. The filename matters
too: mise's `auto_env`-loaded platform tier (`config.linux.toml`) outranks a
bare `config.local.toml`, so only the matching `config.linux.local.toml`
correctly overrides it — a plain `config.local.toml` would be silently
ignored for this key even as a string.

The host operating-system manager owns native stage-0 setup and host updates.
`bootstrap_env` installs the native prerequisites needed to obtain mise, then
hands package convergence to mise. Run `mise run update` on a fully
bootstrapped host to coordinate the host manager, mise tools, package
managers, and managed content.

Update tasks are split by portability instead of an inline OS switch: the
shared `update:host` in `tasks-update.toml` is a portable no-op, and
`config.linux.toml` supplies the real implementation (`pacman`, `apt-get`,
or `dnf`, with a hard failure for an unsupported manager) — mise fully
replaces a same-named task declared in a platform config rather than
merging it, so the platform version wins on Linux while other platforms
keep the portable no-op. Leaf update tasks also call their underlying
commands directly instead of guarding them behind a `command -v` precheck:
`update:bat_cache` (`bat cache --build`) and `update:gh`
(`gh extension upgrade --all`) now fail naturally if their command happens
to be missing rather than being silently skipped, since these update tasks
assume bootstrap has already installed their prerequisites.
`update:packages:mise` runs one unfiltered
`mise bootstrap packages upgrade --yes` on Brew-enabled hosts. Omitting a
manager defaults to every configured bootstrap package and avoids errors when
an active environment has no packages for an optional manager such as
`brew-cask` or `mas`. On Linux, `update:host` has already completed the
coherent native-manager update before this task runs; on pacman hosts the
Homebrew policy disables this task entirely, avoiding selective pacman
upgrades.

Direct `brew:` and `brew-cask:` operations never depend on a `brew` executable.
mise pours bottles into the canonical Homebrew prefix itself (`/opt/homebrew`
on Apple Silicon macOS and `/home/linuxbrew/.linuxbrew` on Linux). The
platform mise configs expose each prefix through `[env] _.path`, and
`mise activate zsh` applies it to the login shell.

Homebrew's own shell startup is independent of mise activation and runs
earlier in the conf.d load order: `.config/zsh/conf.d/10-homebrew.zsh`
checks only for the two canonical `brew` executables
(`/opt/homebrew/bin/brew`, `/home/linuxbrew/.linuxbrew/bin/brew`) and
evaluates `brew shellenv` directly from whichever is present, before
`.config/zsh/conf.d/60-tools/mise.zsh` ever activates mise. mise's own
shell activation no longer touches Homebrew at all.

Antidote's plugin-manager source lives at the live path
`${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}/.antidote` — a real git
checkout, not a mise-cached location — and every surface that needs it
(`.config/zsh/conf.d/70-antidote.zsh`, `bootstrap:antidote`,
`update:antidote`, `build:fzf_tab_module`, and
`purge:antidote:legacy-source`) derives that same path inline rather than
reading a shared mise var; `.config/mise/config.toml` no longer declares a
`vars.antidote_source_dir`. `bootstrap:antidote` clones only when the
checkout is absent and always rebuilds the static plugin bundle;
`update:antidote` assumes the checkout already exists, runs a bare
`antidote update`, and rebuilds the bundle — neither falls back to
`git pull` or a bootstrap re-clone. Because `dfm` recursively installs
`.config/zsh` rather than symlinking the directory, this live checkout is a
real, non-symlinked path and needs no repository ignore rule; a contract
test guards against a repository-shadow `.antidote` reappearing instead.

`.config/mise/conf.d/tasks-homebrew.toml` owns the real-Homebrew lifecycle as
two tasks, both gated on `vars.dotfiles_homebrew_enabled`:

- `bootstrap:install-homebrew` (hidden) installs Homebrew itself with the
  official noninteractive installer, skipping when `brew` is already present.
  It installs only the capability and never touches the Brewfile.
- `homebrew:install` runs `brew bundle install --file=<repo>/Brewfile`. It has
  no dependency on, or fallback to, `bootstrap:install-homebrew` — it assumes
  bootstrap already established the capability and fails naturally through
  the shell if `brew` is missing.

`bootstrap:configure` sequences `bootstrap:install-homebrew` before
`homebrew:install` as ordered steps, not a task dependency, so bootstrap is the
one workflow responsible for installing the capability before converging the
Brewfile. `update:packages` sequences `update:packages:mise` (the existing
direct-manager upgrades) before `homebrew:install`. `clean:packages:mise`
uses mise's conservative ownership receipts to prune only removable,
mise-owned casks and naturally does nothing when none apply.

Cleanup never uses `brew bundle cleanup` or `mise bootstrap packages prune
--manager brew`, because the real Homebrew prefix is shared: mise pours its
own direct `brew:` formulae into the exact same prefix that real Homebrew
uses for Brewfile packages. `brew bundle cleanup` treats the (intentionally
minimal) Brewfile as the complete desired state for that whole prefix and
would remove every mise-owned formula; `mise bootstrap packages prune
--manager brew` treats mise's own declarations as complete and would remove
any Brewfile-installed package mise doesn't know about, taking Borders (or any
future real-Homebrew-only package) with it. Real Homebrew performs its own
routine cache and old-version cleanup during installs and upgrades.

`mise run update` intentionally mutates tracked lockfiles. `update:mise:tools`
runs `mise lock --global --bump` before `mise upgrade` so the same invocation
installs the newly locked versions under strict config-root locking; review and
commit the resulting `.config/mise/*.lock` changes.

Use the standalone `tests/mise.toml` project to exercise the operational
model. Enter `tests/` first so its early-init config is discovered:

- `mise run config` validates mise configuration and contracts.
- `mise run ubuntu` and `mise run arch` run the cached Linux
  bootstrap harnesses, proving Ubuntu ends up with a working real Homebrew
  that satisfies the root Brewfile and Arch stays Brew-free.
- `mise run linux`, `mise run macos`, and `mise run all` compose
  platform-specific coverage.
- `mise run macos:integration` additionally checks
  `brew bundle check` against the root Brewfile on a real macOS host.

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
- zsh: `.config/zsh/env.local.zsh` (also where `bootstrap_env` persists its
  profile/feature selection; see Bootstrap above) and `.config/zsh/local.zsh`
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

`tests/mise.toml` is an ordinary mise project. Declarative tasks call the
shared `tests/run-docker-bootstrap.sh` for Docker execution. macOS-only tasks
live in `tests/mise.macos.toml`; `tests/.miserc.toml` enables the early
`auto_env` discovery needed to load that file only on macOS. Enter `tests/`
before invoking mise so its early-init config is discovered:

- `mise run portable` runs the portable behavior and safety suite.
- `mise run config` validates mise task definitions, lists resolved
  configuration for both supported `MISE_ENV` combinations
  (`work,workstation,work-workstation` and `personal,gui,personal-gui`),
  and runs `mise bootstrap --dry-run`.
- `mise run ubuntu` and `mise run arch` build and run cached
  Docker bootstrap harnesses at `tests/Dockerfile.ubuntu`/
  `tests/Dockerfile.arch` (see `doc/docker-bootstrap-testing.md`).
- `mise run linux` runs Ubuntu then Arch.
- `mise run macos` runs portable and config checks on Darwin.
- `mise run macos:integration` additionally runs
  `mise bootstrap status --missing` and `brew bundle check` against the
  root Brewfile.
- `mise run all` runs portable, config, Linux, and (on Darwin) macOS
  integration.

Tests should protect public behavior, destructive-operation safety, live-file
boundaries, and clean-host acceptance. Do not extract named functions from
production scripts or assert exact implementation structure.

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
