-- LSP/DAP installers via Mason (editor-scoped). We omit pyright and rust-analyzer:
--  - Pyright is installed globally via npm (mise) for CLI + LSP binary on PATH.
--  - Rust is handled by LazyVim's rust extra (rustaceanvim) and expects rust-analyzer on PATH.
return {
  "mason-org/mason.nvim",
  opts = function(_, opts)
    local ensure = {
      -- Python
      "ruff-lsp",
      -- TypeScript / JavaScript
      "typescript-language-server",
      -- YAML / TOML
      "yaml-language-server",
      "taplo",
      -- Helm
      "helm-ls",
      -- Terraform
      "terraform-ls",
      -- C/C++
      "clangd",
      -- Useful extras
      "bash-language-server",
      "json-lsp",
      "marksman", -- Markdown
      "lua-language-server",
      -- Note: Go extras already wire gopls/formatters; we don't force-install here.
    }
    opts.ensure_installed = vim.tbl_deep_extend("force", opts.ensure_installed or {}, ensure)
  end,
}
