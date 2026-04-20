local M = {}

---@class ReviewGitStatus
---@field ok boolean
---@field host string|nil
---@field reason? string
---@field message? string

---@class ReviewOriginInfo
---@field root string|nil
---@field url string
---@field slug string
---@field remote_host string|nil
---@field host string|nil

---@param value string|nil
---@return boolean
local function has_text(value)
  return type(value) == "string" and value ~= ""
end

---@param value string|nil
---@return string
local function first_line(value)
  return vim.split(value or "", "\n", { plain = true })[1] or ""
end

---@param host string|nil
---@return ReviewGitStatus
local function ok_status(host)
  return {
    ok = true,
    host = host,
  }
end

---@param host string|nil
---@param reason string
---@param message string
---@return ReviewGitStatus
local function error_status(host, reason, message)
  return {
    ok = false,
    host = host,
    reason = reason,
    message = message,
  }
end

local function run_cmd(cmd, timeout)
  if vim.system then
    local result = vim.system(cmd, { text = true, timeout = timeout }):wait()
    return {
      code = result.code,
      stdout = result.stdout or "",
      stderr = result.stderr or "",
    }
  end

  local out = vim.fn.systemlist(cmd)
  return {
    code = vim.v.shell_error,
    stdout = table.concat(out, "\n"),
    stderr = "",
  }
end

local function git_cmd(repo_dir, args, timeout)
  local cmd = { "git", "-C", repo_dir }
  vim.list_extend(cmd, args)
  return run_cmd(cmd, timeout)
end

---@param path string|nil
---@return string|nil
local function repo_root(path)
  if not has_text(path) then
    return nil
  end
  local result = git_cmd(path, { "rev-parse", "--show-toplevel" }, 4000)
  if result.code ~= 0 then
    return nil
  end
  local root = first_line(result.stdout)
  if not has_text(root) then
    return nil
  end
  return root
end

---@param path string|nil
---@return string|nil
local function review_repo_root(path)
  local root = repo_root(path)
  if root then
    return root
  end
  if not has_text(path) then
    return nil
  end

  local main_dir = vim.fs.joinpath(path, "main")
  if vim.fn.isdirectory(main_dir) == 1 then
    return repo_root(main_dir)
  end

  return nil
end

---@param path string|nil
---@return string
local function origin_url(path)
  local root = review_repo_root(path)
  if not root then
    return ""
  end
  local result = git_cmd(root, { "remote", "get-url", "origin" }, 4000)
  if result.code ~= 0 then
    return ""
  end
  return first_line(result.stdout)
end

---@param host string|nil
---@return string|nil
local function ssh_hostname(host)
  if not has_text(host) or vim.fn.executable("ssh") ~= 1 then
    return nil
  end
  local result = run_cmd({ "ssh", "-G", host }, 4000)
  if result.code ~= 0 or not has_text(result.stdout) then
    return nil
  end
  for line in result.stdout:gmatch("[^\r\n]+") do
    local key, value = line:match("^(%S+)%s+(.+)$")
    if key == "hostname" and value and value ~= "" then
      return value
    end
  end
  return nil
end

---@param url string
---@return boolean
local function is_ssh_url(url)
  return url:match("^git@") ~= nil or url:match("^ssh://") ~= nil
end

---@param url string
---@return string
local function parse_origin_slug(url)
  return url:match("([^/:]+/[^/]+)%.git$") or url:match("([^/:]+/[^/]+)$") or ""
end

---@param url string
---@return string|nil
local function parse_origin_remote_host(url)
  return url:match("^git@([^:]+):") or url:match("^ssh://git@([^/]+)/") or url:match("^https?://([^/]+)/") or nil
end

---@param root string|nil
---@return ReviewOriginInfo
local function empty_origin_info(root)
  return {
    root = root,
    url = "",
    slug = "",
    remote_host = nil,
    host = nil,
  }
end

---@param path string|nil
---@return ReviewOriginInfo
local function origin_info(path)
  local root = review_repo_root(path)
  if not root then
    return empty_origin_info(nil)
  end

  local url = origin_url(root)
  local remote_host = parse_origin_remote_host(url)
  local host = remote_host
  if has_text(host) and is_ssh_url(url) then
    host = ssh_hostname(host) or host
  end
  local info = {
    root = root,
    url = url,
    slug = parse_origin_slug(url),
    remote_host = remote_host,
    host = host,
  }
  return info
end

---@param path string|nil
---@return string
function M.default_branch(path)
  local root = review_repo_root(path)
  if not has_text(root) then
    return "main"
  end
  local ref_result = git_cmd(root, { "symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD" }, 4000)
  local ref = first_line(ref_result.stdout)
  if ref:match("^origin/") then
    return ref:gsub("^origin/", "")
  end
  return "main"
end

---@param path string|nil
---@return string|nil
function M.review_repo_root(path)
  return review_repo_root(path)
end

function M.container_root(start)
  local dir = start
  while dir and dir ~= "/" do
    if vim.fn.isdirectory(dir .. "/main") == 1 and vim.fn.isdirectory(dir .. "/wt") == 1 then
      return dir
    end
    dir = vim.fs.dirname(dir)
  end
end

function M.origin_slug(container)
  return origin_info(container).slug
end

function M.origin_remote_host(container)
  return origin_info(container).remote_host
end

function M.origin_host(container)
  return origin_info(container).host
end

function M.pr_number_from_path(path)
  if not path then
    return nil
  end
  return path:match("/wt/pr%-(%d+)%-.+$") or path:match("/wt/pr%-(%d+)$")
end

function M.pr_base_branch(container, pr_num)
  if vim.fn.executable("gh") ~= 1 then
    return nil
  end
  if not container or not pr_num then
    return nil
  end
  local repo = M.origin_slug(container)
  local host = M.origin_host(container)
  if not has_text(repo) or not has_text(host) then
    return nil
  end
  local cmd = {
    "gh",
    "pr",
    "view",
    tostring(pr_num),
    "--repo",
    host ~= "github.com" and ("%s/%s"):format(host, repo) or repo,
    "--json",
    "baseRefName",
    "--jq",
    ".baseRefName",
  }
  local result = run_cmd(cmd, 6000)
  local base = first_line(result.stdout)
  if result.code ~= 0 or not has_text(base) then
    return nil
  end
  return base
end

function M.rev_parse(repo_dir, ref)
  if not has_text(repo_dir) or not has_text(ref) then
    return nil
  end
  local result = git_cmd(repo_dir, { "rev-parse", "--verify", ref }, 4000)
  local resolved = first_line(result.stdout)
  if result.code ~= 0 or not has_text(resolved) then
    return nil
  end
  return resolved
end

function M.origin_host_status(container)
  local host = M.origin_host(container)
  if not has_text(host) then
    return error_status(host, "no_host", "Pier: could not determine GitHub host from origin remote")
  end
  return ok_status(host)
end

function M.host_reachability_status(host)
  if not has_text(host) then
    return error_status(host, "no_host", "Pier: could not determine GitHub host from origin remote")
  end

  if vim.fn.executable("curl") == 1 then
    local probe = run_cmd({
      "curl",
      "--silent",
      "--show-error",
      "--location",
      "--connect-timeout",
      "3",
      "--max-time",
      "5",
      "--output",
      "/dev/null",
      "https://" .. host .. "/",
    }, 6000)
    if probe.code ~= 0 then
      return error_status(host, "host_unreachable", ("Pier: cannot reach %s; VPN or network may be down"):format(host))
    end
  end

  return ok_status(host)
end

function M.gh_auth_status(host)
  if not has_text(host) then
    return error_status(host, "no_host", "Pier: could not determine GitHub host from origin remote")
  end

  if vim.fn.executable("gh") ~= 1 then
    return error_status(host, "gh_missing", "Pier: gh is not installed")
  end

  local auth = run_cmd({ "gh", "auth", "status", "--hostname", host }, 6000)
  if auth.code ~= 0 then
    return error_status(
      host,
      "gh_unavailable",
      ("Pier: gh is not ready for %s; check authentication for that host"):format(host)
    )
  end

  return ok_status(host)
end

return M
