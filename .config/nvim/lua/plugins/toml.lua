return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      taplo = {
        -- enable taplo to work on any detached .toml file or any toml under ~/.config
        root_markers = { ".config", ".taplo.toml", "taplo.toml", ".git", "*.toml" },
      },
    },
  },
}
