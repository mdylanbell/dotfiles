#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_file ".dfminstall"
assert_line ".dfminstall" 'Brewfile skip'
assert_contains ".dfminstall" '.config recurse'
assert_contains ".dfminstall" '.local recurse'
assert_contains ".dfminstall" '.ssh recurse'
assert_contains ".dfminstall" 'tests skip'
assert_contains ".dfminstall" 'doc skip'
assert_not_contains ".dfminstall" 'mise.toml skip'
assert_not_contains ".dfminstall" 'Dockerfile.test-ubuntu.local skip'
assert_not_contains ".dfminstall" 'Dockerfile.test-arch.local skip'
assert_not_contains ".dfminstall" 'Dockerfile.test.local skip'
assert_not_contains ".dfminstall" '.gitignore skip'
assert_not_file ".gitignore"
assert_not_file "mise.toml"

assert_file "tests/.miserc.toml"
assert_line "tests/.miserc.toml" "auto_env = true"

assert_file ".config/.dfminstall"
assert_contains ".config/.dfminstall" 'direnv recurse'
assert_contains ".config/.dfminstall" 'todoist recurse'
assert_contains ".config/.dfminstall" 'python recurse'
assert_contains ".config/.dfminstall" 'tmux recurse'
assert_contains ".config/.dfminstall" 'zsh recurse'

assert_file ".config/todoist/.dfminstall"
assert_contains ".config/todoist/.dfminstall" 'config.json.op_tmpl skip'

(
  cd tests
  mise run --skip-tools --dry-run portable >/dev/null
) || fail "expected tests/mise.toml to work as a standalone mise project"

linux_plan="$(
  cd tests
  NO_COLOR=1 mise run --skip-tools --dry-run linux 2>&1
)"
[[ "$linux_plan" == *"[ubuntu]"* ]] \
  || fail "expected the linux task to invoke the ubuntu task directly"
[[ "$linux_plan" == *"[arch]"* ]] \
  || fail "expected the linux task to invoke the arch task directly"
[[ "$linux_plan" != *"mise -C tests run"* ]] \
  || fail "expected the linux task to use mise task references"

printf 'ok\n'
