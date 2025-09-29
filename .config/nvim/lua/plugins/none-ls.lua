-- Diagnostics/code-actions for CLI tools without rich LSPs.
-- Keep formatters in Conform to avoid duplication.
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local nls = require("null-ls")
    opts.sources = vim.list_extend(opts.sources or {}, {
      -- Shell
      nls.builtins.diagnostics.shellcheck,

      -- YAML (runs alongside yaml-language-server)
      nls.builtins.diagnostics.yamllint,

      -- SQL (configure dialect per-project in .sqlfluff; default to postgres here)
      nls.builtins.diagnostics.sqlfluff.with({
        extra_args = { "--dialect", "postgres" },
      }),
    })
  end,
}
