-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function diffview_toggle()
  local ok, lib = pcall(require, "diffview.lib")
  if ok and lib.get_current_view() then
    vim.cmd("DiffviewClose")
    return
  end
  pcall(vim.api.nvim_cmd, { cmd = "DiffviewOpen" }, {})
end

vim.keymap.set("n", "<leader>gv", diffview_toggle, { desc = "Diffview Toggle" })
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", { desc = "Diffview File History" })
vim.keymap.set("n", "<leader>gR", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview Repo History" })
vim.keymap.set("n", "<leader>gV", "<cmd>DiffviewRefresh<CR>", { desc = "Diffview Refresh" })

local function snacks_gh_picker(name, opts)
  return function()
    local ok, Snacks = pcall(require, "snacks")
    if not ok or not Snacks.picker or type(Snacks.picker[name]) ~= "function" then
      return
    end
    Snacks.picker[name](opts or {})
  end
end

vim.keymap.set("n", "<leader>gi", snacks_gh_picker("gh_issue"), { desc = "GitHub Issues (open)" })
vim.keymap.set("n", "<leader>gI", snacks_gh_picker("gh_issue", { state = "all" }), { desc = "GitHub Issues (all)" })
vim.keymap.set("n", "<leader>gp", snacks_gh_picker("gh_pr"), { desc = "GitHub Pull Requests (open)" })
vim.keymap.set("n", "<leader>gP", snacks_gh_picker("gh_pr", { state = "all" }), { desc = "GitHub Pull Requests (all)" })

vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
  group = vim.api.nvim_create_augroup("ReviewModeKeymaps", { clear = true }),
  callback = function()
    local review = require("config.review")
    if not review.container_root() then
      return
    end
    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({ { "<leader>R", group = "Review" } })
      if vim.g.review_session then
        wk.add({ { "<leader>o", group = "Octo" } })
      end
    end
    vim.keymap.set("n", "<leader>RP", function()
      review.dashboard_review_pr()
    end, { desc = "Review PR (Diffview)", buffer = 0 })
  end,
})
