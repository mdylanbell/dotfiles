zmodload zsh/stat

# ensure prompt substitution is enabled during load; loader uses localoptions
setopt prompt_subst

_zshrc_load() {
  local confdir host short
  confdir=${ZDOTDIR:-~/.config/zsh}/conf.d

  load_tree() {
    local dir=$1 entry
    [[ -d $dir ]] || return
    setopt localoptions numericglobsort nullglob extendedglob
    for entry in "$dir"/*(N); do
      if [[ -d $entry ]]; then
        case ${entry:t} in os|host) continue ;; esac
        load_tree "$entry"
      elif [[ -f $entry ]]; then
        source "$entry"
      fi
    done
  }

  load_tree "$confdir"
  [[ -d $confdir/os/$ZSH_OS ]] && load_tree "$confdir/os/$ZSH_OS"
  host=$(hostname -f 2>/dev/null || hostname)
  [[ -d $confdir/host/$host ]] && load_tree "$confdir/host/$host"
  short=${host%%.*}
  [[ -d $confdir/host/$short ]] && load_tree "$confdir/host/$short"

  unset -f load_tree
}

_zshrc_load
unset -f _zshrc_load

# optional host-local overrides (ignore if missing)
[[ -r $ZDOTDIR/local.zsh ]] && source $ZDOTDIR/local.zsh || true
