local Context = require("pier.context.git_wt")
local CoreDiffview = require("pier.core.diffview")
local CoreOcto = require("pier.core.octo")
local Git = require("pier.git")
local GitHub = require("pier.github")
local state = require("pier.session")

local M = {}

local integrations = {
  { name = "ui", mod = require("pier.integrations.ui") },
  { name = "gitsigns", mod = require("pier.integrations.gitsigns") },
  { name = "mini_diff", mod = require("pier.integrations.mini_diff") },
}

local setup_done = false

---@class PierIntegration
---@field name string
---@field mod { capture: fun(state: PierSessionState): any, apply: fun(state: PierSessionState, snapshot: any), restore: fun(state: PierSessionState, snapshot: any) }

---@class PierTarget
---@field container string
---@field pr_num string
---@field repo_dir string

---@param value string|nil
---@return boolean
local function has_text(value)
  return type(value) == "string" and value ~= ""
end

---@param message string
local function notify_warn(message)
  vim.notify(message, vim.log.levels.WARN)
end

---@param message string
local function notify_info(message)
  vim.notify(message, vim.log.levels.INFO)
end

---@param status ReviewGitStatus
local function notify_status(status)
  if status.message then
    vim.notify(status.message, vim.log.levels.WARN)
  end
end

---@param path string
---@return string
local function normalize_relative_path(path)
  local normalized = vim.fs.normalize(path)
  normalized = normalized:gsub("^%./", "")
  normalized = normalized:gsub("^/", "")
  return normalized
end

---@param path string
---@return string|nil
local function container_for_review(path)
  local container = Context.container_root(path)
  if not container then
    notify_warn("Pier: not inside a git-wt container")
    return nil
  end
  return container
end

---@param container string
---@return boolean
local function review_host_ready(container)
  local failed = GitHub.first_failed_host_check(container)
  if failed then
    notify_status(failed)
    return false
  end
  return true
end

---@param left string|number|nil
---@param right string|number|nil
---@return boolean
local function same_pr(left, right)
  return left ~= nil and right ~= nil and tostring(left) == tostring(right)
end

---@param path string|nil
---@return boolean
local function is_path_in_repo(path)
  return has_text(path) and vim.fn.filereadable(path) == 1
end

---@param buf integer|nil
---@param repo_dir string|nil
---@return boolean
local function is_review_buffer(buf, repo_dir)
  if type(buf) ~= "number" or not vim.api.nvim_buf_is_valid(buf) or not has_text(repo_dir) then
    return false
  end
  if vim.bo[buf].buftype ~= "" then
    return false
  end
  local name = vim.api.nvim_buf_get_name(buf)
  if not is_path_in_repo(name) then
    return false
  end
  local normalized_name = vim.fs.normalize(name)
  local normalized_repo = vim.fs.normalize(repo_dir)
  return normalized_name == normalized_repo or vim.startswith(normalized_name, normalized_repo .. "/")
end

---@return integer|nil
local function current_review_buffer(repo_dir)
  local buf = vim.api.nvim_get_current_buf()
  if is_review_buffer(buf, repo_dir) then
    return buf
  end
  return nil
end

---@param name string
---@return PierIntegration|nil
local function integration_by_name(name)
  for _, integration in ipairs(integrations) do
    if integration.name == name then
      return integration
    end
  end
  return nil
end

---@param buf integer|nil
local function set_review_buffer(buf)
  if buf == state.review_buf then
    return
  end

  local previous = state.review_buf
  state.review_buf = buf

  local mini_diff = integration_by_name("mini_diff")
  if not mini_diff then
    return
  end

  local ok_diff, diff = pcall(require, "mini.diff")
  if ok_diff and type(previous) == "number" and previous ~= buf and vim.api.nvim_buf_is_valid(previous) then
    diff.disable(previous)
  end

  if type(buf) == "number" and vim.api.nvim_buf_is_valid(buf) then
    local ok = pcall(mini_diff.mod.apply, state, state.integration_state[mini_diff.name])
    if not ok then
      notify_warn("Pier: failed to apply mini.diff integration")
    end
  end
end

---@param path string|nil
---@return PierTarget|nil
local function target_from_pr_path(path)
  if not has_text(path) or not Context.is_pr_worktree(path) then
    return nil
  end
  local container = container_for_review(path)
  if not container then
    return nil
  end
  local pr_num = Context.pr_number_from_path(path)
  local repo_dir = Git.review_repo_root(path)
  if not (has_text(pr_num) and has_text(repo_dir)) then
    notify_warn("Pier: could not determine PR review target from path")
    return nil
  end
  return {
    container = container,
    pr_num = pr_num,
    repo_dir = repo_dir,
  }
end

---@return PierTarget|nil
local function active_target()
  if not (state.active and has_text(state.container) and has_text(state.repo_dir) and state.pr_num) then
    return nil
  end
  return {
    container = state.container,
    pr_num = tostring(state.pr_num),
    repo_dir = state.repo_dir,
  }
end

---@param target PierTarget
---@return boolean
local function target_matches_session(target)
  return has_text(state.container)
    and has_text(state.repo_dir)
    and same_pr(state.pr_num, target.pr_num)
    and vim.fs.normalize(state.container) == vim.fs.normalize(target.container)
    and vim.fs.normalize(state.repo_dir) == vim.fs.normalize(target.repo_dir)
end

---@param path string|nil
---@return PierTarget|nil
local function session_or_path_target(path)
  local session_target = active_target()
  local path_target = target_from_pr_path(path)

  if session_target then
    if path_target and not target_matches_session(path_target) then
      notify_warn(
        ("Pier: active session is pinned to PR #%s; run `:Pier close` before opening a different review"):format(
          tostring(state.pr_num)
        )
      )
      return nil
    end
    return session_target
  end

  return path_target
end

---@param path string
---@param repo_dir string
---@return string|nil
local function repo_relative_path(path, repo_dir)
  if not (has_text(path) and has_text(repo_dir)) then
    return nil
  end

  local normalized_path = vim.fs.normalize(path)
  local normalized_repo = vim.fs.normalize(repo_dir)
  if normalized_path == normalized_repo then
    return nil
  end

  local prefix = normalized_repo .. "/"
  if not vim.startswith(normalized_path, prefix) then
    return nil
  end

  return normalize_relative_path(normalized_path:sub(#prefix + 1))
end

---@param target PierTarget
---@return string|nil
local function current_context_file(target)
  local ok_diffview, diffview_lib = pcall(require, "diffview.lib")
  if ok_diffview then
    local view = diffview_lib.get_current_view()
    if view and type(view.infer_cur_file) == "function" then
      local file = view:infer_cur_file(false)
      if file and has_text(file.path) then
        return normalize_relative_path(file.path)
      end
    end
  end

  local buf = vim.api.nvim_get_current_buf()
  if not is_review_buffer(buf, target.repo_dir) then
    return nil
  end

  return repo_relative_path(vim.api.nvim_buf_get_name(buf), target.repo_dir)
end

---@param target PierTarget
---@param path string
---@return boolean
local function focus_octo_review_file(target, path)
  local ok_reviews, reviews = pcall(require, "octo.reviews")
  if not ok_reviews then
    notify_warn("Pier: failed to load Octo review internals")
    return false
  end

  local normalized_path = normalize_relative_path(path)
  local attempts = 0
  local max_attempts = 20

  local function try_focus()
    attempts = attempts + 1

    local review = reviews.get_current_review()
    local files = review and review.layout and review.layout.files or nil
    if not files then
      if attempts == 1 then
        reviews.start_or_resume_review()
      end
      if attempts < max_attempts then
        vim.defer_fn(try_focus, 100)
      else
        notify_warn(("Pier: failed to open Octo review for PR #%s"):format(target.pr_num))
      end
      return
    end

    for _, file in ipairs(files) do
      if normalize_relative_path(file.path) == normalized_path then
        review.layout:set_current_file(file, "right")
        return
      end
    end

    notify_warn(("Pier: file is unchanged or not part of current PR review: %s"):format(normalized_path))
  end

  try_focus()
  return true
end

local function capture_integrations()
  state.integration_state = {}
  for _, integration in ipairs(integrations) do
    local ok, snapshot = pcall(integration.mod.capture, state)
    if ok then
      state.integration_state[integration.name] = snapshot
    else
      notify_warn(("Pier: failed to capture %s integration state"):format(integration.name))
      state.integration_state[integration.name] = nil
    end
  end
end

local function apply_integrations()
  for _, integration in ipairs(integrations) do
    local ok = pcall(integration.mod.apply, state, state.integration_state[integration.name])
    if not ok then
      notify_warn(("Pier: failed to apply %s integration"):format(integration.name))
    end
  end
end

local function restore_integrations()
  for i = #integrations, 1, -1 do
    local integration = integrations[i]
    local ok = pcall(integration.mod.restore, state, state.integration_state[integration.name])
    if not ok then
      notify_warn(("Pier: failed to restore %s integration"):format(integration.name))
    end
  end
end

---@param target PierTarget
local function start_session(target)
  state.active = true
  state.container = target.container
  state.pr_num = target.pr_num
  state.base_ref = nil
  state.repo_dir = target.repo_dir
  state.review_buf = current_review_buffer(target.repo_dir)
  capture_integrations()
  apply_integrations()
end

local function reset_session()
  state.active = false
  state.container = nil
  state.pr_num = nil
  state.base_ref = nil
  state.repo_dir = nil
  state.review_buf = nil
  state.octo_opened = false
  state.octo_tab = nil
  state.octo_tab_created = false
  state.integration_state = {}
end

local function show_status()
  if not state.active then
    notify_info("Pier: inactive")
    return
  end

  local lines = {
    ("Pier: active on PR #%s"):format(tostring(state.pr_num)),
    ("repo: %s"):format(state.repo_dir or "unknown"),
    ("container: %s"):format(state.container or "unknown"),
    ("base: %s"):format(state.base_ref or "unknown"),
    ("octo: %s"):format(state.octo_opened and "open" or "closed"),
  }
  notify_info(table.concat(lines, "\n"))
end

function M.open_diffview()
  local repo_dir = state.repo_dir or vim.fn.getcwd()
  local base_ref = state.base_ref or Git.default_branch(repo_dir)
  return CoreDiffview.open(repo_dir, base_ref)
end

---@return boolean
function M.open_octo()
  local target = session_or_path_target(vim.fn.getcwd())
  if not target then
    notify_warn("Pier: Octo can only be opened from an active session or a PR worktree")
    return false
  end

  if not review_host_ready(target.container) then
    return false
  end

  local octo = CoreOcto.open_pr(target.container, target.pr_num)
  if not octo.opened then
    notify_warn(("Pier: failed to open Octo PR #%s"):format(target.pr_num))
    return false
  end

  state.octo_opened = true
  state.octo_tab = octo.tab
  state.octo_tab_created = octo.created
  return true
end

---@param path string|nil
---@return boolean
function M.open_octo_file(path)
  local target = session_or_path_target(vim.fn.getcwd())
  if not target then
    notify_warn("Pier: Octo can only be opened from an active session or a PR worktree")
    return false
  end

  local relative_path = has_text(path) and normalize_relative_path(path) or current_context_file(target)
  if not has_text(relative_path) then
    notify_warn("Pier: could not determine review file from current context")
    return false
  end

  if not M.open_octo() then
    return false
  end

  if state.octo_tab and vim.api.nvim_tabpage_is_valid(state.octo_tab) then
    vim.api.nvim_set_current_tabpage(state.octo_tab)
  end

  return focus_octo_review_file(target, relative_path)
end

---@param target PierTarget
---@return boolean
local function open_panels(target)
  start_session(target)
  state.base_ref = GitHub.pr_base_branch(target.container, target.pr_num)

  vim.defer_fn(function()
    M.open_diffview()
  end, 150)

  return true
end

local function pick_pr()
  local cwd = vim.fn.getcwd()
  if Context.is_pr_worktree(cwd) then
    local target = target_from_pr_path(cwd)
    if not target then
      return false
    end
    return open_panels(target)
  end

  local container = container_for_review(cwd)
  if not container then
    return false
  end

  local entries = Context.pr_worktree_entries(container)
  if #entries == 0 then
    notify_warn("Pier: no PR worktrees found under wt/")
    return false
  end

  local pr_cache = {}
  local function fetch_pr(num)
    if not has_text(num) then
      return { title = "PR info unavailable", body = "" }
    end
    if not pr_cache[num] then
      pr_cache[num] = GitHub.fetch_pr_summary(container, num)
    end
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
        local target = target_from_pr_path(item.path)
        if target then
          open_panels(target)
        end
      end,
    })
    return true
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
    local target = target_from_pr_path(choice.path)
    if target then
      open_panels(target)
    end
  end)
  return true
end

function M.open()
  if state.active then
    session_or_path_target(vim.fn.getcwd())
    return true
  end
  return pick_pr()
end

function M.close()
  CoreDiffview.close()
  CoreOcto.close_tab(state.octo_tab, state.octo_tab_created)
  restore_integrations()
  reset_session()
end

function M.toggle()
  if state.active then
    M.close()
    return true
  end
  return pick_pr()
end

function M.status()
  show_status()
end

M.octo = {
  open = function(path)
    if path == nil then
      return M.open_octo()
    end
    return M.open_octo_file(path)
  end,
  open_file = M.open_octo_file,
}

function M.container_root(start)
  return Context.container_root(start or vim.fn.getcwd())
end

function M.is_active()
  return state.active
end

---@param buf integer|nil
function M.track_review_buffer(buf)
  if not (state.active and has_text(state.repo_dir)) then
    return
  end
  if is_review_buffer(buf, state.repo_dir) then
    set_review_buffer(buf)
  end
end

local function parse_pier_command(opts)
  local args = vim.split(vim.trim(opts.args or ""), "%s+", { plain = false, trimempty = true })
  local cmd = args[1]

  if not cmd then
    notify_warn("Pier: missing subcommand")
    return
  end

  if cmd == "open" then
    M.open()
  elseif cmd == "close" then
    M.close()
  elseif cmd == "toggle" then
    M.toggle()
  elseif cmd == "status" then
    M.status()
  elseif cmd == "octo" then
    local octo_cmd = args[2]
    if not octo_cmd then
      M.open_octo()
    elseif octo_cmd == "open" then
      local path = table.concat(vim.list_slice(args, 3), " ")
      M.open_octo_file(path ~= "" and path or nil)
    else
      notify_warn(("Pier: invalid octo subcommand: %s"):format(octo_cmd))
    end
  else
    notify_warn(("Pier: invalid subcommand: %s"):format(cmd))
  end
end

function M.setup()
  if setup_done then
    return
  end
  setup_done = true

  vim.api.nvim_create_user_command("Pier", function(opts)
    parse_pier_command(opts)
  end, { nargs = "*" })

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("PierDiffviewWhichKey", { clear = true }),
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
    group = vim.api.nvim_create_augroup("PierDisableMiniDiffOcto", { clear = true }),
    pattern = "octo",
    callback = function(ev)
      vim.b[ev.buf].minidiff_disable = true
      local ok, md = pcall(require, "mini.diff")
      if ok then
        md.disable(ev.buf)
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("PierBufferTracking", { clear = true }),
    callback = function(ev)
      M.track_review_buffer(ev.buf)
    end,
  })
end

return M
