local M = {}
local Git = require("config.review.git")

local function is_pr_worktree(path)
  return path and path:match("/wt/pr%-%d+")
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

local function load_octo()
  if vim.fn.exists(":Octo") == 0 then
    local ok, lazy = pcall(require, "lazy")
    if ok then
      lazy.load({ plugins = { "octo.nvim" } })
    end
  end
  return vim.fn.exists(":Octo") == 2
end

local function find_octo_pr_buf(pr_num)
  if not pr_num then
    return nil
  end
  local pat = "/pulls?/" .. pr_num .. "$"
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    if name:match("^octo://") and name:match(pat) then
      return buf
    end
  end
  return nil
end

function M.open_diffview()
  if not load_diffview() then
    return false
  end
  local base = vim.g.review_base_ref or Git.default_branch()
  local ok = pcall(vim.cmd, "DiffviewOpen " .. base .. "...HEAD")
  if ok then
    return true
  end
  ok = pcall(vim.cmd, "DiffviewOpen origin/" .. base .. "...HEAD")
  if ok then
    return true
  end
  ok = pcall(vim.cmd, "DiffviewOpen")
  if ok then
    return true
  end
  return false
end

local function open_octo_pr(container, pr_num)
  if not load_octo() then
    return false
  end
  if not pr_num or not container then
    return false
  end
  local repo = Git.origin_slug(container)
  if repo == "" then
    return false
  end
  local cmd = ("Octo pr edit %s %s"):format(pr_num, repo)
  pcall(vim.cmd, cmd)
  return true
end

local function pr_base_branch(container, pr_num)
  return Git.pr_base_branch(container, pr_num)
end

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

local function ensure_octo_buffer_loaded(buf)
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  local line_count = vim.api.nvim_buf_line_count(buf)
  local lines = {}
  if line_count > 0 then
    lines = vim.api.nvim_buf_get_lines(buf, 0, math.min(line_count, 3), false)
  end
  local empty = (#lines == 0) or (line_count == 1 and (lines[1] == "" or lines[1] == nil))
  if empty then
    local ok, octo = pcall(require, "octo")
    if ok and type(octo.load_buffer) == "function" then
      pcall(octo.load_buffer, { bufnr = buf })
    end
  end
end

local function octo_pr_ready(buf)
  local octo_buf = _G.octo_buffers and _G.octo_buffers[buf] or nil
  if not octo_buf then
    return false
  end
  local ok, is_pr = pcall(function()
    return octo_buf:isPullRequest()
  end)
  return ok and is_pr
end

local function enable_review_tabline()
  vim.opt.showtabline = 2
  local ok, bufferline = pcall(require, "bufferline")
  if not ok then
    return
  end
  local ok_cfg, cfg = pcall(require, "bufferline.config")
  if not ok_cfg then
    return
  end
  local current = cfg.get and cfg.get() or nil
  local user = (current and current.user) or {}
  user.options = user.options or {}
  if user.options.always_show_bufferline then
    return
  end
  user.options.always_show_bufferline = true
  bufferline.setup(user)
end

local function enable_review_tools()
  local ok_gs, gitsigns = pcall(require, "gitsigns")
  if ok_gs and gitsigns.toggle_signs then
    gitsigns.toggle_signs(false)
    if gitsigns.refresh then
      pcall(gitsigns.refresh)
    end
  end

  local ok_lazy, lazy = pcall(require, "lazy")
  if ok_lazy then
    lazy.load({ plugins = { "mini.diff" }, wait = true })
  end

  local ok_diff, diff = pcall(require, "mini.diff")
  if ok_diff then
    vim.g.minidiff_disable = false
    diff.enable(0)
  end
end

function M.open_review_panels(pr_num, container)
  vim.g.review_session = true
  vim.g.review_pr_num = pr_num
  vim.g.review_octo_panels_opened = false
  vim.g.review_base_ref = nil
  enable_review_tabline()
  enable_review_tools()

  if container and pr_num then
    vim.g.review_base_ref = pr_base_branch(container, pr_num)
    open_octo_pr(container, pr_num)
    local attempts = 0
    local function open_panels()
      if vim.g.review_octo_panels_opened then
        return
      end
      attempts = attempts + 1
      local pr_buf = find_octo_pr_buf(pr_num)
      if pr_buf then
        ensure_octo_buffer_loaded(pr_buf)
        if octo_pr_ready(pr_buf) then
          vim.g.review_octo_panels_opened = true
          local existing_tab = tab_with_buffer(pr_buf)
          if not existing_tab then
            vim.cmd("tabnew")
            vim.api.nvim_win_set_buf(0, pr_buf)
            ensure_octo_buffer_loaded(pr_buf)
          else
            vim.api.nvim_set_current_tabpage(existing_tab)
          end
        end
      end
      if not vim.g.review_octo_panels_opened and attempts < 25 then
        vim.defer_fn(open_panels, 120)
      end
    end
    vim.defer_fn(open_panels, 200)
  end

  vim.defer_fn(function()
    M.open_diffview()
  end, 150)
end

function M.dashboard_review_pr()
  local cwd = vim.fn.getcwd()
  if is_pr_worktree(cwd) then
    local container = Git.container_root(cwd)
    local pr_num = Git.pr_number_from_path(cwd)
    M.open_review_panels(pr_num, container)
    return
  end

  local container = Git.container_root(cwd)
  if not container then
    vim.notify("ReviewPR: not inside a git-wt container", vim.log.levels.WARN)
    return
  end

  local entries = {}
  local pr_glob = container .. "/wt/pr-*"
  for _, p in ipairs(vim.fn.glob(pr_glob, 1, 1)) do
    if vim.fn.isdirectory(p) == 1 then
      local base = vim.fn.fnamemodify(p, ":t")
      local num = base:match("^pr%-(%d+)%-.+$")
      table.insert(entries, { path = p, label = base, pr = num })
    end
  end

  if #entries == 0 then
    vim.notify("ReviewPR: no PR worktrees found under wt/", vim.log.levels.WARN)
    return
  end

  local pr_cache = {}
  local repo = Git.origin_slug(container)
  local host = Git.origin_host(container)

  local function fetch_pr(num)
    if not num or num == "" then
      return { title = "PR info unavailable", body = "" }
    end
    if pr_cache[num] then
      return pr_cache[num]
    end
    if repo == "" then
      pr_cache[num] = { title = "PR info unavailable", body = "" }
      return pr_cache[num]
    end
    if vim.fn.executable("gh") ~= 1 then
      pr_cache[num] = { title = "gh not found", body = "" }
      return pr_cache[num]
    end
    local cmd = {
      "gh",
      "api",
      "--hostname",
      host,
      "repos/" .. repo .. "/pulls/" .. num,
      "--jq",
      '{title:.title,body:(.body // "")}',
    }
    local out = vim.fn.systemlist(cmd)
    local raw = table.concat(out, "\n")
    if vim.v.shell_error ~= 0 or raw == "" then
      pr_cache[num] = { title = "PR info unavailable", body = "" }
      return pr_cache[num]
    end
    local ok, data = pcall(vim.json.decode, raw)
    if not ok or type(data) ~= "table" then
      pr_cache[num] = { title = "PR info unavailable", body = "" }
      return pr_cache[num]
    end
    local body = data.body or ""
    body = body:gsub("\r\n", "\n"):gsub("\r", "\n")
    pr_cache[num] = { title = data.title or "PR info unavailable", body = body }
    return pr_cache[num]
  end

  if LazyVim and LazyVim.pick and LazyVim.pick.picker and LazyVim.pick.picker.name == "snacks" then
    local items = {}
    for _, entry in ipairs(entries) do
      local info = fetch_pr(entry.pr)
      table.insert(items, {
        text = entry.label,
        path = entry.path,
        pr = entry.pr,
        preview = {
          text = ("# %s\n\n%s"):format(info.title, info.body),
          ft = "markdown",
        },
      })
    end

    require("snacks").picker.pick({
      title = "PR worktrees",
      items = items,
      format = "text",
      preview = "preview",
      confirm = function(picker, item)
        picker:close()
        if not item or not item.path then
          return
        end
        vim.cmd("cd " .. vim.fn.fnameescape(item.path))
        local pr_num = Git.pr_number_from_path(item.path)
        M.open_review_panels(pr_num, container)
      end,
    })
    return
  end

  vim.ui.select(entries, {
    prompt = "PR worktree",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    vim.cmd("cd " .. vim.fn.fnameescape(choice.path))
    local pr_num = Git.pr_number_from_path(choice.path)
    M.open_review_panels(pr_num, container)
  end)
end

function M.container_root(start)
  return Git.container_root(start or vim.fn.getcwd())
end

function M.review_pr_command()
  M.dashboard_review_pr()
end

return M
