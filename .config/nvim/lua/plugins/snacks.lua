return {
  "folke/snacks.nvim",
  optional = true,
  priority = 1000,
  lazy = false,
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
  -- toggle list
  -- init = function()
  --   vim.api.nvim_create_autocmd("User", {
  --     pattern = "VeryLazy",
  --     callback = function()
  --       -- Create some toggle mappings
  --       Snacks.toggle.option("list", { name = "Invisible Chars" }):map("<leader>uv")
  --     end,
  --   })
  -- end,
}
