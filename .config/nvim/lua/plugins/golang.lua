-- lua/plugins/golang.lua
return {
  -- Treesitter (LazyVim uses the main branch)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for _, lang in ipairs({ "go", "gomod", "gowork", "go_tags" }) do
        if not vim.tbl_contains(opts.ensure_installed, lang) then
          table.insert(opts.ensure_installed, lang)
        end
      end
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        group = vim.api.nvim_create_augroup("treesitter-go-tags", { clear = true }),
        callback = function()
          require("nvim-treesitter.parsers").go_tags = {
            install_info = {
              url = "https://github.com/DanWlker/tree-sitter-go_tags",
              queries = "queries",
            },
          }
        end,
      })
    end,
  },
}
