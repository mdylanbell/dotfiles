return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- add organize imports
      python = { "ruff_organize_imports", "ruff_format" },
    },
  },
}
