# ======================================================================
#  Zsh Initialization
# ======================================================================

# Core modules
zmodload zsh/stat

# Allow prompt strings to perform parameter and command substitution
setopt prompt_subst


# ======================================================================
#  Hierarchical Configuration Loader
#
#  Layout:
#    ${ZDOTDIR:-$HOME}/.config/zsh/conf.d/
#      ├─ *.zsh                # base config (always loaded)
#      ├─ os/$ZSH_OS/*.zsh     # OS-specific config (optional)
#      └─ host/$HOST/*.zsh     # host-specific config (optional)
#
#  Notes:
#  - All conf.d modules are sourced inside _zshrc_load/load_tree.
#  - Use `typeset -g` (e.g., `typeset -gU PATH path`) in modules
#    when defining or mutating global parameters.
#  - Aliases, functions, and `export` remain global as usual.
# ======================================================================

_zshrc_load() {
  local confdir=${ZDOTDIR:-$HOME/.config/zsh}/conf.d

  load_tree() {
    local dir=$1 entry rel
    [[ -d $dir ]] || return

    # Globbing behavior local to this loader
    setopt localoptions numericglobsort nullglob extendedglob

    for entry in "$dir"/**/*(N-.); do
      [[ -f $entry ]] || continue

      # At the top-level conf.d, defer os/ and host/ to dedicated passes
      if [[ $dir == "$confdir" ]]; then
        rel=${entry#$confdir/}
        case $rel in
          os/*|host/*) continue ;;
        esac
      fi

      source "$entry"
    done
  }

  # Base configuration (conf.d, excluding os/ and host/ subtrees)
  load_tree "$confdir"

  # OS-specific configuration (conf.d/os/$ZSH_OS)
  if [[ -n $ZSH_OS && -d $confdir/os/$ZSH_OS ]]; then
    load_tree "$confdir/os/$ZSH_OS"
  fi

  # Host-specific configuration (conf.d/host/$HOST or conf.d/host/$SHORT)
  local host short
  host=$(hostname -f 2>/dev/null || hostname)
  short=${host%%.*}

  if [[ -d $confdir/host/$host ]]; then
    load_tree "$confdir/host/$host"
  elif [[ -d $confdir/host/$short ]]; then
    load_tree "$confdir/host/$short"
  fi

  unset -f load_tree
}

_zshrc_load
unset -f _zshrc_load


# ======================================================================
#  Local Overrides
#
#  Optional, unversioned machine-local configuration.
# ======================================================================

[[ -r "${ZDOTDIR:-$HOME}/local.zsh" ]] && source "${ZDOTDIR:-$HOME}/local.zsh"
