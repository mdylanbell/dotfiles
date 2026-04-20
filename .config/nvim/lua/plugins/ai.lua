return {
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      {
        "copilotlsp-nvim/copilot-lsp", -- optional dependency required for NES
        init = function()
          vim.g.copilot_nes_debounce = 500
        end,
      },
    },
    -- opts = {
    --   nes = {
    --     enabled = true,
    --     keymap = {
    --       accept_and_goto = "<leader>A",
    --       dismiss = "<Esc>",
    --     },
    --   },
    -- },
    --
  },
  {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    ---@type sidekick.Config
    opts = {
      cli = {
        win = {
          wo = {
            winhighlight = "Normal:Normal,NormalNC:NormalNC,EndOfBuffer:EndOfBuffer,SignColumn:SignColumn",
          },
        },
        mux = {
          backend = "tmux",
          enabled = true,
          create = "terminal",
        },
      },
    },
    keys = {
      {
        "<leader>ax",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").send({ msg = "{diagnostics}" })
        end,
        mode = { "n", "x" },
        desc = "Send Diagnostics",
      },
      {
        "<leader>aD",
        function()
          require("sidekick.cli").send({ msg = "{diagnostics_all}" })
        end,
        mode = { "n", "x" },
        desc = "Send Workspace Diagnostics",
      },
      --     -- Opencode keybinds
      --     {
      --       "<leader>ao",
      --       function()
      --         require("sidekick.cli").toggle({ name = "opencode", focus = true })
      --       end,
      --       desc = sidekick_desc("Toggle opencode"),
      --     },
    },
  },
}
