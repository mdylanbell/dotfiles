return {
  "folke/snacks.nvim",
  optional = true,

  opts = function(_, opts)
    opts = opts or {}
    local function with_review_pr_key(keys)
      local ret = vim.deepcopy(keys or {})
      for _, item in ipairs(ret) do
        if item.key == "R" then
          return ret
        end
      end

      local ok, review = pcall(require, "config.review")
      if ok and review.container_root() then
        table.insert(ret, {
          icon = "󰈈 ",
          key = "R",
          desc = "Review PR",
          action = function()
            vim.cmd("ReviewPR")
          end,
        })
      end

      return ret
    end

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

        return with_review_pr_key(keys)
      end
    end

    return opts
  end,
}
