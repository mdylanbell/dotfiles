local is_datavant_laptop = vim.uv.os_gethostname() == "DatavantLaptop.local"
if not is_datavant_laptop then
  return {}
end
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruff = {
        -- Command to run ruff-lsp.
        -- This can be a direct path to the executable if not in your PATH.
        -- Using 'ruff-lsp' directly will rely on your PATH, which is usually
        -- sufficient if installed in a virtual environment activated for Neovim.
        cmd = { "ruff-lsp" },
        -- Optional: Define root_dir if ruff-lsp needs to find project root differently
        -- root_dir = require("lspconfig.util").find_git_ancestor,
        settings = {
          -- Add any specific ruff-lsp settings here if needed
          -- For example, to specify a ruff configuration file:
          -- ruff = {
          --   args = { "--config", "pyproject.toml" },
          -- },
        },
      },
    },
  },
}
-- return {
--   {
--     "neovim/nvim-lspconfig",
--     opts = {
--       servers = {
--         -- ... other server configurations ...
--       },
--     },
--     config = function(_, opts)
--       -- Check Ruff version
--       local handle = io.popen("ruff --version")
--       local result = handle:read("*a")
--       handle:close()
--
--       local ruff_version_str = result:match("ruff (%.?%d+%.?%d+%.?%d+)")
--       local use_ruff_lsp = false
--
--       if ruff_version_str then
--         local parts = vim.split(ruff_version_str, ".", { plain = true })
--         local major = tonumber(parts[1]) or 0
--         local minor = tonumber(parts[2]) or 0
--
--         -- Check if ruff version is less than 0.3
--         if major == 0 and minor < 3 then
--           use_ruff_lsp = true
--         end
--       end
--
--       if use_ruff_lsp then
--         vim.list_extend(opts.servers, {
--           ruff_lsp = {
--             -- ruff-lsp specific settings
--             -- Example: you might add init_options if needed
--             -- init_options = {
--             --   settings = {
--             --     args = {},
--             --   },
--             -- },
--           },
--         })
--       else
--         -- Configure regular ruff if version is 0.3 or higher
--         -- This might involve using a different linter or formatter setup
--         -- if ruff-lsp is not desired for newer versions.
--         -- For example, you might configure 'ruff' directly if it has a built-in LSP or similar mechanism.
--         vim.list_extend(opts.servers, {
--           ruff = { -- Assuming a 'ruff' LSP server exists or you are using a different integration
--             -- Configuration for newer ruff versions
--           },
--         })
--       end
--
--       require("lspconfig").setup(opts)
--     end,
--   },
-- }
