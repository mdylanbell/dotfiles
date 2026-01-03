return {
  "folke/snacks.nvim",
  optional = true,
  -- keep LazyVim's merged opts; we just run setup, then patch the factory
  config = function(_, opts)
    local Snacks = require("snacks")
    opts = opts or {}

    opts.dashboard = opts.dashboard or {}
    opts.dashboard.preset = opts.dashboard.preset or {}
    do
      local user_keys = opts.dashboard.preset.keys
      opts.dashboard.preset.keys = function(items)
        local keys = {}
        if type(user_keys) == "function" then
          keys = user_keys(items) or {}
        elseif type(user_keys) == "table" then
          keys = user_keys
        elseif type(items) == "table" then
          keys = items
        end

        local ok, review = pcall(require, "config.review")
        if ok and review.container_root() then
          table.insert(keys, {
            icon = "󰈈 ",
            key = "R",
            desc = "Review PR",
            action = function()
              vim.cmd("ReviewPR")
            end,
          })
        end

        return keys
      end
    end

    Snacks.setup(opts)

    -- Edit your root markers here
    local markers = { ".git", "pyproject.toml" }

    -- Neovim 0.10+: prefer vim.fs.root; fall back to find+dirname if needed
    local function find_root(dir)
      if vim.fs.root then
        return vim.fs.root(dir, markers)
      else
        local found = vim.fs.find(markers, { path = dir, upward = true })[1]
        return found and vim.fs.dirname(found) or nil
      end
    end

    local function dirs_fn()
      local seen, out = {}, {}
      local function add(p)
        if p and not seen[p] then
          seen[p] = true
          table.insert(out, p)
        end
      end

      -- put current working tree first if it matches
      local cwd = vim.loop.cwd()
      if cwd then
        add(find_root(cwd) or cwd)
      end

      -- harvest recent files for more roots
      for _, f in ipairs(vim.v.oldfiles or {}) do
        if #out >= 200 then
          break
        end
        local dir = vim.fs.dirname(f)
        if dir then
          add(find_root(dir))
        end
      end
      return out
    end

    -- Minimal, safe patch: only supply dirs() if caller didn't set one.
    local orig_projects = Snacks.dashboard.sections.projects
    Snacks.dashboard.sections.projects = function(user_opts)
      user_opts = user_opts or {}
      local user_dirs = user_opts.dirs

      -- Prefer our root finder, but keep user dirs after (no duplicates)
      -- prefer repo-aware roots first, then user dirs (deduped)
      user_opts.dirs = function()
        local seen, out = {}, {}
        local function add(list)
          if type(list) == "function" then
            list = list()
          end
          if type(list) ~= "table" then
            return
          end
          for _, dir in ipairs(list) do
            if dir and not seen[dir] then
              seen[dir] = true
              table.insert(out, dir)
            end
          end
        end

        add(dirs_fn)   -- our mono‑repo aware roots first
        add(user_dirs) -- user-provided roots after
        return out
      end

      -- keep other options (limit/pick/session/action) untouched if provided
      user_opts.limit = user_opts.limit or 10
      return orig_projects(user_opts)
    end
  end,
}
