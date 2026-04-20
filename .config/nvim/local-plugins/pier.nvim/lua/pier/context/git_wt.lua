local Git = require("pier.git")

local M = {}

---@param path string|nil
---@return boolean
function M.is_pr_worktree(path)
  return type(path) == "string" and path:match("/wt/pr%-%d+") ~= nil
end

---@param start string|nil
---@return string|nil
function M.container_root(start)
  return Git.container_root(start)
end

---@param path string|nil
---@return string|nil
function M.pr_number_from_path(path)
  return Git.pr_number_from_path(path)
end

---@param container string
---@return { path: string, label: string, pr: string|nil }[]
function M.pr_worktree_entries(container)
  local entries = {}
  for _, path in ipairs(vim.fn.glob(container .. "/wt/pr-*", true, true)) do
    if vim.fn.isdirectory(path) == 1 then
      table.insert(entries, {
        path = path,
        label = vim.fn.fnamemodify(path, ":t"),
        pr = Git.pr_number_from_path(path),
      })
    end
  end
  table.sort(entries, function(left, right)
    local left_num = tonumber(left.pr)
    local right_num = tonumber(right.pr)
    if left_num and right_num and left_num ~= right_num then
      return left_num < right_num
    end
    return left.label < right.label
  end)
  return entries
end

return M
