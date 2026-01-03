-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ReviewDiffviewWhichKey", { clear = true }),
  pattern = { "DiffviewFiles", "DiffviewFileHistory", "DiffviewView" },
  callback = function(ev)
    local ok, wk = pcall(require, "which-key")
    if not ok then
      return
    end

    wk.add({
      { "<tab>", desc = "Next file" },
      { "<s-tab>", desc = "Prev file" },
      { "[F", desc = "First file" },
      { "]F", desc = "Last file" },
      { "gf", desc = "Open file (edit)" },
      { "<C-w><C-f>", desc = "Open file (split)" },
      { "<C-w>gf", desc = "Open file (tab)" },
      { "<leader>e", desc = "Focus file list" },
      { "<leader>b", desc = "Toggle file list" },
      { "i", desc = "Toggle list/tree" },
      { "f", desc = "Toggle flatten dirs" },
      { "L", desc = "Commit log panel" },
      { "R", desc = "Refresh file list" },
      { "g?", desc = "Diffview help" },
    }, { buffer = ev.buf })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("ReviewDisableMiniDiffOcto", { clear = true }),
  pattern = "octo",
  callback = function(ev)
    vim.b[ev.buf].minidiff_disable = true
    local ok, md = pcall(require, "mini.diff")
    if ok then
      md.disable(ev.buf)
    end
  end,
})
