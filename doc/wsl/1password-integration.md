# WSL 1Password Integration

## Decisions

- WSL uses Windows `op.exe` directly through WSL interoperability.
- WSL does not install Linux `1password-cli`; [`config.wsl.toml`](/home/matt/.dotfiles/.config/mise/config.wsl.toml) disables it.
- `mise` selects the CLI via `OP_COMMAND`, with the base config using `op` and WSL overriding to `op.exe`.
- `OP_*` environment variable names are forwarded to Windows processes through `WSLENV`.

## Rationale

- Calling `op.exe` directly is simpler than maintaining a wrapper script in the repo.
- Selecting the command in `mise` env avoids repeating WSL detection in secret-rendering tasks.
- Exporting `WSLENV` in both WSL shell config and WSL bootstrap tasks keeps `op.exe` behavior consistent in interactive shells and non-interactive `mise` runs.

Source material:
- <https://github.com/Swage590/1Password-CLI-WSL-Integration/tree/main>
- <https://developer.1password.com/docs/ssh/integrations/wsl/>
