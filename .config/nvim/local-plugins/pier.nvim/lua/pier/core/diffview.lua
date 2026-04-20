local Git = require("pier.git")

local M = {}

---@param value string|nil
---@return boolean
local function has_text(value)
  return type(value) == "string" and value ~= ""
end

local function load_diffview()
  if vim.fn.exists(":DiffviewOpen") == 0 then
    local ok, lazy = pcall(require, "lazy")
    if ok then
      lazy.load({ plugins = { "diffview.nvim" }, wait = true })
    end
  end
  return vim.fn.exists(":DiffviewOpen") ~= 0
end

---@param repo_dir string
---@param base string
---@return string|nil
function M.resolve_range(repo_dir, base)
  if not has_text(repo_dir) or not has_text(base) then
    return nil
  end

  for _, range in ipairs({
    base .. "...HEAD",
    "origin/" .. base .. "...HEAD",
  }) do
    local left, right = range:match("^(.+)%.%.%.(.+)$")
    if left and right and Git.rev_parse(repo_dir, left) and Git.rev_parse(repo_dir, right) then
      return range
    end
  end

  return nil
end

---@param repo_dir string|nil
---@param base string|nil
---@return boolean
function M.open(repo_dir, base)
  if not load_diffview() then
    return false
  end

  local resolved_repo_dir = repo_dir or vim.fn.getcwd()
  local resolved_base = base or Git.default_branch(resolved_repo_dir)
  local range = M.resolve_range(resolved_repo_dir, resolved_base)
  if not range then
    vim.notify(("Pier: could not resolve diff base for %s"):format(resolved_base), vim.log.levels.WARN)
    return false
  end

  local ok = pcall(function()
    vim.cmd("DiffviewOpen " .. range)
  end)
  if ok then
    return true
  end

  vim.notify(("Pier: failed to open Diffview for %s"):format(range), vim.log.levels.WARN)
  return false
end

function M.close()
  pcall(function()
    vim.cmd("DiffviewClose")
  end)
end

return M
