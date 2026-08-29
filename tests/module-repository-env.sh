#!/usr/bin/env bash
set -euo pipefail

# Print one credential-free HTTP(S) repository URL, or nothing when absent.

validate_url() {
  local url="$1"
  local label="$2"
  local authority

  case "$url" in
    *[[:space:]]*)
      printf "%s contains multiple URLs; not forwarding it.\n" "$label" >&2
      return 1
      ;;
    http://* | https://*) ;;
    *) return 1 ;;
  esac

  authority="${url#*://}"
  authority="${authority%%[/?#]*}"
  if [[ -z "$authority" || "$authority" == *@* ]]; then
    printf "%s is missing a host or contains credentials; not forwarding it.\n" "$label" >&2
    return 1
  fi

  printf "%s\n" "$url"
}

pip_config_get() {
  local key="$1"
  local value=""

  if command -v python3 >/dev/null 2>&1; then
    value="$(python3 -m pip config get "$key" 2>/dev/null)" || value=""
  fi
  if [[ -z "$value" || "$value" == *"No such key"* ]] \
    && command -v pip >/dev/null 2>&1; then
    value="$(pip config get "$key" 2>/dev/null)" || value=""
  fi
  [[ "$value" == *"No such key"* ]] && value=""
  printf "%s" "$value"
}

selector="${1:-}"
value=""
label=""

case "$selector" in
  npm-registry)
    label="npm registry"
    value="${NPM_CONFIG_REGISTRY:-}"
    if [[ -z "$value" ]] && command -v npm >/dev/null 2>&1; then
      value="$(npm config get registry 2>/dev/null)" || value=""
    fi
    ;;
  pip-index)
    label="pip index"
    value="${PIP_INDEX_URL:-}"
    [[ -n "$value" ]] || value="$(pip_config_get global.index-url)"
    ;;
  pip-extra-index)
    label="pip extra index"
    value="${PIP_EXTRA_INDEX_URL:-}"
    [[ -n "$value" ]] || value="$(pip_config_get global.extra-index-url)"
    ;;
  *)
    printf "usage: module-repository-env.sh npm-registry|pip-index|pip-extra-index\n" >&2
    exit 1
    ;;
esac

[[ -n "$value" ]] || exit 0
validate_url "$value" "$label" || exit 0
