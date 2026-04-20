local assert = require("luassert")
local stub = require("luassert.stub")

describe("pier.core.octo", function()
  local Octo
  local GitStub
  local cmd_calls
  local current_tab
  local set_current_tab_stub
  local cmd_stub
  local exists_stub
  local bufnr_stub
  local fnameescape_stub
  local list_tabpages_stub
  local tabpage_list_wins_stub
  local win_get_buf_stub
  local buf_is_valid_stub
  local get_current_tab_stub
  local tabpage_is_valid_stub
  local temp_get_current_tab_stub

  before_each(function()
    cmd_calls = {}
    current_tab = 10

    GitStub = {
      origin_slug = function()
        return "owner/repo"
      end,
      origin_host = function()
        return "github.com"
      end,
    }

    package.loaded["pier.git"] = GitStub
    package.loaded["lazy"] = {
      load = function() end,
    }

    exists_stub = stub(vim.fn, "exists", function(command)
      return command == ":Octo" and 2 or 0
    end)
    bufnr_stub = stub(vim.fn, "bufnr", function()
      return -1
    end)
    fnameescape_stub = stub(vim.fn, "fnameescape", function(value)
      return value
    end)
    cmd_stub = stub(vim, "cmd", function(command)
      table.insert(cmd_calls, command)
    end)
    set_current_tab_stub = stub(vim.api, "nvim_set_current_tabpage", function(tab)
      current_tab = tab
    end)

    list_tabpages_stub = stub(vim.api, "nvim_list_tabpages", function()
      return { 10, 11 }
    end)
    tabpage_list_wins_stub = stub(vim.api, "nvim_tabpage_list_wins", function(tab)
      return tab == 11 and { 21 } or {}
    end)
    win_get_buf_stub = stub(vim.api, "nvim_win_get_buf", function(win)
      return win == 21 and 42 or -1
    end)
    buf_is_valid_stub = stub(vim.api, "nvim_buf_is_valid", function(buf)
      return buf == 42
    end)
    get_current_tab_stub = stub(vim.api, "nvim_get_current_tabpage", function()
      return current_tab
    end)
    tabpage_is_valid_stub = stub(vim.api, "nvim_tabpage_is_valid", function(tab)
      return tab == 11
    end)

    package.loaded["pier.core.octo"] = nil
    Octo = require("pier.core.octo")
  end)

  after_each(function()
    set_current_tab_stub:revert()
    cmd_stub:revert()
    exists_stub:revert()
    bufnr_stub:revert()
    fnameescape_stub:revert()
    list_tabpages_stub:revert()
    tabpage_list_wins_stub:revert()
    win_get_buf_stub:revert()
    buf_is_valid_stub:revert()
    get_current_tab_stub:revert()
    tabpage_is_valid_stub:revert()
    if temp_get_current_tab_stub then
      temp_get_current_tab_stub:revert()
      temp_get_current_tab_stub = nil
    end
    package.loaded["pier.git"] = nil
    package.loaded["lazy"] = nil
    package.loaded["pier.core.octo"] = nil
  end)

  it("reuses an existing PR tab when the octo buffer is already open", function()
    bufnr_stub:revert()
    bufnr_stub = stub(vim.fn, "bufnr", function(uri)
      if uri == "octo://owner/repo/pull/7" then
        return 42
      end
      return -1
    end)

    local result = Octo.open_pr("/tmp/container", "7")

    assert.are.same({ opened = true, tab = 11, created = false }, result)
    assert.are.same({}, cmd_calls)
    assert.stub(set_current_tab_stub).was_called_with(11)
  end)

  it("opens a new tab with a host-qualified URI for non-github hosts", function()
    GitStub.origin_host = function()
      return "git.example.com"
    end
    get_current_tab_stub:revert()
    temp_get_current_tab_stub = stub(vim.api, "nvim_get_current_tabpage", function()
      return 12
    end)

    local result = Octo.open_pr("/tmp/container", "9")

    assert.are.same({ opened = true, tab = 12, created = true }, result)
    assert.are.same({
      "tabnew",
      "edit octo://git.example.com/owner/repo/pull/9",
    }, cmd_calls)
  end)

  it("closes a created tab when edit fails", function()
    cmd_stub:revert()
    cmd_stub = stub(vim, "cmd", function(command)
      table.insert(cmd_calls, command)
      if command:match("^edit ") then
        error("edit failed")
      end
    end)

    local result = Octo.open_pr("/tmp/container", "9")

    assert.are.same({ opened = false, tab = nil, created = false }, result)
    assert.are.same({
      "tabnew",
      "edit octo://owner/repo/pull/9",
      "tabclose",
    }, cmd_calls)
  end)
end)
