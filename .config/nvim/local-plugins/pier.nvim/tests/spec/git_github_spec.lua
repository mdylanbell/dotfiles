local assert = require("luassert")
local stub = require("luassert.stub")

describe("pier.git shell helpers", function()
  local Git
  local system_stub
  local executable_stub
  local container

  before_each(function()
    container = vim.fs.normalize(vim.fn.tempname())
    assert(vim.fn.mkdir(container .. "/main", "p") == 1 or vim.fn.isdirectory(container .. "/main") == 1)

    executable_stub = stub(vim.fn, "executable", function(binary)
      return (binary == "gh" or binary == "curl") and 1 or 0
    end)
    system_stub = stub(vim, "system", function(cmd)
      return {
        wait = function()
          if cmd[1] == "git" and cmd[4] == "rev-parse" and cmd[5] == "--show-toplevel" then
            if cmd[3] == container .. "/main" then
              return { code = 0, stdout = container .. "/main\n", stderr = "" }
            end
            return { code = 1, stdout = "", stderr = "" }
          end

          if cmd[1] == "git" and cmd[4] == "remote" and cmd[5] == "get-url" then
            return {
              code = 0,
              stdout = "https://git.example.com/owner/repo.git\n",
              stderr = "",
            }
          end

          if cmd[1] == "gh" then
            assert.are.same({
              "gh",
              "pr",
              "view",
              "9",
              "--repo",
              "git.example.com/owner/repo",
              "--json",
              "baseRefName",
              "--jq",
              ".baseRefName",
            }, cmd)
            return { code = 0, stdout = "develop\n", stderr = "" }
          end

          if cmd[1] == "curl" then
            return { code = 7, stdout = "", stderr = "failed" }
          end

          return { code = 1, stdout = "", stderr = "" }
        end,
      }
    end)

    package.loaded["pier.git"] = nil
    Git = require("pier.git")
  end)

  after_each(function()
    system_stub:revert()
    executable_stub:revert()
    vim.fn.delete(container, "rf")
    package.loaded["pier.git"] = nil
  end)

  it("resolves the PR base branch with a host-qualified gh repo", function()
    assert.equals("develop", Git.pr_base_branch(container, "9"))
  end)

  it("reports an unreachable review host when curl probing fails", function()
    assert.are.same({
      ok = false,
      host = "git.example.com",
      reason = "host_unreachable",
      message = "Pier: cannot reach git.example.com; VPN or network may be down",
    }, Git.host_reachability_status("git.example.com"))
  end)

  it("reports gh auth failures for configured hosts", function()
    system_stub:revert()
    system_stub = stub(vim, "system", function(cmd)
      return {
        wait = function()
          if cmd[1] == "gh" and cmd[2] == "auth" then
            return { code = 1, stdout = "", stderr = "auth failed" }
          end
          return { code = 0, stdout = "", stderr = "" }
        end,
      }
    end)

    assert.are.same({
      ok = false,
      host = "git.example.com",
      reason = "gh_unavailable",
      message = "Pier: gh is not ready for git.example.com; check authentication for that host",
    }, Git.gh_auth_status("git.example.com"))
  end)
end)

describe("pier.github", function()
  local GitStub
  local GitHub
  local gh_dir
  local original_path

  local function write_gh_script(lines)
    vim.fn.writefile(lines, gh_dir .. "/gh")
    vim.fn.setfperm(gh_dir .. "/gh", "rwxr-xr-x")
  end

  before_each(function()
    GitStub = {
      origin_host_status = function()
        return { ok = true, host = "git.example.com" }
      end,
      host_reachability_status = function(host)
        return { ok = true, host = host }
      end,
      gh_auth_status = function(host)
        return { ok = true, host = host }
      end,
      pr_base_branch = function(_, pr_num)
        return pr_num == "12" and "main" or nil
      end,
      origin_slug = function()
        return "owner/repo"
      end,
      origin_host = function()
        return "git.example.com"
      end,
    }
    package.loaded["pier.git"] = GitStub
    gh_dir = vim.fs.normalize(vim.fn.tempname())
    assert(vim.fn.mkdir(gh_dir, "p") == 1 or vim.fn.isdirectory(gh_dir) == 1)
    original_path = vim.env.PATH
    vim.env.PATH = gh_dir .. ":" .. original_path
    write_gh_script({
      "#!/usr/bin/env bash",
      'if [[ "$*" == *"repos/owner/repo/pulls/12"* ]]; then',
      '  printf \'%s\\n\' \'{"title":"Test PR","body":"line 1\\r\\nline 2"}\'',
      "  exit 0",
      "fi",
      "exit 1",
    })

    package.loaded["pier.github"] = nil
    GitHub = require("pier.github")
  end)

  after_each(function()
    vim.env.PATH = original_path
    vim.fn.delete(gh_dir, "rf")
    package.loaded["pier.git"] = nil
    package.loaded["pier.github"] = nil
  end)

  it("returns the first failed host check", function()
    GitStub.host_reachability_status = function(host)
      return {
        ok = false,
        host = host,
        reason = "host_unreachable",
        message = "Pier: cannot reach git.example.com; VPN or network may be down",
      }
    end

    assert.are.same({
      ok = false,
      host = "git.example.com",
      reason = "host_unreachable",
      message = "Pier: cannot reach git.example.com; VPN or network may be down",
    }, GitHub.first_failed_host_check("/tmp/container"))
  end)

  it("normalizes fetched PR summaries from gh api output", function()
    assert.are.same({
      title = "Test PR",
      body = "line 1\nline 2",
    }, GitHub.fetch_pr_summary("/tmp/container", "12"))
  end)

  it("falls back cleanly when gh api output is unavailable", function()
    write_gh_script({
      "#!/usr/bin/env bash",
      "exit 1",
    })

    assert.are.same({
      title = "PR info unavailable",
      body = "",
    }, GitHub.fetch_pr_summary("/tmp/container", "13"))
  end)
end)
