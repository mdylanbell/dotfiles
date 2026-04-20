local Git = require("pier.git")

local M = {}

---@param value string|nil
---@return boolean
local function has_text(value)
  return type(value) == "string" and value ~= ""
end

local function load_octo()
  if vim.fn.exists(":Octo") == 0 then
    local ok, lazy = pcall(require, "lazy")
    if ok then
      lazy.load({ plugins = { "octo.nvim" } })
    end
  end
  return vim.fn.exists(":Octo") == 2
end

---@param buf integer
---@return integer|nil
local function tab_with_buffer(buf)
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      if vim.api.nvim_win_get_buf(win) == buf then
        return tab
      end
    end
  end
  return nil
end

---@param repo string|nil
---@param host string|nil
---@param pr_num string|number|nil
---@return string|nil
local function pr_uri(repo, host, pr_num)
  if not has_text(repo) or not has_text(host) or not pr_num then
    return nil
  end
  if host ~= "github.com" then
    return ("octo://%s/%s/pull/%s"):format(host, repo, pr_num)
  end
  return ("octo://%s/pull/%s"):format(repo, pr_num)
end

---@param container string|nil
---@param pr_num string|number|nil
---@return { opened: boolean, tab: integer|nil, created: boolean }
function M.open_pr(container, pr_num)
  if not load_octo() or not container or not pr_num then
    return { opened = false, tab = nil, created = false }
  end

  local uri = pr_uri(Git.origin_slug(container), Git.origin_host(container), pr_num)
  if not uri then
    return { opened = false, tab = nil, created = false }
  end

  local existing_buf = vim.fn.bufnr(uri)
  if existing_buf ~= -1 and vim.api.nvim_buf_is_valid(existing_buf) then
    local existing_tab = tab_with_buffer(existing_buf)
    if existing_tab then
      vim.api.nvim_set_current_tabpage(existing_tab)
      return { opened = true, tab = existing_tab, created = false }
    end
  end

  vim.cmd("tabnew")
  local ok = pcall(function()
    vim.cmd("edit " .. vim.fn.fnameescape(uri))
  end)
  if ok then
    return {
      opened = true,
      tab = vim.api.nvim_get_current_tabpage(),
      created = true,
    }
  end

  pcall(function()
    vim.cmd("tabclose")
  end)
  return { opened = false, tab = nil, created = false }
end

---@param tab integer|nil
---@param created boolean
function M.close_tab(tab, created)
  if not (created and tab) then
    return
  end
  if not vim.api.nvim_tabpage_is_valid(tab) then
    return
  end
  local current = vim.api.nvim_get_current_tabpage()
  if current ~= tab then
    vim.api.nvim_set_current_tabpage(tab)
  end
  pcall(function()
    vim.cmd("tabclose")
  end)
end

return M
