#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_file ".zshenv"
assert_contains ".zshenv" 'export DOTFILES_ROOT=${DOTFILES_ROOT:=${HOME}/.dotfiles}'

assert_file ".config/.dfminstall"
assert_contains ".config/.dfminstall" 'todoist recurse'

assert_file ".config/todoist/.dfminstall"
assert_contains ".config/todoist/.dfminstall" 'config.json.op_tmpl skip'

assert_file ".config/todoist/.gitignore"
assert_contains ".config/todoist/.gitignore" 'config.json'

assert_file ".config/todoist/config.json.op_tmpl"
assert_contains ".config/todoist/config.json.op_tmpl" 'op://'

assert_file ".config/mise/conf.d/tasks-secrets.toml"
assert_contains ".config/mise/conf.d/tasks-secrets.toml" '[tasks."secrets:render"]'
assert_contains ".config/mise/conf.d/tasks-secrets.toml" '[tasks."secrets:clean"]'
assert_contains ".config/mise/conf.d/tasks-secrets.toml" '[tasks."secrets:render:todoist_cli"]'
assert_contains ".config/mise/conf.d/tasks-secrets.toml" '[tasks."secrets:clean:todoist_cli"]'
assert_contains ".config/mise/conf.d/tasks-secrets.toml" 'chmod 0600 "${XDG_CONFIG_HOME}/todoist/config.json"'
assert_contains ".config/mise/conf.d/tasks-secrets.toml" 'config.json.op_tmpl'
assert_contains ".config/mise/conf.d/tasks-secrets.toml" 'op inject'

assert_file ".config/mise/conf.d/tasks-bootstrap.toml"
assert_contains ".config/mise/conf.d/tasks-bootstrap.toml" '[tasks."bootstrap:secrets"]'
assert_contains ".config/mise/conf.d/tasks-bootstrap.toml" 'mise run secrets:render'

printf 'ok\n'
