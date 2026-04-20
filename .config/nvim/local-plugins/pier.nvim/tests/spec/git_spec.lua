local assert = require("luassert")

describe("pier.git", function()
  local Git
  local scratch
  local other

  local function mkdirp(path)
    assert(vim.fn.mkdir(path, "p") == 1 or vim.fn.isdirectory(path) == 1)
  end

  before_each(function()
    package.loaded["pier.git"] = nil
    Git = require("pier.git")

    scratch = vim.fs.normalize(vim.fn.tempname())
    other = vim.fs.normalize(vim.fn.tempname())
    mkdirp(scratch .. "/main")
    mkdirp(scratch .. "/wt/pr-12-feature")
    mkdirp(scratch .. "/wt/pr-2-fix")
    mkdirp(other .. "/elsewhere")
  end)

  after_each(function()
    if scratch then
      vim.fn.delete(scratch, "rf")
    end
    if other then
      vim.fn.delete(other, "rf")
    end
  end)

  it("finds the enclosing git-wt container root", function()
    local nested = scratch .. "/wt/pr-12-feature/lua/pier"
    mkdirp(nested)

    assert.equals(scratch, Git.container_root(nested))
    assert.is_nil(Git.container_root(other .. "/elsewhere"))
  end)

  it("extracts PR numbers from both named and bare PR worktree paths", function()
    assert.equals("12", Git.pr_number_from_path(scratch .. "/wt/pr-12-feature"))
    assert.equals("2", Git.pr_number_from_path(scratch .. "/wt/pr-2"))
    assert.is_nil(Git.pr_number_from_path(scratch .. "/wt/topic-2"))
  end)
end)
