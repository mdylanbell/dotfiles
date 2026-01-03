return {
  -- Review sessions: enable mini.diff overlays when requested.
  {
    "nvim-mini/mini.diff",
    event = "VeryLazy",
  },

  -- Review mode: always show bufferline so the tab bar is visible.
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.options = opts.options or {}
      opts.options.always_show_bufferline = vim.g.review_session == true
      return opts
    end,
  },
}
