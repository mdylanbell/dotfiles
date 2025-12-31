-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Automatically open DiffView if in REVIEW_MODE and we detect a pr-focused git worktree
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("ReviewModeDiffview", { clear = true }),
  callback = function()
    if not vim.g.review_mode then
      return
    end
    if vim.fn.argc() ~= 0 then
      return
    end

    local cwd = vim.fn.getcwd()
    if not cwd:match("/wt/pr%-%d+") then
      return
    end

    if vim.fn.exists(":DiffviewOpen") == 0 then
      return
    end

    -- Stable base: PR vs merge-base with main
    vim.cmd("DiffviewOpen origin/main...HEAD")
  end,
})
