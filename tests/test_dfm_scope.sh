#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_file ".dfminstall"
assert_contains ".dfminstall" '.config recurse'
assert_contains ".dfminstall" '.local recurse'
assert_contains ".dfminstall" '.ssh recurse'
assert_contains ".dfminstall" 'tests skip'
assert_contains ".dfminstall" 'doc skip'

assert_file ".config/.dfminstall"
assert_contains ".config/.dfminstall" 'direnv recurse'
assert_contains ".config/.dfminstall" 'todoist recurse'
assert_contains ".config/.dfminstall" 'python recurse'
assert_contains ".config/.dfminstall" 'tmux recurse'
assert_contains ".config/.dfminstall" 'zsh recurse'

assert_file ".config/todoist/.dfminstall"
assert_contains ".config/todoist/.dfminstall" 'config.json.op_tmpl skip'

printf 'ok\n'
