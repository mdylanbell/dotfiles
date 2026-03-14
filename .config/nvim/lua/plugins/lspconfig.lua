return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard", -- or "strict"
            },
          },
        },
      },
      -- Work around lazydev/lua_ls config timing issues for Neovim globals:
      -- https://github.com/folke/lazydev.nvim/issues/136
      lua_ls = {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
              path = { "?.lua", "?/init.lua" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                vim.fn.stdpath("config") .. "/lua",
              },
            },
          },
        },
      },
    },
  },
}
