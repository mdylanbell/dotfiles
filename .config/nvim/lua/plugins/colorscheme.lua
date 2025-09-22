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

-- return {
--   -- Disable LazyVim's default theme
--   { "folke/tokyonight.nvim", enabled = false },
--
--   -- NeoSolarized as the default colorscheme
--   {
--     "Tsuzat/NeoSolarized.nvim",
--     lazy = false,
--     priority = 1000,
--     opts = {
--       style = "dark",
--       transparent = false,
--
--       -- OPTIONAL: small, theme-native tweaks live here (Python example).
--       -- Prefer links to built-ins for "near-default" behavior, or use palette entries.
--       -- on_highlights = function(h, c)
--       -- Example A (stick close to defaults via links):
--       -- h["@keyword.python"]            = { link = "Keyword" }
--       -- h["@function.python"]           = { link = "Function" }
--       -- h["@function.method.python"]    = { link = "Function" }
--       -- h["@type.builtin.python"]       = { link = "Type" }
--       -- h["@variable.builtin.python"]   = { link = "Identifier" }
--       -- h["@constant.builtin.python"]   = { link = "Constant" }
--       -- h["@attribute.python"]          = { link = "PreProc" }
--       -- h["@module.python"]             = { link = "Identifier" }
--       -- h["@exception.python"]          = { link = "Exception" }
--       -- h["@variable.parameter.python"] = { link = "Identifier" }
--
--       -- Example B (tiny palette tweak: cooler keywords, no bold):
--       -- h["@keyword.python"] = { fg = c.violet }
--       -- end,
--     },
--     config = function(_, opts)
--       require("NeoSolarized").setup(opts)
--       vim.cmd.colorscheme("NeoSolarized")
--     end,
--   },
--
--   -- Tell LazyVim our colorscheme so its presets align
--   {
--     "LazyVim/LazyVim",
--     opts = { colorscheme = "NeoSolarized" },
--   },
--
--   -- Make lualine inherit from the active theme
--   {
--     "nvim-lualine/lualine.nvim",
--     optional = true,
--     opts = function(_, opts)
--       opts.options = opts.options or {}
--       opts.options.theme = "auto"
--     end,
--   },
-- }
