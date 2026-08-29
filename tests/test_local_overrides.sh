#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_not_file ".gitignore"

assert_file ".config/git/ignore"
for pattern in \
  "mise.local.toml" \
  "mise.*.local.toml" \
  "mise.local.lock" \
  "mise.*.local.lock" \
  "**/mise/config.local.toml" \
  "**/mise/config.*.local.toml"; do
  assert_contains ".config/git/ignore" "$pattern"
done

assert_contains ".config/git/config" '[includeIf "gitdir:~/code/work/**"]'
assert_contains ".config/git/config" "path = config.local"
assert_contains ".config/git/.gitignore" "config.local"

assert_contains ".config/zsh/env.zsh" "env.local.zsh"
assert_contains ".config/zsh/.zshrc" "local.zsh"
assert_contains ".config/zsh/.gitignore" "env.local.zsh"
assert_contains ".config/zsh/.gitignore" "local.zsh"
assert_not_contains ".config/zsh/.gitignore" ".antidote"

assert_contains ".config/tmux/tmux.conf" "local.conf"
assert_contains ".config/tmux/.gitignore" "local.conf"
assert_contains "tests/.gitignore" ".scratch/"

printf 'ok\n'
