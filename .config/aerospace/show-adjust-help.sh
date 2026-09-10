#!/usr/bin/env zsh

set -euo pipefail

title="AeroSpace Adjust"
markdown='## Adjust mode

| Key | Action |
|---|---|
| h/j/k/l | Move window left/down/up/right |
| H/J/K/L | Join with left/down/up/right |
| 1..6 | Move window to workspace, stay here |
| s | Current container: v_tiles |
| v | Current container: h_tiles |
| S | Root: v_tiles |
| V | Root: h_tiles |
| c | Current container: v_accordion |
| r | Current container: h_accordion |
| C | Root: v_accordion |
| R | Root: h_accordion |
| - | Smart resize -50 |
| + | Smart resize +50 |
| = | Balance sizes |
| Backspace | Flatten workspace tree |
| d | Focus diagnostics |
| ? | This help |
| Esc / Enter | Exit |'

plain='Adjust:
  h/j/k/l             move window left/down/up/right
  H/J/K/L             join with left/down/up/right
  1..6                move window to workspace, stay here
  s / v               current v_tiles / h_tiles
  S / V               root v_tiles / h_tiles
  c / r               current v_accordion / h_accordion
  C / R               root v_accordion / h_accordion
  - / +               smart resize -50 / +50
  =                   balance sizes
  Backspace           flatten workspace tree
  d                   focus diagnostics
  ?                   this help
  Esc / Enter         exit'

show_osascript() {
  osascript - "$plain" "$title" <<'APPLESCRIPT'
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
    --width 760 \
    --height 680 \
    --messagefont "size=14" \
    --ontop \
    --moveable \
    --resizable && exit 0
fi

show_osascript
