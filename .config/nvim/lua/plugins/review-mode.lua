return {
  -- Work mode (default): keep LazyVim's gitsigns.
  -- Review mode: disable it to avoid signcolumn conflicts.
  {
    "lewis6991/gitsigns.nvim",
    cond = function()
      return not vim.g.review_mode
    end,
  },

  -- Review mode: show diff overlays in-buffer.
  {
    "nvim-mini/mini.diff",
    cond = function()
      return vim.g.review_mode
    end,
    opts = {
      view = { style = "overlay" },
    },
  },
}
