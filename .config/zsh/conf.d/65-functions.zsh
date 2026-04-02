clipboard_copy() {
  local text

  if (($#)); then
    text="$*"
  else
    text="$(cat)"
  fi

  if [[ -n ${TMUX-} ]] && command -v tmux >/dev/null 2>&1; then
    printf '%s' "$text" | tmux load-buffer -w -
  elif command -v pbcopy >/dev/null 2>&1; then
    printf '%s' "$text" | pbcopy
  elif command -v clip.exe >/dev/null 2>&1; then
    printf '%s' "$text" | clip.exe
  elif command -v wl-copy >/dev/null 2>&1; then
    printf '%s' "$text" | wl-copy
  elif command -v xclip >/dev/null 2>&1; then
    printf '%s' "$text" | xclip -selection clipboard
  elif command -v xsel >/dev/null 2>&1; then
    printf '%s' "$text" | xsel --clipboard --input
  else
    printf '%s\n' "$text"
  fi
}
