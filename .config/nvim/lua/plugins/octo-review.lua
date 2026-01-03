return {
  {
    "pwntester/octo.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.default_to_projects_v2 = false
      return opts
    end,
    keys = {
      { "<leader>gi", false },
      { "<leader>gI", false },
      { "<leader>gp", false },
      { "<leader>gP", false },
      { "<leader>gr", false },
      { "<leader>gS", false },

      { "<leader>ov", "<cmd>Octo pr edit<CR>", desc = "PR View (Octo)" },
      { "<leader>om", "<cmd>Octo pr commits<CR>", desc = "PR Commits (Octo)" },
      { "<leader>ok", "<cmd>Octo pr checks<CR>", desc = "PR Checks (Octo)" },
      { "<leader>ou", "<cmd>Octo pr runs<CR>", desc = "PR Runs (Octo)" },
      { "<leader>or", "<cmd>Octo pr reload<CR>", desc = "PR Reload (Octo)" },
      { "<leader>oc", "<cmd>Octo review commit<CR>", desc = "Review Commit (Octo)" },
      { "<leader>of", "<cmd>Octo pr changes<CR>", desc = "PR Changes (Octo)" },
    },
  },
}
