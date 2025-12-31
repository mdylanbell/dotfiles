-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Prefer pyright (standard) for Python LSP
vim.g.lazyvim_python_lsp = "basedpyright"

-- Review mode is opt-in at startup:
--   NVIM_REVIEW=1 nvim
vim.g.review_mode = vim.env.NVIM_REVIEW == "1"
