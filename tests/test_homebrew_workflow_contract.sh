#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

surfaces=(
  .config/mise/conf.d
  tests/mise.toml
  tests/Dockerfile.ubuntu
  tests/Dockerfile.arch
)

for unsafe_operation in \
  "brew bundle cleanup" \
  "brew cleanup" \
  "mise bootstrap packages prune --manager brew --yes"; do
  if grep -R -Fq -- "$unsafe_operation" "${surfaces[@]}"; then
    fail "unsafe shared-prefix operation found: $unsafe_operation"
  fi
done

assert_contains "tests/Dockerfile.arch" "! command -v brew"
assert_contains "tests/Dockerfile.arch" "test ! -e /home/linuxbrew/.linuxbrew"
assert_contains "tests/Dockerfile.ubuntu" \
  "brew bundle check --file=/home/tester/.dotfiles/Brewfile"

printf 'ok\n'
