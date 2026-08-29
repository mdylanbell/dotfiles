#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

mkdir -p tests/.scratch
scratch_dir="$(mktemp -d "${PWD}/tests/.scratch/test_bootstrap_smoke.XXXXXX")"
trap 'rm -rf "$scratch_dir"' EXIT
mkdir -p "$scratch_dir/checkout/.local/bin" "$scratch_dir/bin"

cp .local/bin/bootstrap_env "$scratch_dir/checkout/.local/bin/bootstrap_env"
chmod +x "$scratch_dir/checkout/.local/bin/bootstrap_env"

cat >"$scratch_dir/checkout/.local/bin/dfm" <<'EOF'
#!/bin/sh
exit 0
EOF
chmod +x "$scratch_dir/checkout/.local/bin/dfm"

cat >"$scratch_dir/bin/uname" <<'EOF'
#!/bin/sh
printf '%s\n' Darwin
EOF

cat >"$scratch_dir/bin/mise" <<'EOF'
#!/bin/sh
if [ "${1:-}" = "--version" ]; then
  printf '%s\n' "mise test"
  exit 0
fi
printf '%s\n' "$*" >>"$MISE_CALLS"
EOF

for command in git curl zsh; do
  cat >"$scratch_dir/bin/$command" <<'EOF'
#!/bin/sh
exit 0
EOF
done
chmod +x "$scratch_dir/bin/"*

bootstrap="$scratch_dir/checkout/.local/bin/bootstrap_env"

help="$("$bootstrap" --help)"
[[ "$help" == *"--profile=personal|work"* ]] || fail "bootstrap help omits --profile"
[[ "$help" == *"--features=none|workstation|gui|workstation,gui"* ]] \
  || fail "bootstrap help omits --features"
[[ "$help" == *"--enter-shell"* ]] || fail "bootstrap help omits --enter-shell"

run_bootstrap() {
  local home="$1"
  shift

  mkdir -p "$home"
  env \
    HOME="$home" \
    XDG_CONFIG_HOME="$home/.config" \
    PATH="$scratch_dir/bin:/usr/bin:/bin" \
    MISE_CALLS="$home/mise.calls" \
    "$bootstrap" \
    --dotfiles-root="$scratch_dir/checkout" \
    --skip-git \
    "$@"
}

flags_home="$scratch_dir/flags-home"
run_bootstrap "$flags_home" --profile=work --features=gui >/dev/null
flags_file="$flags_home/.config/zsh/env.local.zsh"
assert_file "$flags_file"
assert_line "$flags_file" 'export DOTFILES_ENV="${DOTFILES_ENV:-work}"'
assert_line "$flags_file" 'export DOTFILES_FEATURES="${DOTFILES_FEATURES-gui}"'
assert_contains "$flags_home/mise.calls" "bootstrap --yes -C $scratch_dir/checkout"
assert_not_file "$scratch_dir/checkout/.config/zsh/env.local.zsh"

env_home="$scratch_dir/env-home"
DOTFILES_ENV=work DOTFILES_FEATURES= run_bootstrap "$env_home" >/dev/null
env_file="$env_home/.config/zsh/env.local.zsh"
assert_line "$env_file" 'export DOTFILES_ENV="${DOTFILES_ENV:-work}"'
assert_line "$env_file" 'export DOTFILES_FEATURES="${DOTFILES_FEATURES-}"'

override_home="$scratch_dir/override-home"
DOTFILES_ENV=work DOTFILES_FEATURES=gui \
  run_bootstrap "$override_home" --profile=personal >/dev/null
unset DOTFILES_ENV DOTFILES_FEATURES
override_file="$override_home/.config/zsh/env.local.zsh"
assert_line "$override_file" 'export DOTFILES_ENV="${DOTFILES_ENV:-personal}"'
assert_line "$override_file" 'export DOTFILES_FEATURES="${DOTFILES_FEATURES-gui}"'

run_bootstrap "$override_home" >/dev/null
assert_line "$override_file" 'export DOTFILES_ENV="${DOTFILES_ENV:-personal}"'
assert_line "$override_file" 'export DOTFILES_FEATURES="${DOTFILES_FEATURES-gui}"'

printf 'ok\n'
