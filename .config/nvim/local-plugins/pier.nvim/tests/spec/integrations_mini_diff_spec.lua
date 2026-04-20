local assert = require("luassert")

describe("pier.integrations.mini_diff", function()
  local MiniDiff
  local buf
  local calls

  before_each(function()
    calls = {}
    buf = vim.api.nvim_create_buf(true, false)
    vim.b[buf].minidiff_summary = nil
    vim.g.minidiff_disable = false

    package.loaded["lazy"] = {
      load = function(opts)
        table.insert(calls, { "lazy.load", opts.plugins[1], opts.wait })
      end,
    }
    package.loaded["mini.diff"] = {
      enable = function(target)
        table.insert(calls, { "enable", target })
      end,
      disable = function(target)
        table.insert(calls, { "disable", target })
      end,
    }

    package.loaded["pier.integrations.mini_diff"] = nil
    MiniDiff = require("pier.integrations.mini_diff")
  end)

  after_each(function()
    if buf and vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
    package.loaded["lazy"] = nil
    package.loaded["mini.diff"] = nil
    package.loaded["pier.integrations.mini_diff"] = nil
    vim.g.minidiff_disable = nil
  end)

  it("captures buffer enablement and global disable state", function()
    vim.b[buf].minidiff_summary = { add = 1 }
    vim.g.minidiff_disable = true

    local snapshot = MiniDiff.capture({ review_buf = buf })

    assert.are.same({
      buf = buf,
      enabled = true,
      global_disable = true,
    }, snapshot)
  end)

  it("enables mini.diff for the active review buffer", function()
    MiniDiff.apply({ review_buf = buf }, nil)

    assert.are.same({
      { "lazy.load", "mini.diff", true },
      { "enable", buf },
    }, calls)
    assert.equals(false, vim.g.minidiff_disable)
  end)

  it("restores disabled state for both session and snapshot buffers", function()
    local old_buf = vim.api.nvim_create_buf(true, false)
    local snapshot = {
      buf = old_buf,
      enabled = false,
      global_disable = true,
    }

    MiniDiff.restore({ review_buf = buf }, snapshot)

    assert.are.same({
      { "lazy.load", "mini.diff", true },
      { "disable", buf },
      { "disable", old_buf },
    }, calls)
    assert.equals(true, vim.g.minidiff_disable)

    vim.api.nvim_buf_delete(old_buf, { force = true })
  end)
end)
