return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        float = {
          border = "rounded",
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      completion = {
        menu = {
          border = "rounded",
          winblend = 0,
        },
        documentation = {
          window = {
            border = "rounded",
            winblend = 0,
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
}
