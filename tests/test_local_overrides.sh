#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_file ".config/git/config"
assert_contains ".config/git/config" '[includeIf "gitdir:~/code/work/**"]'
assert_contains ".config/git/config" 'path = config.local'

assert_file ".config/git/.gitignore"
assert_contains ".config/git/.gitignore" 'config.local'

assert_file ".config/zsh/env.zsh"
assert_contains ".config/zsh/env.zsh" 'env.local.zsh'

assert_file ".config/zsh/.zshrc"
assert_contains ".config/zsh/.zshrc" 'local.zsh'

assert_file ".config/zsh/.gitignore"
assert_contains ".config/zsh/.gitignore" 'env.local.zsh'
assert_contains ".config/zsh/.gitignore" 'local.zsh'

assert_file ".config/tmux/tmux.conf"
assert_contains ".config/tmux/tmux.conf" 'local.conf'

assert_file ".config/tmux/.gitignore"
assert_contains ".config/tmux/.gitignore" 'local.conf'

printf 'ok\n'
