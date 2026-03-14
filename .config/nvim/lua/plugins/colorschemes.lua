local default_theme = "catppuccin-nvim"

return {
  -- Core theme: Catppuccin Mocha
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    init = function()
      vim.o.termguicolors = true
    end,
    opts = {
      flavour = "mocha",
      term_colors = true,
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.15,
      },
      -- auto enable integrations based on lazy installs
      auto_integrations = true,
      custom_highlights = function(colors)
        return {
          LspSignatureActiveParameter = {
            bg = colors.surface1,
            bold = true,
            underline = true,
          },
        }
      end,
    },
  },

  -- Default colorscheme for LazyVim presets
  { "LazyVim/LazyVim", opts = { colorscheme = default_theme } },

  -- Custom solarized configuration (lazy-loaded helpers/autocmds)
  { import = "plugins.colorschemes.solarized" },
}
