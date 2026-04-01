# Generate Docker completions into zinit's cache before compinit runs.
command docker --version >/dev/null 2>&1 || return

typeset -g docker_cmd docker_completion_dir docker_completion_file docker_completion_tmp
docker_cmd="$(command -v docker)"

export ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zinit}"
docker_completion_dir="${ZSH_CACHE_DIR}/completions"
docker_completion_file="${docker_completion_dir}/_docker"
docker_completion_tmp="${docker_completion_file}.tmp.$$"

if [[ ! -s "$docker_completion_file" || "$docker_cmd" -nt "$docker_completion_file" ]]; then
  mkdir -p "$docker_completion_dir" || return
  if command docker completion zsh >|"$docker_completion_tmp"; then
    mv -f "$docker_completion_tmp" "$docker_completion_file"
  else
    rm -f "$docker_completion_tmp"
  fi
fi

unset docker_cmd docker_completion_dir docker_completion_file docker_completion_tmp
