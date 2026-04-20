# Repository Guidelines

## Project Structure & Module Organization

- `lua/pier/`: core plugin modules. `init.lua` owns command/session orchestration; `git.lua`, `github.lua`, and `context/git_wt.lua` hold review-target resolution; `core/` and `integrations/` isolate third-party editor integrations.
- `.luarc.json`: LuaLS config for this plugin workspace. Keep it plugin-focused; do not mirror dynamic editor-only workspace behavior unless there is a clear reason.
- `tests/`: isolated headless Neovim + busted harness. `minimal_init.lua` sets runtimepath, `run.sh` runs the suite, and `spec/` contains test files.

## Core Workflow

- This is a local Neovim plugin inside a dotfiles repo. Keep changes scoped to `pier.nvim` unless the task explicitly requires touching shared Neovim config.
- Prefer small, behavior-focused edits. Avoid broad refactors while changing review/session behavior unless they directly reduce risk for the task at hand.
- Preserve the current separation between:
  - pure/path logic in `git.lua` and `context/git_wt.lua`
  - session/command logic in `init.lua`
  - third-party integrations in `core/` and `integrations/`

## Build, Lint, and Test Commands

- Format Lua files:
  - `stylua --config-path /home/matt/.dotfiles/.config/nvim/stylua.toml <file>`
- Format shell files:
  - `shfmt -w -i 2 -ci -bn <file>`
- Check LuaLS diagnostics for the plugin:
  - `cd /home/matt/.dotfiles && ~/.local/share/nvim/mason/bin/lua-language-server --check=.config/nvim/local-plugins/pier.nvim --check_format=pretty --checklevel=Warning --force-accept-workspace`
- Run the plugin test suite:
  - `/home/matt/.dotfiles/.config/nvim/local-plugins/pier.nvim/tests/run.sh`

## Quality Gates

- After each meaningful edit cycle, rerun the narrowest relevant verification commands before continuing.
- Before claiming work is complete, run all applicable quality gates for the touched surface:
  - formatting for changed files
  - `lua-language-server --check` for `pier.nvim`
  - `tests/run.sh`
- Do not weaken diagnostics or delete coverage to make checks pass. Fix code or tests instead.
- If a gate cannot be run, state that explicitly and explain why.

## Coding Style & Editing Conventions

- Lua style:
  - 2-space indentation
  - double quotes
  - module table `M`
  - explicit local helpers over large inline blocks
- Prefer EmmyLua annotations when they clarify session state, integration contracts, or dynamic third-party boundaries.
- When LuaLS cannot infer a safe narrowed type, prefer explicit guards or `---@cast` over reshaping logic unnecessarily.
- Keep third-party API assumptions localized. If Diffview, Octo, gitsigns, or mini.diff return dynamic objects, guard those accesses rather than assuming a fully typed shape.

## Testing Guidance

- The test harness is intentionally isolated from your normal Neovim environment:
  - headless `nvim --clean`
  - temp `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME`, and `XDG_CACHE_HOME`
  - plugin path added directly to `runtimepath`
- Tests use busted via Plenary's `PlenaryBustedDirectory`.
- Prefer unit-heavy specs first:
  - path parsing
  - git-wt container detection
  - PR/worktree target resolution
  - session-state transitions
- Add integration-style tests only when behavior depends on Neovim command registration, buffer state, or runtime interactions that unit tests cannot cover.
- New specs should live under `tests/spec/` and follow the current `*_spec.lua` pattern.
- Prefer temporary directories and stubs over live external dependencies. Do not rely on the user's real worktrees, GitHub auth, or interactive plugins during tests.

## Integration Boundaries

- `core/diffview.lua` and `core/octo.lua` are wrappers around optional plugins. Keep failure handling graceful and test the wrapper behavior rather than the full third-party UI.
- `integrations/` modules should remain small and reversible. Capture/apply/restore logic must tolerate missing plugins and partial state.
- If adding a new integration, include:
  - clear failure behavior when the dependency is absent
  - a focused unit or harness test for the integration contract when practical
  - any needed LuaLS config updates only if the dependency meaningfully changes static analysis requirements

## Agent-Specific Notes

- Prefer `rg` for search and keep file reads targeted.
- Use `apply_patch` for manual edits.
- Do not add repo-level tests outside `pier.nvim/tests` for plugin-specific behavior.
- If you change commands, test harness behavior, or lint expectations, update this file in the same change.
