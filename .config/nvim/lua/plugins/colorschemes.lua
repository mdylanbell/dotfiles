local default_theme = "catppuccin"

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
      integrations = {
        cmp = true,
        gitsigns = true,
        harpoon = true,
        indent_blankline = { enabled = true },
        native_lsp = { enabled = true },
        notify = true,
        treesitter = true,
        which_key = true,
      },
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
