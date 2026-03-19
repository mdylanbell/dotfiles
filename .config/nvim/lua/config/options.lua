-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

---- Configure providers

-- Expand XDG_CACHE_HOME so provider resolves to the actual venv path
vim.g.python3_host_prog = vim.fn.expand("$XDG_CACHE_HOME/venvs/nvim/bin/python")

-- Disable Perl provider
vim.g.loaded_perl_provider = 0

-- Disable Ruby provider
vim.g.loaded_ruby_provider = 0

---- Configure python options

-- Prefer pyright (standard) for Python LSP
vim.g.lazyvim_python_lsp = "basedpyright"

-- Prefer ruff over black
vim.g.lazyvim_python_ruff = "ruff"

---- Add custom ReviewPR command

vim.api.nvim_create_user_command("ReviewPR", function()
  require("config.review").review_pr_command()
end, {})
