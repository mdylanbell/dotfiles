#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_file ".local/bin/bootstrap_env"
assert_contains ".local/bin/bootstrap_env" '--help'
assert_contains ".local/bin/bootstrap_env" '--dotfiles-root='
assert_contains ".local/bin/bootstrap_env" '--branch='
assert_contains ".local/bin/bootstrap_env" '--skip-git'
assert_contains ".local/bin/bootstrap_env" '--zsh-default='
assert_contains ".local/bin/bootstrap_env" '--enter-shell'
assert_contains ".local/bin/bootstrap_env" 'MISE_TASK_RUN_AUTO_INSTALL=0 MISE_AUTO_INSTALL=0 mise run bootstrap'
assert_contains ".local/bin/bootstrap_env" 'current_shell_name()'
assert_order ".local/bin/bootstrap_env" '  ensure_mise' '  trust_mise_config'
assert_order ".local/bin/bootstrap_env" '  trust_mise_config' '  install_bootstrap_prereqs'

assert_file ".config/mise/config.toml"
assert_not_contains ".config/mise/config.toml" 'python = { version = "3.12", postinstall = "uv'
assert_contains ".config/mise/config.toml" '[hooks]'
assert_contains ".config/mise/config.toml" "mise run nvim:python:rebuild"

printf 'ok\n'
