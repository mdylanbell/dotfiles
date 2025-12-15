-- Force a single offsetEncoding for all LSP clients to avoid mixed utf-8/utf-16 issues
-- (mixed encodings break hover/signature positions when multiple clients attach, e.g. ruff + pyright).
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      -- Apply to all servers via the wildcard
      opts.servers["*"] = opts.servers["*"] or {}
      opts.servers["*"].capabilities = vim.tbl_deep_extend("force", opts.servers["*"].capabilities or {}, {
        offsetEncoding = { "utf-16" },
      })
    end,
  },
}
