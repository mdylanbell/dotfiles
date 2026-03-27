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
    dependencies = {
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          picker = {
            sources = {
              select = {
                kinds = {
                  sidekick_cli = {
                    actions = {
                      sidekick_resume = function(picker, item)
                        require("config.sidekick_cli_extension").picker_action("resume")(picker, item)
                      end,
                      sidekick_continue = function(picker, item)
                        require("config.sidekick_cli_extension").picker_action("continue")(picker, item)
                      end,
                    },
                    win = {
                      input = {
                        footer_keys = { "<CR>", "<M-r>", "<M-c>" },
                        keys = {
                          ["<CR>"] = { "confirm", mode = { "i", "n" }, desc = "Attach or New" },
                          ["<M-r>"] = { "sidekick_resume", mode = { "i", "n" }, desc = "Resume Session" },
                          ["<M-c>"] = { "sidekick_continue", mode = { "i", "n" }, desc = "Continue Last" },
                        },
                      },
                      list = {
                        footer_keys = { "<CR>", "<M-r>", "<M-c>" },
                        keys = {
                          ["<M-r>"] = { "sidekick_resume", desc = "Resume Session" },
                          ["<M-c>"] = { "sidekick_continue", desc = "Continue Last" },
                        },
                      },
                    },
                  },
                },
              },
            },
          },
        },
      },
    },
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
