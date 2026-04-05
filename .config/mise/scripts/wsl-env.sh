#!/usr/bin/env bash

append_wslenv_var() {
  local name="$1"

  case ":${WSLENV:-}:" in
    *":${name}:"*) ;;
    *)
      if [ -n "${WSLENV:-}" ]; then
        export WSLENV="${WSLENV}:${name}"
      else
        export WSLENV="${name}"
      fi
      ;;
  esac
}

append_wslenv_var "DOTFILES_1PASSWORD_VAULT"

while IFS= read -r name; do
  [ -n "$name" ] && append_wslenv_var "$name"
done < <(env | awk -F= '/^OP_/ && $1 != "OP_COMMAND" {print $1}')
