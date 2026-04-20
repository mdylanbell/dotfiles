return {
  "folke/snacks.nvim",
  optional = true,
  opts = {
    picker = {
      sources = {
        explorer = {
          matcher = {
            fuzzy = true,
          },
        },
      },
    },
  },
}
