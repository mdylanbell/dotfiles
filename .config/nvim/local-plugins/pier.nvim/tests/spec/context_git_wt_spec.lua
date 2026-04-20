local assert = require("luassert")

describe("pier.context.git_wt", function()
  local Context
  local scratch

  local function mkdirp(path)
    assert(vim.fn.mkdir(path, "p") == 1 or vim.fn.isdirectory(path) == 1)
  end

  before_each(function()
    package.loaded["pier.context.git_wt"] = nil
    package.loaded["pier.git"] = nil
    Context = require("pier.context.git_wt")

    scratch = vim.fs.normalize(vim.fn.tempname())
    mkdirp(scratch .. "/wt/pr-20-feature-b")
    mkdirp(scratch .. "/wt/pr-3-feature-a")
    mkdirp(scratch .. "/wt/not-a-pr")
  end)

  after_each(function()
    if scratch then
      vim.fn.delete(scratch, "rf")
    end
  end)

  it("detects PR worktree paths and extracts the PR number", function()
    local path = scratch .. "/wt/pr-42-some-branch"

    assert.is_true(Context.is_pr_worktree(path))
    assert.equals("42", Context.pr_number_from_path(path))
    assert.is_false(Context.is_pr_worktree(scratch .. "/wt/topic-42"))
    assert.is_nil(Context.pr_number_from_path(scratch .. "/wt/topic-42"))
  end)

  it("lists and sorts PR worktree entries by PR number", function()
    local entries = Context.pr_worktree_entries(scratch)

    assert.are.same({
      {
        path = scratch .. "/wt/pr-3-feature-a",
        label = "pr-3-feature-a",
        pr = "3",
      },
      {
        path = scratch .. "/wt/pr-20-feature-b",
        label = "pr-20-feature-b",
        pr = "20",
      },
    }, entries)
  end)
end)
