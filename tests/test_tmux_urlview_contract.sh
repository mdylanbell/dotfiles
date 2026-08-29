#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

plugins_conf=".config/tmux/conf.d/plugins.conf"
assert_file "$plugins_conf"
assert_contains "$plugins_conf" "set -g @plugin 'tmux-plugins/tmux-urlview'"
assert_contains "$plugins_conf" \
  "if-shell 'command -v urlview >/dev/null 2>&1' \"set -g @urlview_command 'urlview'\" \"set -g @urlview_command 'urlscan'\""

if grep -Fqx "set -g @urlview_command 'urlview'" "$plugins_conf"; then
  fail "expected urlview selection to fall back to urlscan"
fi

printf 'ok\n'
