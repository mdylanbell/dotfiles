-- Treat only explicit Taplo config files as project roots. Otherwise, use the
-- TOML file's own directory so Taplo still attaches for detached dotfile
-- configs inside larger repos.
local markers = { ".taplo.toml", "taplo.toml" }

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      taplo = {
        root_markers = markers,
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          on_dir(vim.fs.root(fname, markers) or vim.fs.dirname(fname))
        end,
      },
    },
  },
}
