#!/usr/bin/env zsh

set -euo pipefail

title="AeroSpace Leader"
markdown='## Hyper navigation

| Key | Action |
|---|---|
| Hyper-h/j/k/l | Focus left/down/up/right |
| Hyper-[ / ] | DFS previous/next |
| Hyper-tab | Focus previous window |
| Hyper-1..6 | Switch workspace |

## Leader

| Key | Action |
|---|---|
| 1..6 | Switch workspace |
| Shift-1..6 | Move window to workspace |
| Alt-Shift-1..6 | Move window to workspace and follow |
| z | AeroSpace fullscreen |
| f | Floating/tiling toggle |
| Backspace | Flatten workspace tree |
| = | Balance sizes |
| d | Focus diagnostics |
| a | Adjust mode |
| ? | This help |
| Esc / Enter | Exit |'

plain='Hyper:
  Hyper-h/j/k/l       focus left/down/up/right
  Hyper-[ / ]         DFS previous/next
  Hyper-tab           focus previous window
  Hyper-1..6          switch workspace

Leader:
  1..6                switch workspace
  Shift-1..6          move window to workspace
  Alt-Shift-1..6      move window to workspace and follow
  z                   AeroSpace fullscreen
  f                   floating/tiling toggle
  Backspace           flatten workspace tree
  =                   balance sizes
  d                   focus diagnostics
  a                   adjust mode
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
    --height 900 \
    --messagefont "size=14" \
    --ontop \
    --moveable \
    --resizable && exit 0
fi

show_osascript
