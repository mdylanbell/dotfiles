#!/usr/bin/env zsh

set -euo pipefail

title="AeroSpace Focus Diagnostics"
format='Workspace: %{workspace}
Monitor: %{monitor-name}

App: %{app-name}
Bundle: %{app-bundle-id}
Title: %{window-title}
Window ID: %{window-id}

Root layout: %{workspace-root-container-layout}
Parent layout: %{window-parent-container-layout}
Window layout: %{window-layout}
Fullscreen: %{window-is-fullscreen}'

details="$(aerospace list-windows --focused --format "$format")"

if [[ -z "$details" ]]; then
  details="No focused AeroSpace window was reported."
fi

markdown='```text
'"$details"'
```'

show_osascript() {
  osascript - "$details" "$title" <<'APPLESCRIPT'
on run argv
  display dialog (item 1 of argv) buttons {"OK"} default button "OK" with title (item 2 of argv)
end run
APPLESCRIPT
}

if command -v dialog >/dev/null 2>&1; then
  dialog \
    --title "$title" \
    --message "$markdown" \
    --hideicon \
    --button1text "OK" \
    --width 640 \
    --height 420 \
    --messagefont "size=14" \
    --ontop \
    --moveable \
    --resizable && exit 0
fi

show_osascript
