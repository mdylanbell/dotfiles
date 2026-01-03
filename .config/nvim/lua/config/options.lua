-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Prefer pyright (standard) for Python LSP
vim.g.lazyvim_python_lsp = "basedpyright"

vim.api.nvim_create_user_command("ReviewPR", function()
  require("config.review").review_pr_command()
end, {})
