local assert = require("luassert")
local stub = require("luassert.stub")

describe("pier.init", function()
  local Pier
  local state
  local notifications
  local diffview_calls
  local octo_calls
  local integration_calls
  local command_callback
  local snacks_pick_calls
  local review_buf
  local notify_stub
  local defer_stub
  local wait_stub
  local select_stub
  local filereadable_stub
  local cmd_stub
  local getcwd_stub
  local create_command_stub
  local create_autocmd_stub
  local create_augroup_stub
  local tab_valid_stub
  local set_current_tab_stub

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

  before_each(function()
    notifications = {}
    diffview_calls = {}
    octo_calls = {}
    integration_calls = {}
    command_callback = nil
    snacks_pick_calls = {}
    _G.LazyVim = nil
    package.loaded["snacks"] = nil

    notify_stub = stub(vim, "notify", function(message, level)
      table.insert(notifications, { message = message, level = level })
    end)
    defer_stub = stub(vim, "defer_fn", function(fn, _)
      fn()
    end)
    wait_stub = stub(vim, "wait", function(timeout, condition, interval)
      local deadline = math.max(1, math.floor(timeout / math.max(interval or 100, 1)))
      for _ = 1, deadline do
        if condition() then
          return true
        end
      end
      return false
    end)
    select_stub = stub(vim.ui, "select", function(_, _, cb)
      cb(nil)
    end)
    filereadable_stub = stub(vim.fn, "filereadable", function(path)
      return path ~= "" and 1 or 0
    end)
    getcwd_stub = stub(vim.fn, "getcwd", function()
      return "/tmp/container/wt/pr-7-feature"
    end)
    cmd_stub = stub(vim, "cmd", function(cmd)
      table.insert(diffview_calls, { "vim.cmd", cmd })
    end)

    review_buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(review_buf)
    vim.api.nvim_buf_set_name(review_buf, "/tmp/container/wt/pr-7-feature/lua/pier/init.lua")

    package.loaded["pier.context.git_wt"] = {
      is_pr_worktree = function(path)
        return path == "/tmp/container/wt/pr-7-feature"
      end,
      container_root = function(path)
        if path == "/tmp/container/wt/pr-7-feature" or path == "/tmp/container/wt/pr-11-feature" then
          return "/tmp/container"
        end
        return nil
      end,
      pr_number_from_path = function(path)
        if path == "/tmp/container/wt/pr-7-feature" then
          return "7"
        end
        return nil
      end,
      pr_worktree_entries = function()
        return {}
      end,
    }

    package.loaded["pier.git"] = {
      container_root = function(path)
        if path == "/tmp/container/wt/pr-7-feature" then
          return "/tmp/container"
        end
        return nil
      end,
      review_repo_root = function(path)
        if path == "/tmp/container/wt/pr-7-feature" then
          return "/tmp/container/wt/pr-7-feature"
        end
        if path == "/tmp/container/wt/pr-11-feature" then
          return "/tmp/container/wt/pr-11-feature"
        end
        return nil
      end,
      default_branch = function()
        return "main"
      end,
    }

    package.loaded["pier.github"] = {
      first_failed_host_check = function()
        return nil
      end,
      pr_base_branch = function()
        return "main"
      end,
      fetch_pr_summary = function()
        return { title = "PR", body = "" }
      end,
    }

    package.loaded["pier.core.diffview"] = {
      open = function(repo_dir, base_ref)
        table.insert(diffview_calls, { "open", repo_dir, base_ref })
        return true
      end,
      close = function()
        table.insert(diffview_calls, { "close" })
      end,
    }

    package.loaded["pier.core.octo"] = {
      open_pr = function(container, pr_num)
        table.insert(octo_calls, { "open_pr", container, pr_num })
        return { opened = true, tab = 23, created = true }
      end,
      close_tab = function(tab, created)
        table.insert(octo_calls, { "close_tab", tab, created })
      end,
    }

    package.loaded["pier.integrations.ui"] = {
      capture = function()
        table.insert(integration_calls, { "ui", "capture" })
        return "ui-snapshot"
      end,
      apply = function(_, snapshot)
        table.insert(integration_calls, { "ui", "apply", snapshot })
      end,
      restore = function(_, snapshot)
        table.insert(integration_calls, { "ui", "restore", snapshot })
      end,
    }
    package.loaded["pier.integrations.gitsigns"] = {
      capture = function()
        table.insert(integration_calls, { "gitsigns", "capture" })
        return "gitsigns-snapshot"
      end,
      apply = function(_, snapshot)
        table.insert(integration_calls, { "gitsigns", "apply", snapshot })
      end,
      restore = function(_, snapshot)
        table.insert(integration_calls, { "gitsigns", "restore", snapshot })
      end,
    }
    package.loaded["pier.integrations.mini_diff"] = {
      capture = function()
        table.insert(integration_calls, { "mini_diff", "capture" })
        return "mini-diff-snapshot"
      end,
      apply = function(_, snapshot)
        table.insert(integration_calls, { "mini_diff", "apply", snapshot })
      end,
      restore = function(_, snapshot)
        table.insert(integration_calls, { "mini_diff", "restore", snapshot })
      end,
    }

    package.loaded["pier.init"] = nil
    package.loaded["pier.session"] = nil
    state = require("pier.session")
    reset_session()
    Pier = require("pier.init")
  end)

  after_each(function()
    if create_command_stub then
      create_command_stub:revert()
      create_command_stub = nil
    end
    if create_autocmd_stub then
      create_autocmd_stub:revert()
      create_autocmd_stub = nil
    end
    if create_augroup_stub then
      create_augroup_stub:revert()
      create_augroup_stub = nil
    end
    if tab_valid_stub then
      tab_valid_stub:revert()
      tab_valid_stub = nil
    end
    if set_current_tab_stub then
      set_current_tab_stub:revert()
      set_current_tab_stub = nil
    end
    notify_stub:revert()
    defer_stub:revert()
    wait_stub:revert()
    select_stub:revert()
    filereadable_stub:revert()
    getcwd_stub:revert()
    cmd_stub:revert()

    if review_buf and vim.api.nvim_buf_is_valid(review_buf) then
      vim.api.nvim_buf_delete(review_buf, { force = true })
    end
    review_buf = nil

    reset_session()

    package.loaded["pier.context.git_wt"] = nil
    package.loaded["pier.git"] = nil
    package.loaded["pier.github"] = nil
    package.loaded["pier.core.diffview"] = nil
    package.loaded["pier.core.octo"] = nil
    package.loaded["pier.integrations.ui"] = nil
    package.loaded["pier.integrations.gitsigns"] = nil
    package.loaded["pier.integrations.mini_diff"] = nil
    package.loaded["snacks"] = nil
    package.loaded["octo.reviews"] = nil
    package.preload["octo.reviews"] = nil
    package.loaded["pier.init"] = nil
    package.loaded["pier.session"] = nil
    _G.LazyVim = nil
  end)

  it("opens a session from a PR worktree and closes it cleanly", function()
    assert.is_true(Pier.open())
    assert.is_true(state.active)
    assert.equals("/tmp/container", state.container)
    assert.equals("7", state.pr_num)
    assert.equals("/tmp/container/wt/pr-7-feature", state.repo_dir)
    assert.equals("main", state.base_ref)
    assert.equals(review_buf, state.review_buf)
    assert.are.same({
      { "ui", "capture" },
      { "gitsigns", "capture" },
      { "mini_diff", "capture" },
      { "ui", "apply", "ui-snapshot" },
      { "gitsigns", "apply", "gitsigns-snapshot" },
      { "mini_diff", "apply", "mini-diff-snapshot" },
    }, integration_calls)
    assert.are.same({
      { "open", "/tmp/container/wt/pr-7-feature", "main" },
    }, diffview_calls)

    Pier.close()
    assert.is_false(state.active)
    assert.are.same({
      { "open", "/tmp/container/wt/pr-7-feature", "main" },
      { "close" },
    }, diffview_calls)
    assert.are.same({
      { "close_tab", nil, false },
    }, octo_calls)
    assert.are.same({
      { "ui", "capture" },
      { "gitsigns", "capture" },
      { "mini_diff", "capture" },
      { "ui", "apply", "ui-snapshot" },
      { "gitsigns", "apply", "gitsigns-snapshot" },
      { "mini_diff", "apply", "mini-diff-snapshot" },
      { "mini_diff", "restore", "mini-diff-snapshot" },
      { "gitsigns", "restore", "gitsigns-snapshot" },
      { "ui", "restore", "ui-snapshot" },
    }, integration_calls)
  end)

  it("does not activate a session when Diffview fails to open", function()
    package.loaded["pier.core.diffview"] = {
      open = function(repo_dir, base_ref)
        table.insert(diffview_calls, { "open", repo_dir, base_ref })
        return false
      end,
      close = function()
        table.insert(diffview_calls, { "close" })
      end,
    }
    package.loaded["pier.init"] = nil
    Pier = require("pier.init")

    assert.is_false(Pier.open())
    assert.is_false(state.active)
    assert.equals(nil, state.container)
    assert.equals(nil, state.base_ref)
    assert.are.same({}, integration_calls)
    assert.are.same({
      { "open", "/tmp/container/wt/pr-7-feature", "main" },
    }, diffview_calls)
  end)

  it("returns false when Diffview fails to open from a PR worktree", function()
    package.loaded["pier.core.diffview"] = {
      open = function(repo_dir, base_ref)
        table.insert(diffview_calls, { "open", repo_dir, base_ref })
        return false
      end,
      close = function()
        table.insert(diffview_calls, { "close" })
      end,
    }
    package.loaded["pier.init"] = nil
    Pier = require("pier.init")

    assert.is_false(Pier.open())
    assert.is_false(state.active)
    assert.are.same({
      { "open", "/tmp/container/wt/pr-7-feature", "main" },
    }, diffview_calls)
  end)

  it("registers the :Pier command and dispatches subcommands", function()
    local created_commands = {}

    create_command_stub = stub(vim.api, "nvim_create_user_command", function(name, cb, opts)
      created_commands[name] = { callback = cb, opts = opts }
      command_callback = cb
    end)
    create_autocmd_stub = stub(vim.api, "nvim_create_autocmd", function() end)
    create_augroup_stub = stub(vim.api, "nvim_create_augroup", function()
      return 1
    end)

    Pier.setup()
    assert.is_table(created_commands.Pier)
    assert.is_function(command_callback)

    command_callback({ args = "status" })
    assert.equals("Pier: inactive", notifications[#notifications].message)

    command_callback({ args = "octo invalid" })
    assert.equals("Pier: invalid octo subcommand: invalid", notifications[#notifications].message)
  end)

  it("uses the snacks picker when LazyVim is configured for snacks", function()
    getcwd_stub:revert()
    getcwd_stub = stub(vim.fn, "getcwd", function()
      return "/tmp/container"
    end)
    package.loaded["pier.context.git_wt"] = {
      is_pr_worktree = function(path)
        return path == "/tmp/container/wt/pr-7-feature"
      end,
      container_root = function(path)
        if path == "/tmp/container" or path == "/tmp/container/wt/pr-7-feature" then
          return "/tmp/container"
        end
        return nil
      end,
      pr_number_from_path = function(path)
        if path == "/tmp/container/wt/pr-7-feature" then
          return "7"
        end
        return nil
      end,
      pr_worktree_entries = function()
        return {
          { label = "PR #7 feature", path = "/tmp/container/wt/pr-7-feature", pr = "7" },
        }
      end,
    }
    package.loaded["pier.github"] = {
      first_failed_host_check = function()
        return nil
      end,
      pr_base_branch = function()
        return "develop"
      end,
      fetch_pr_summary = function(_, pr_num)
        return { title = "Feature " .. pr_num, body = "Preview body" }
      end,
    }
    _G.LazyVim = {
      pick = {
        picker = {
          name = "snacks",
        },
      },
    }
    package.loaded["snacks"] = {
      picker = {
        pick = function(opts)
          table.insert(snacks_pick_calls, opts)
          opts.confirm({
            close = function()
              table.insert(snacks_pick_calls, { closed = true })
            end,
          }, opts.items[1])
        end,
      },
    }
    package.loaded["pier.session"] = nil
    state = require("pier.session")
    reset_session()
    package.loaded["pier.init"] = nil
    Pier = require("pier.init")

    assert.is_true(Pier.open())
    assert.equals(2, #snacks_pick_calls)
    assert.equals("PR worktrees", snacks_pick_calls[1].title)
    assert.are.same({
      text = "# Feature 7\n\nPreview body",
      ft = "markdown",
    }, snacks_pick_calls[1].items[1].preview)
    assert.are.same({ closed = true }, snacks_pick_calls[2])
    assert.are.same({
      { "vim.cmd", "cd /tmp/container/wt/pr-7-feature" },
      { "open", "/tmp/container/wt/pr-7-feature", "develop" },
    }, diffview_calls)
    assert.are.same({}, notifications)
  end)

  it("falls back to vim.ui.select when snacks is configured but unavailable", function()
    getcwd_stub:revert()
    getcwd_stub = stub(vim.fn, "getcwd", function()
      return "/tmp/container"
    end)
    package.loaded["pier.context.git_wt"] = {
      is_pr_worktree = function(path)
        return path == "/tmp/container/wt/pr-7-feature"
      end,
      container_root = function(path)
        if path == "/tmp/container" or path == "/tmp/container/wt/pr-7-feature" then
          return "/tmp/container"
        end
        return nil
      end,
      pr_number_from_path = function(path)
        if path == "/tmp/container/wt/pr-7-feature" then
          return "7"
        end
        return nil
      end,
      pr_worktree_entries = function()
        return {
          { label = "PR #7 feature", path = "/tmp/container/wt/pr-7-feature", pr = "7" },
        }
      end,
    }
    package.loaded["pier.github"] = {
      first_failed_host_check = function()
        return nil
      end,
      pr_base_branch = function()
        return "develop"
      end,
      fetch_pr_summary = function(_, pr_num)
        return { title = "Feature " .. pr_num, body = "Preview body" }
      end,
    }
    _G.LazyVim = {
      pick = {
        picker = {
          name = "snacks",
        },
      },
    }
    package.loaded["snacks"] = nil
    package.preload["snacks"] = function()
      error("snacks missing")
    end
    select_stub:revert()
    select_stub = stub(vim.ui, "select", function(items, _, cb)
      cb(items[1])
    end)
    package.loaded["pier.session"] = nil
    state = require("pier.session")
    reset_session()
    package.loaded["pier.init"] = nil
    Pier = require("pier.init")

    assert.is_true(Pier.open())
    assert.are.same({
      { "vim.cmd", "cd /tmp/container/wt/pr-7-feature" },
      { "open", "/tmp/container/wt/pr-7-feature", "develop" },
    }, diffview_calls)
    assert.equals(
      "Pier: snacks picker unavailable; falling back to vim.ui.select",
      notifications[#notifications].message
    )
  end)

  it("opens Octo from the active session when the host check passes", function()
    assert.is_true(Pier.open())

    local result = Pier.open_octo()

    assert.is_true(result)
    assert.are.same({
      { "open_pr", "/tmp/container", "7" },
    }, octo_calls)
    assert.equals(true, state.octo_opened)
    assert.equals(23, state.octo_tab)
    assert.equals(true, state.octo_tab_created)
  end)

  it("refuses to open Octo when the review host check fails", function()
    package.loaded["pier.github"] = {
      first_failed_host_check = function()
        return { ok = false, message = "Pier: host is not supported" }
      end,
      pr_base_branch = function()
        return "main"
      end,
      fetch_pr_summary = function()
        return { title = "PR", body = "" }
      end,
    }
    package.loaded["pier.init"] = nil
    Pier = require("pier.init")

    assert.is_true(Pier.open())
    assert.is_false(Pier.open_octo())
    assert.equals("Pier: host is not supported", notifications[#notifications].message)
    assert.are.same({}, octo_calls)
  end)

  it("opens the current review file in Octo and focuses the session tab", function()
    local review = {
      layout = {
        files = {
          { path = "lua/pier/init.lua" },
        },
        set_current_file = function(_, file, side)
          table.insert(octo_calls, { "set_current_file", file.path, side })
        end,
      },
    }

    package.loaded["octo.reviews"] = {
      get_current_review = function()
        return review
      end,
      start_or_resume_review = function()
        table.insert(octo_calls, { "start_or_resume_review" })
      end,
    }
    tab_valid_stub = stub(vim.api, "nvim_tabpage_is_valid", function(tab)
      return tab == 23
    end)
    set_current_tab_stub = stub(vim.api, "nvim_set_current_tabpage", function(tab)
      table.insert(octo_calls, { "set_current_tabpage", tab })
    end)

    assert.is_true(Pier.open())
    assert.is_true(Pier.open_octo_file())
    assert.are.same({
      { "open_pr", "/tmp/container", "7" },
      { "set_current_tabpage", 23 },
      { "start_or_resume_review" },
      { "set_current_file", "lua/pier/init.lua", "right" },
    }, octo_calls)
  end)

  it("warns when Octo file open cannot determine the current review file", function()
    vim.api.nvim_buf_set_name(review_buf, "/tmp/outside/file.txt")

    assert.is_true(Pier.open())
    assert.is_false(Pier.open_octo_file())
    assert.equals("Pier: could not determine review file from current context", notifications[#notifications].message)
  end)

  it("cleans up Octo state when file focusing fails after opening the PR tab", function()
    package.preload["octo.reviews"] = function()
      error("octo.reviews unavailable")
    end
    tab_valid_stub = stub(vim.api, "nvim_tabpage_is_valid", function(tab)
      return tab == 23
    end)
    set_current_tab_stub = stub(vim.api, "nvim_set_current_tabpage", function(tab)
      table.insert(octo_calls, { "set_current_tabpage", tab })
    end)

    assert.is_true(Pier.open())
    assert.is_false(Pier.open_octo_file("lua/pier/missing.lua"))
    assert.are.same({
      { "open_pr", "/tmp/container", "7" },
      { "set_current_tabpage", 23 },
      { "close_tab", 23, true },
    }, octo_calls)
    assert.is_false(state.octo_opened)
    assert.equals(nil, state.octo_tab)
    assert.equals(false, state.octo_tab_created)
  end)

  it("returns false when Octo review file never becomes available", function()
    package.loaded["octo.reviews"] = {
      get_current_review = function()
        return { layout = nil }
      end,
      start_or_resume_review = function()
        table.insert(octo_calls, { "start_or_resume_review" })
      end,
    }
    defer_stub:revert()
    defer_stub = stub(vim, "defer_fn", function(fn, _)
      fn()
    end)
    tab_valid_stub = stub(vim.api, "nvim_tabpage_is_valid", function(tab)
      return tab == 23
    end)
    set_current_tab_stub = stub(vim.api, "nvim_set_current_tabpage", function(tab)
      table.insert(octo_calls, { "set_current_tabpage", tab })
    end)

    assert.is_true(Pier.open())
    assert.is_false(Pier.open_octo_file("lua/pier/init.lua"))
    assert.equals("Pier: failed to open Octo review for PR #7", notifications[#notifications].message)
    assert.are.same({
      { "open_pr", "/tmp/container", "7" },
      { "set_current_tabpage", 23 },
      { "start_or_resume_review" },
      { "close_tab", 23, true },
    }, octo_calls)
    assert.is_false(state.octo_opened)
  end)
end)
