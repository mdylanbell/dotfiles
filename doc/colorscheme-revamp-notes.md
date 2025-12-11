# Colorscheme revamp quick notes

- Default scheme: Catppuccin Mocha across terminals (Alacritty/Kitty/WezTerm), tmux, Neovim, starship, bat/delta, fzf, dircolors/lscolors.
- Solarized remains available for opt-in overrides.
- tmux: switch via `@theme` in `~/.config/tmux/theme.conf` (`catppuccin` or `solarized`); oh-my-tmux replaced with Catppuccin submodule + TPM plugins.
- Neovim: use LazyVim’s colorscheme selector; Solarized custom config lives under `lua/plugins/colorschemes/solarized`.
- Terminals: swap includes/schemes if needed (`.config/alacritty/colors/*.toml`, Kitty theme include, WezTerm `color_scheme`).
- starship: Catppuccin powerline by default; previous prompt saved at `~/.config/starship.solarized_dark_custom.toml`.
- fzf: theme via `FZF_COLORS` (`_FZF_COLORS_CATPPUCCIN_MOCHA` or `_FZF_COLORS_SOLARIZED_DARK`).
- bat/delta: default `Catppuccin Mocha`; override with `BAT_THEME`/`delta.syntax-theme` (Solarized note in configs).
- dircolors/lscolors: Solarized file at `~/.config/dircolors.solarized`; sourced via Zsh helpers.
