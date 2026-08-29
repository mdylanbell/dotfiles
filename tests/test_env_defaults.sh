#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_file ".zshenv"
assert_contains ".zshenv" 'export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=${HOME}/.config}'
assert_contains ".zshenv" 'export DOTFILES_ROOT=${DOTFILES_ROOT:=${HOME}/.dotfiles}'
assert_contains ".zshenv" 'export ZDOTDIR=${ZDOTDIR:=${XDG_CONFIG_HOME}/zsh}'
assert_not_contains ".zshenv" "ANTIDOTE_SOURCE_HOME"

mkdir -p tests/.scratch
scratch_dir="$(mktemp -d "${PWD}/tests/.scratch/test_env_defaults.XXXXXX")"
trap 'rm -rf "$scratch_dir"' EXIT
mkdir -p "$scratch_dir/home" "$scratch_dir/zdotdir"

run_case() {
  local expected_status="$1"
  local expected_mise_env="$2"
  shift 2
  local output status=0

  output="$(
    env -i \
      HOME="$scratch_dir/home" \
      PATH="${CASE_PATH:-$PATH}" \
      DOTFILES_ROOT="$PWD" \
      ZDOTDIR="$scratch_dir/zdotdir" \
      "$@" \
      bash --noprofile --norc -c \
      'source .config/zsh/env.zsh && printf "%s" "$MISE_ENV"' 2>&1
  )" || status=$?

  [[ "$status" -eq "$expected_status" ]] \
    || fail "expected status $expected_status, got $status: $output"
  if [[ "$status" -eq 0 && "$output" != "$expected_mise_env" ]]; then
    fail "expected MISE_ENV=$expected_mise_env, got $output"
  fi
}

run_case 0 "personal" DOTFILES_ENV=personal DOTFILES_FEATURES=
run_case 0 "work,workstation,work-workstation" \
  DOTFILES_ENV=work DOTFILES_FEATURES=workstation
run_case 0 "personal,gui,personal-gui" \
  DOTFILES_ENV=personal DOTFILES_FEATURES=gui
run_case 0 "work,workstation,work-workstation,gui" \
  DOTFILES_ENV=work DOTFILES_FEATURES=gui,workstation
run_case 1 "" DOTFILES_ENV=unknown DOTFILES_FEATURES=
run_case 1 "" DOTFILES_ENV=personal DOTFILES_FEATURES=unknown
run_case 0 "custom" MISE_ENV=custom DOTFILES_ENV=personal DOTFILES_FEATURES=gui

mkdir -p "$scratch_dir/bin"
real_uname="$(command -v uname)"
cat >"$scratch_dir/bin/uname" <<EOF
#!/bin/sh
if [ "\${1:-}" = "-r" ]; then
  printf '%s\n' "5.15.0-microsoft-standard-WSL2"
else
  exec "$real_uname" "\$@"
fi
EOF
chmod +x "$scratch_dir/bin/uname"
CASE_PATH="$scratch_dir/bin:$PATH" \
  run_case 0 "personal,workstation,wsl" \
  DOTFILES_ENV=personal DOTFILES_FEATURES=workstation

exported="$(
  env -i \
    HOME="$scratch_dir/home" \
    PATH="$PATH" \
    DOTFILES_ROOT="$PWD" \
    ZDOTDIR="$scratch_dir/empty-zdotdir" \
    bash --noprofile --norc -c '
      mkdir -p "$ZDOTDIR"
      source .config/zsh/env.zsh
      env | grep -E "^DOTFILES_(ENV|FEATURES)=" || true
    '
)"
[[ -z "$exported" ]] \
  || fail "unset profile defaults must remain shell-local, got: $exported"

printf 'ok\n'
