return {
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      completion = {
        list = {
          selection = {
            -- don't preselect the first item
            preselect = false,
          },
        },
      },
      sources = {
        providers = {
          path = {
            opts = {
              -- show hidden files in path completions
              show_hidden_files_by_default = true,
            },
          },
        },
      },
    },
  },
}
