#!/usr/bin/env bash
set -euo pipefail

platform="${1:-}"
case "$platform" in
  ubuntu | arch) ;;
  *)
    printf "usage: %s ubuntu|arch\n" "${0##*/}" >&2
    exit 1
    ;;
esac

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
image="local-dotfiles-test-${platform}"
docker_env=()

add_repository_env() {
  local selector="$1"
  local variable="$2"
  local value

  value="$(bash "$repo_root/tests/module-repository-env.sh" "$selector")"
  if [[ -n "$value" ]]; then
    docker_env+=(--env "${variable}=${value}")
  fi
}

add_repository_env npm-registry NPM_CONFIG_REGISTRY
add_repository_env pip-index PIP_INDEX_URL
add_repository_env pip-extra-index PIP_EXTRA_INDEX_URL

cd "$repo_root"
docker build --platform linux/amd64 \
  -f "tests/Dockerfile.${platform}" \
  -t "$image" \
  .
docker run --rm --platform linux/amd64 "${docker_env[@]}" "$image"
