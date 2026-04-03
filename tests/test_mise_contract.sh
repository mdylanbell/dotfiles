#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_file ".config/mise/config.toml"
assert_contains ".config/mise/config.toml" '1password-cli = "latest"'
assert_contains ".config/mise/config.toml" 'nvim_virtualenv = "{{xdg_cache_home}}/venvs/nvim"'
assert_not_contains "Brewfile" 'brew "mise"'

assert_file ".config/mise/config.wsl.toml"
assert_contains ".config/mise/config.wsl.toml" 'disable_tools = ["1password-cli"]'

assert_file ".config/mise/config.personal.toml"
assert_file ".config/mise/config.work.toml"

assert_file ".config/git/ignore"
assert_contains ".config/git/ignore" 'mise.local.toml'
assert_contains ".config/git/ignore" 'mise.*.local.toml'

assert_file ".config/mise/conf.d/tasks-bootstrap.toml"
assert_contains ".config/mise/conf.d/tasks-bootstrap.toml" '[tasks."bootstrap"]'
assert_contains ".config/mise/conf.d/tasks-bootstrap.toml" '[tasks."bootstrap:for_env"]'
assert_contains ".config/mise/conf.d/tasks-bootstrap.toml" '[tasks."bootstrap:install"]'
assert_contains ".config/mise/conf.d/tasks-bootstrap.toml" '[tasks."bootstrap:configure"]'
assert_contains ".config/mise/conf.d/tasks-bootstrap.toml" '[tasks."bootstrap:secrets"]'
assert_contains ".config/mise/conf.d/tasks-bootstrap.toml" 'bootstrap:prereqs'
assert_contains ".config/mise/conf.d/tasks-bootstrap.toml" 'intentionally not active'
assert_order ".config/mise/conf.d/tasks-bootstrap.toml" '"bootstrap:for_env"' '"bootstrap:secrets"'

assert_file ".config/mise/conf.d/tasks-update.toml"
assert_contains ".config/mise/conf.d/tasks-update.toml" '[tasks."update"]'
assert_contains ".config/mise/conf.d/tasks-update.toml" '[tasks."nvim:python:ensure"]'
assert_contains ".config/mise/conf.d/tasks-update.toml" 'update:for_env'
assert_contains ".config/mise/conf.d/tasks-update.toml" 'update:nvim'
assert_contains ".config/mise/conf.d/tasks-update.toml" 'update:gh'

assert_file ".config/mise/conf.d/tasks-secrets.toml"
assert_contains ".config/mise/conf.d/tasks-secrets.toml" '[tasks."secrets:render"]'
assert_contains ".config/mise/conf.d/tasks-secrets.toml" '[tasks."secrets:render:todoist_cli"]'
assert_contains ".config/mise/conf.d/tasks-secrets.toml" '[tasks."secrets:clean:todoist_cli"]'
assert_contains ".config/mise/conf.d/tasks-secrets.toml" 'config.json.op_tmpl'
assert_contains ".config/mise/conf.d/tasks-secrets.toml" 'chmod 0600 "${XDG_CONFIG_HOME}/todoist/config.json"'

printf 'ok\n'
