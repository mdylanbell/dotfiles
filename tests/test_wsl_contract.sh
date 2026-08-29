#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_file ".config/mise/config.wsl.toml"
assert_contains ".config/mise/config.wsl.toml" 'disable_tools = ["1password-cli"]'
assert_contains ".config/mise/config.wsl.toml" 'OP_COMMAND = "op.exe"'
assert_contains ".config/mise/config.wsl.toml" '_.source = "{{ config_root }}/.config/mise/scripts/wsl-env.sh"'

assert_file ".config/mise/conf.d/tasks-bootstrap.toml"
assert_order ".config/mise/conf.d/tasks-bootstrap.toml" '"bootstrap:for_env"' '"bootstrap:secrets"'

assert_file ".config/mise/conf.d/tasks-secrets.toml"
assert_contains ".config/mise/conf.d/tasks-secrets.toml" '"$OP_COMMAND" inject'

assert_file ".config/mise/scripts/wsl-env.sh"
assert_contains ".config/mise/scripts/wsl-env.sh" 'append_wslenv_var'
assert_contains ".config/mise/scripts/wsl-env.sh" 'append_wslenv_var "DOTFILES_1PASSWORD_VAULT"'
assert_contains ".config/mise/scripts/wsl-env.sh" '/^OP_/ && $1 != "OP_COMMAND" {print $1}'

assert_file ".config/zsh/conf.d/os/wsl/10-1password.zsh"
assert_contains ".config/zsh/conf.d/os/wsl/10-1password.zsh" 'alias ssh-add="ssh-add.exe"'
assert_contains ".config/zsh/conf.d/os/wsl/10-1password.zsh" 'export GIT_SSH_COMMAND="ssh.exe"'
assert_contains ".config/zsh/conf.d/os/wsl/10-1password.zsh" 'command ssh.exe "$@"'

printf 'ok\n'
