local assert = require("luassert")
local stub = require("luassert.stub")

describe("pier.core.diffview", function()
  local Diffview
  local notifications
  local commands
  local git_stub
  local notify_stub
  local cmd_stub
  local exists_stub

  before_each(function()
    notifications = {}
    commands = {}

    notify_stub = stub(vim, "notify", function(message, level)
      table.insert(notifications, { message = message, level = level })
    end)

    cmd_stub = stub(vim, "cmd", function(command)
      table.insert(commands, command)
    end)

    git_stub = {
      rev_parse = function(_, ref)
        return ref == "main" or ref == "origin/main" or ref == "HEAD"
      end,
      default_branch = function()
        return "main"
      end,
    }

    package.loaded["pier.git"] = git_stub
    package.loaded["pier.core.diffview"] = nil
    Diffview = require("pier.core.diffview")
  end)

  after_each(function()
    if exists_stub then
      exists_stub:revert()
      exists_stub = nil
    end
    notify_stub:revert()
    cmd_stub:revert()
    package.loaded["pier.git"] = nil
    package.loaded["pier.core.diffview"] = nil
    package.loaded["lazy"] = nil
  end)

  it("prefers a direct base...HEAD range when both refs resolve", function()
    assert.equals("main...HEAD", Diffview.resolve_range("/repo", "main"))
  end)

  it("falls back to origin/base...HEAD when the local base ref is missing", function()
    git_stub.rev_parse = function(_, ref)
      return ref == "origin/main" or ref == "HEAD"
    end

    assert.equals("origin/main...HEAD", Diffview.resolve_range("/repo", "main"))
  end)

  it("opens Diffview with the resolved range", function()
    exists_stub = stub(vim.fn, "exists", function(command)
      return command == ":DiffviewOpen" and 2 or 0
    end)

    assert.is_true(Diffview.open("/repo", "main"))
    assert.are.same({ "DiffviewOpen main...HEAD" }, commands)
    assert.are.same({}, notifications)
  end)

  it("notifies and returns false when no diff range can be resolved", function()
    exists_stub = stub(vim.fn, "exists", function(command)
      return command == ":DiffviewOpen" and 2 or 0
    end)
    git_stub.rev_parse = function()
      return nil
    end

    assert.is_false(Diffview.open("/repo", "main"))
    assert.equals("Pier: could not resolve diff base for main", notifications[1].message)
    assert.equals(vim.log.levels.WARN, notifications[1].level)
  end)
end)
