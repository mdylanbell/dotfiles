#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_file ".dockerignore"

for exclusion in \
  ".git" \
  ".copilot/" \
  ".superpowers/" \
  "tests/.scratch/" \
  ".npmrc" \
  "**/.npmrc" \
  ".config/npm/*" \
  ".config/todoist/config.json" \
  ".config/mise/config.local.toml" \
  ".config/mise/config.*.local.toml" \
  ".config/zsh/env.local.zsh" \
  ".config/zsh/local.zsh" \
  ".config/tmux/local.conf" \
  ".config/git/config.local" \
  ".ssh/*" \
  ".cache/*" \
  ".cache/zsh/*" \
  "PowerShellEditorServices.json"; do
  assert_line ".dockerignore" "$exclusion"
done

# Directory-wide exclusions would drop tracked dfm metadata from the harness.
assert_not_line ".dockerignore" ".ssh/"
assert_not_line ".dockerignore" ".cache/"

for inclusion in \
  "!.ssh/.dfminstall" \
  "!.cache/.dfminstall" \
  "!.cache/zsh/.dfminstall" \
  "!.cache/zsh/.save"; do
  assert_line ".dockerignore" "$inclusion"
done

assert_contains ".dockerignore" "!.config/npm/*.op_tmpl"
assert_not_contains ".dockerignore" ".config/todoist/config.json.op_tmpl"
assert_not_contains ".dockerignore" ".config/mise/config.toml"
assert_not_contains ".dockerignore" ".config/mise/conf.d/"

# These run inside the harness images too, where they prove the build context
# still carries tracked dfm metadata.
assert_file ".ssh/.dfminstall"
assert_file ".cache/.dfminstall"
assert_file ".cache/zsh/.dfminstall"
assert_file ".cache/zsh/.save"

assert_file ".config/todoist/config.json.op_tmpl"
assert_contains ".dfminstall" ".dockerignore skip"
assert_contains "tests/Dockerfile.ubuntu" "COPY . /home/tester/.dotfiles"
assert_contains "tests/Dockerfile.arch" "COPY . /home/tester/.dotfiles"
assert_not_file "Dockerfile.test-ubuntu.local"
assert_not_file "Dockerfile.test-arch.local"

printf 'ok\n'
