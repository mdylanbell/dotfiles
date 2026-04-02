# Path-oriented preview: directories use eza, text files use bat, everything
# else falls back to `file`. This follows fzf-tab's preview model directly and
# relies on `$realpath`, which is only populated for file-style completions.
zstyle ':fzf-tab:complete:*:*' fzf-preview '
  if [[ -z $realpath || ! -e $realpath ]]; then
    exit 0
  elif [[ -d $realpath ]]; then
    eza -1 --color=always --group-directories-first $realpath
  elif [[ -f $realpath ]]; then
    if file --mime "$realpath" | grep -q "charset=binary"; then
      file "$realpath"
    else
      bat --color=always --style=plain --line-range=:200 "$realpath"
    fi
  fi
'

# Do not open redundant or empty previews for option groups and description-
# heavy subcommand CLIs whose list entries already carry the useful context.
zstyle ':fzf-tab:complete:*:options' fzf-preview
zstyle ':fzf-tab:complete:(mise|gh|docker|kubectl):*' fzf-preview

# Plain `ssh <Tab>` is host/user oriented, not path oriented, so preview just
# creates empty panes there. Keep SSH family file previews gated separately.
zstyle ':fzf-tab:complete:ssh:*' fzf-preview

# SSH-family completion mixes hosts/users/files. Keep host/user candidates
# preview-free, but leave file candidates eligible for normal path preview.
zstyle ':fzf-tab:complete:(ssh|scp|rsync):*:hosts' fzf-preview
zstyle ':fzf-tab:complete:(ssh|scp|rsync):*:hosts-*' fzf-preview
zstyle ':fzf-tab:complete:(ssh|scp|rsync):*:users' fzf-preview
zstyle ':fzf-tab:complete:(ssh|scp|rsync):*:users-*' fzf-preview

zstyle ':fzf-tab:*' fzf-flags '--preview-window=right,50%,<40(hidden)'

if [[ -n ${TMUX-} ]]; then
  # In tmux, render fzf-tab in a popup to keep previews bounded on wide panes.
  zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  # ftb-tmux-popup sizes itself from completion content width, not preview
  # width, so reserve extra horizontal space for the preview pane explicitly.
  zstyle ':fzf-tab:*' popup-pad 40 0
  # Keep the popup wide enough for a 50% preview pane to stay above the
  # 40-column hide threshold after tmux/fzf UI overhead.
  zstyle ':fzf-tab:*' popup-min-size 100 0
  # When the popup appears above the cursor, keep Tab/Shift-Tab moving in the
  # visually expected direction through results.
  zstyle ':fzf-tab:*' popup-smart-tab yes
fi

zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
