# Load WezTerm shell integration only when actually running inside WezTerm.
[[ ${TERM_PROGRAM:-} == WezTerm || -n ${WEZTERM_EXECUTABLE:-} ]] || return 0

typeset -a _wezterm_shell_integration_paths=(
  "${WEZTERM_EXECUTABLE:h:h}/etc/profile.d/wezterm.sh"
  "/etc/profile.d/wezterm.sh"
  "/usr/share/wezterm/wezterm.sh"
  "/usr/share/wezterm/shell-integration/wezterm.sh"
  "/usr/local/share/wezterm/wezterm.sh"
  "/usr/local/share/wezterm/shell-integration/wezterm.sh"
  "${HOMEBREW_PREFIX:-/opt/homebrew}/etc/profile.d/wezterm.sh"
  "${HOMEBREW_PREFIX:-/usr/local}/etc/profile.d/wezterm.sh"
  "$XDG_DATA_HOME/wezterm/wezterm.sh"
)

local _wezterm_shell_integration
for _wezterm_shell_integration in "${_wezterm_shell_integration_paths[@]}"; do
  if [[ -r $_wezterm_shell_integration ]]; then
    source "$_wezterm_shell_integration"
    break
  fi
done

unset _wezterm_shell_integration _wezterm_shell_integration_paths
