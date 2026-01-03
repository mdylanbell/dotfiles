local M = {}

function M.default_branch()
  local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or ""
  if root == "" then
    return "main"
  end
  local ref = vim.fn.systemlist(
    "git -C " .. vim.fn.fnameescape(root) .. " symbolic-ref --quiet --short refs/remotes/origin/HEAD"
  )[1] or ""
  if ref:match("^origin/") then
    return ref:gsub("^origin/", "")
  end
  return "main"
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
  local url = vim.fn.systemlist("git -C " .. vim.fn.fnameescape(container .. "/main") .. " remote get-url origin")[1] or ""
  local slug = url:match("([^/:]+/[^/]+)%.git$") or url:match("([^/:]+/[^/]+)$")
  return slug or ""
end

function M.origin_host(container)
  local url = vim.fn.systemlist("git -C " .. vim.fn.fnameescape(container .. "/main") .. " remote get-url origin")[1] or ""
  return url:match("^git@([^:]+):") or url:match("^ssh://git@([^/]+)/") or url:match("^https?://([^/]+)/")
    or "github.com"
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
  if repo == "" then
    return nil
  end
  local cmd = {
    "gh",
    "pr",
    "view",
    tostring(pr_num),
    "--repo",
    repo,
    "--hostname",
    host,
    "--json",
    "baseRefName",
    "--jq",
    ".baseRefName",
  }
  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 or #out == 0 then
    return nil
  end
  local base = out[1] or ""
  if base == "" then
    return nil
  end
  return base
end

return M
