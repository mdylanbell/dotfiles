local Git = require("pier.git")

local M = {}

---@param value string|nil
---@return boolean
local function has_text(value)
  return type(value) == "string" and value ~= ""
end

---@param container string
---@return ReviewGitStatus[]
function M.host_checks(container)
  local host_status = Git.origin_host_status(container)
  local host = host_status.host
  return {
    host_status,
    Git.host_reachability_status(host),
    Git.gh_auth_status(host),
  }
end

---@param container string
---@return ReviewGitStatus|nil
function M.first_failed_host_check(container)
  for _, status in ipairs(M.host_checks(container)) do
    if not status.ok then
      return status
    end
  end
  return nil
end

---@param container string|nil
---@param pr_num string|number|nil
---@return string|nil
function M.pr_base_branch(container, pr_num)
  return Git.pr_base_branch(container, pr_num)
end

---@param container string|nil
---@param pr_num string|nil
---@return { title: string, body: string }
function M.fetch_pr_summary(container, pr_num)
  if not has_text(pr_num) then
    return { title = "PR info unavailable", body = "" }
  end

  local repo = Git.origin_slug(container)
  local host = Git.origin_host(container)
  if not has_text(repo) or not has_text(host) then
    return { title = "PR info unavailable", body = "" }
  end
  if vim.fn.executable("gh") ~= 1 then
    return { title = "gh not found", body = "" }
  end

  local out = vim.fn.systemlist({
    "gh",
    "api",
    "--hostname",
    host,
    "repos/" .. repo .. "/pulls/" .. pr_num,
    "--jq",
    '{title:.title,body:(.body // "")}',
  })
  local raw = table.concat(out, "\n")
  if vim.v.shell_error ~= 0 or raw == "" then
    return { title = "PR info unavailable", body = "" }
  end

  local ok, data = pcall(vim.json.decode, raw)
  if not ok or type(data) ~= "table" then
    return { title = "PR info unavailable", body = "" }
  end

  local body = (data.body or ""):gsub("\r\n", "\n"):gsub("\r", "\n")
  return {
    title = data.title or "PR info unavailable",
    body = body,
  }
end

return M
