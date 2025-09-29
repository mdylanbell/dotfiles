-- ~/.config/nvim/lua/plugins/conform.lua
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- Ruff CLI: fix, then organize imports, then format
      -- Names per Conform & Ruff docs.
      opts.formatters_by_ft.python = { "ruff_fix", "ruff_organize_imports", "ruff_format" }
    end,
  },
}
