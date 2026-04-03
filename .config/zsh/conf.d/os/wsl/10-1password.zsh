# export SSH_AUTH_SOCK="${HOME}/.1password/agent.sock"

# https://developer.1password.com/docs/ssh/integrations/wsl/
alias ssh-add="ssh-add.exe"
export GIT_SSH_COMMAND="ssh.exe"

op_env_vars=(${(f)"$(env | awk -F= '/^OP_/ {print $1}')"})
if (( ${#op_env_vars[@]} > 0 )); then
  export WSLENV="${WSLENV:+${WSLENV}:}${(j.:.)op_env_vars}"
fi

# Preserve zsh's native ssh completion while still routing execution through the
# Windows OpenSSH binary used by the 1Password WSL integration.
ssh() {
  command ssh.exe "$@"
}
