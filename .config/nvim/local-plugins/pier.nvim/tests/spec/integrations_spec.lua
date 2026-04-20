local assert = require("luassert")

describe("pier integrations", function()
  after_each(function()
    package.loaded["gitsigns"] = nil
    package.loaded["gitsigns.config"] = nil
    package.loaded["pier.integrations.gitsigns"] = nil
    package.loaded["pier.integrations.ui"] = nil
  end)

  it("captures and restores showtabline in the ui integration", function()
    local ui = require("pier.integrations.ui")
    local original = vim.o.showtabline

    vim.o.showtabline = 1
    local snapshot = ui.capture()
    ui.apply()
    assert.equals(2, vim.o.showtabline)

    ui.restore(nil, snapshot)
    assert.equals(1, vim.o.showtabline)
    vim.o.showtabline = original
  end)

  it("toggles gitsigns off and back on using the captured signcolumn state", function()
    local calls = {}

    package.loaded["gitsigns.config"] = {
      config = {
        signcolumn = true,
      },
    }
    package.loaded["gitsigns"] = {
      toggle_signs = function(value)
        table.insert(calls, { "toggle_signs", value })
      end,
      refresh = function()
        table.insert(calls, { "refresh" })
      end,
    }

    local gitsigns = require("pier.integrations.gitsigns")

    local snapshot = gitsigns.capture()
    assert.are.same({ signcolumn = true }, snapshot)

    gitsigns.apply()
    gitsigns.restore(nil, snapshot)

    assert.are.same({
      { "toggle_signs", false },
      { "refresh" },
      { "toggle_signs", true },
      { "refresh" },
    }, calls)
  end)
end)
