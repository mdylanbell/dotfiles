#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_file ".local/bin/bootstrap_env"
assert_contains ".local/bin/bootstrap_env" 'DOTDIR="${DOTFILES_ROOT:-${HOME}/.dotfiles}"'
assert_contains ".local/bin/bootstrap_env" '"$DFM" install'
assert_contains ".local/bin/bootstrap_env" 'brew bundle --file="$DOTDIR/Brewfile"'
assert_contains ".local/bin/bootstrap_env" 'mise run setup'
assert_contains ".local/bin/bootstrap_env" 'mise run secrets:render'
assert_contains ".local/bin/bootstrap_env" 'warn "Secret config rendering failed; continuing without generated secret files."'

assert_file ".config/mise/config.toml"
assert_not_contains ".config/mise/config.toml" 'python = { version = "3.12", postinstall = "uv'
assert_contains ".config/mise/config.toml" '[hooks]'
assert_contains ".config/mise/config.toml" "mise run nvim:python:rebuild"

assert_order ".local/bin/bootstrap_env" 'run_dfm_install' 'brew_bundle'
assert_order ".local/bin/bootstrap_env" 'brew_bundle' 'mise_setup'
assert_order ".local/bin/bootstrap_env" 'mise run setup' 'mise run secrets:render'

printf 'ok\n'
