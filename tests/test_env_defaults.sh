#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_file ".zshenv"
assert_contains ".zshenv" 'export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=${HOME}/.config}'
assert_contains ".zshenv" 'export XDG_DATA_HOME=${XDG_DATA_HOME:=${HOME}/.local/share}'
assert_contains ".zshenv" 'export XDG_STATE_HOME=${XDG_STATE_HOME:=${HOME}/.local/state}'
assert_contains ".zshenv" 'export XDG_CACHE_HOME=${XDG_CACHE_HOME:=${HOME}/.cache}'
assert_contains ".zshenv" 'export DOTFILES_ROOT=${DOTFILES_ROOT:=${HOME}/.dotfiles}'
assert_contains ".zshenv" 'export MISE_GLOBAL_CONFIG_ROOT=${MISE_GLOBAL_CONFIG_ROOT:=${DOTFILES_ROOT}}'
assert_contains ".zshenv" 'export ZDOTDIR=${ZDOTDIR:=${XDG_CONFIG_HOME}/zsh}'

assert_file ".config/zsh/env.zsh"
assert_contains ".config/zsh/env.zsh" 'export DOTFILES_ENV="${DOTFILES_ENV:-personal}"'
assert_contains ".config/zsh/env.zsh" 'export MISE_ENV="${MISE_ENV:-$DOTFILES_ENV},${ZSH_OS}"'
assert_contains ".config/zsh/env.zsh" 'export DOTFILES_1PASSWORD_VAULT="${DOTFILES_1PASSWORD_VAULT:-dotfiles-${DOTFILES_ENV}}"'

printf 'ok\n'
