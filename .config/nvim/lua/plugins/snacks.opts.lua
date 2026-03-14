return {
  "folke/snacks.nvim",
  optional = true,
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
          matcher = {
            fuzzy = true,
          },
        },
      },
    },
  },
}
