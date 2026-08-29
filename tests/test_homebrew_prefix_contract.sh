#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

assert_file ".config/zsh/conf.d/10-homebrew.zsh"
assert_file ".config/zsh/conf.d/60-tools/mise.zsh"
assert_contains ".config/zsh/conf.d/10-homebrew.zsh" '/opt/homebrew/bin/brew'
assert_contains ".config/zsh/conf.d/10-homebrew.zsh" '/home/linuxbrew/.linuxbrew/bin/brew'
assert_contains ".config/zsh/conf.d/10-homebrew.zsh" 'shellenv'
assert_not_contains ".config/zsh/conf.d/10-homebrew.zsh" 'command -v brew'
assert_not_contains ".config/zsh/conf.d/10-homebrew.zsh" '/usr/local'
assert_not_contains ".config/zsh/conf.d/60-tools/mise.zsh" 'brew'

command -v zsh >/dev/null 2>&1 || fail "zsh is required for the Homebrew prefix contract"

mkdir -p tests/.scratch
scratch_dir="$(mktemp -d "${PWD}/tests/.scratch/test_homebrew_prefix_contract.XXXXXX")"

cleanup() {
  rm -rf "${scratch_dir}"
}

trap cleanup EXIT
mkdir -p "${scratch_dir}/home" "${scratch_dir}/bin" "${scratch_dir}/prefix/bin"

cat >"${scratch_dir}/bin/mise" <<EOF
#!/bin/sh
if [ "\$1" = "activate" ]; then
  printf '%s\n' 'path=("${scratch_dir}/prefix/bin" \$path)'
  exit 0
fi
exit 1
EOF
chmod +x "${scratch_dir}/bin/mise"

cat >"${scratch_dir}/prefix/bin/brew" <<'EOF'
#!/usr/bin/env bash
printf 'export DOTFILES_BREW_SHELLENV_RAN=1;\n'
EOF
chmod +x "${scratch_dir}/prefix/bin/brew"

brew_output="$(
  env -i \
    HOME="${scratch_dir}/home" \
    PATH="${scratch_dir}/bin:/usr/bin:/bin" \
    zsh -f -c '
      _zsh_cache_completion() { :; }
      source .config/zsh/conf.d/60-tools/mise.zsh
      print -r -- "PATH=$PATH"
      print -r -- "SHELLENV=${DOTFILES_BREW_SHELLENV_RAN-}"
    '
)"
grep -Fq "PATH=${scratch_dir}/prefix/bin:" <<<"${brew_output}" \
  || fail "expected mise activation to add its configured tool prefix: ${brew_output}"
grep -Fq "SHELLENV=" <<<"${brew_output}" \
  || fail "expected mise startup to avoid running brew shellenv: ${brew_output}"
grep -Fq "SHELLENV=1" <<<"${brew_output}" \
  && fail "expected brew shellenv to stay out of mise startup: ${brew_output}"

printf 'ok\n'
