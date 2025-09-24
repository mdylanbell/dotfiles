return {
  -- Disable LazyVim's default theme
  { "folke/tokyonight.nvim", enabled = false },

  "maxmx03/solarized.nvim",
  lazy = false,
  priority = 1000,
  ---@type solarized.config
  opts = {},
  config = function(_, opts)
    vim.o.termguicolors = true
    vim.o.background = "dark"
    require("solarized").setup(opts)
    vim.cmd.colorscheme("solarized")
  end,

  -- Tell LazyVim our colorscheme so its presets align
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "solarized" },
  },
}
