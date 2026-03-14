-- Preserve Taplo's normal project root markers, but fall back to the file's
-- directory so the LSP still attaches for detached TOML files.
local markers = { ".taplo.toml", "taplo.toml", ".git" }

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      taplo = {
        root_markers = markers,
        root_dir = function(fname)
          return vim.fs.root(fname, markers) or vim.fs.dirname(fname)
        end,
      },
    },
  },
}
