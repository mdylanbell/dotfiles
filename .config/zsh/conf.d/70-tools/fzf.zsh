# use fd, follow links, show hidden files, follow symlinks
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

# Pluggable themes
_FZF_COLORS_SOLARIZED_DARK="bg+:-1,bg:-1,fg:254,fg+:254,hl:61,hl+:61,info:136,prompt:136,pointer:61,marker:61,spinner:136,header:136,border:254"
_FZF_COLORS_CATPPUCCIN_MOCHA="bg:#1e1e2e,bg+:#313244,fg:#cdd6f4,fg+:#f5e0dc,hl:#f38ba8,hl+:#fab387,info:#cba6f7,prompt:#89b4fa,pointer:#f5c2e7,marker:#a6e3a1,spinner:#f5e0dc,header:#f38ba8,border:#585b70"
export FZF_COLORS="$_FZF_COLORS_CATPPUCCIN_MOCHA"
