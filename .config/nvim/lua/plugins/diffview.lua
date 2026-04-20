return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>gv",
        function()
          local ok, lib = pcall(require, "diffview.lib")
          if ok and lib.get_current_view() then
            vim.cmd("DiffviewClose")
            return
          end
          pcall(vim.api.nvim_cmd, { cmd = "DiffviewOpen" }, {})
        end,
        desc = "Diffview Toggle",
      },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview File History" },
      { "<leader>gR", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview Repo History" },
      { "<leader>gV", "<cmd>DiffviewRefresh<CR>", desc = "Diffview Refresh" },
    },
  },
}
