#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
source tests/lib.sh

helper="tests/module-repository-env.sh"
mkdir -p tests/.scratch
scratch_dir="$(mktemp -d "${PWD}/tests/.scratch/test_repository_env.XXXXXX")"
empty_path="${scratch_dir}/bin"
trap 'rm -rf "$scratch_dir"' EXIT
mkdir -p "$empty_path"

output="$(
  env -i PATH="$empty_path" NPM_CONFIG_REGISTRY="https://registry.example.test/" \
    /bin/bash "$helper" npm-registry
)"
[[ "$output" == "https://registry.example.test/" ]] \
  || fail "expected a credential-free npm registry"

output="$(
  env -i PATH="$empty_path" PIP_INDEX_URL="https://packages.example.test/simple/" \
    /bin/bash "$helper" pip-index
)"
[[ "$output" == "https://packages.example.test/simple/" ]] \
  || fail "expected a credential-free pip index"

output="$(
  env -i PATH="$empty_path" NPM_CONFIG_REGISTRY="https://user:secret@example.test/" \
    /bin/bash "$helper" npm-registry 2>/dev/null
)"
[[ -z "$output" ]] || fail "expected a credential-bearing URL to be rejected"

output="$(env -i PATH="$empty_path" /bin/bash "$helper" pip-extra-index)"
[[ -z "$output" ]] || fail "expected no output when no repository is configured"

if /bin/bash "$helper" unknown >/dev/null 2>&1; then
  fail "expected an unknown repository selector to fail"
fi

printf 'ok\n'
