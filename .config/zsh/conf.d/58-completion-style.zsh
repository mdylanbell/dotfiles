# ez-compinit provides the compinit baseline; keep generic completion styles
# local and explicit rather than inheriting a larger framework preset.
zstyle ':plugin:ez-compinit' compstyle 'none'
zstyle ':plugin:ez-compinit' use-cache yes

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|?=**'
zstyle ':completion:*' menu no
zstyle ':completion:*' special-dirs true
