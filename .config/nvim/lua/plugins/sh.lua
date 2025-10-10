return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    -- shfmt supports POSIX sh and bash (not zsh), so wire it to these FTs:
    opts.formatters_by_ft.sh = { "shfmt" }
    opts.formatters_by_ft.bash = { "shfmt" }

    opts.formatters = opts.formatters or {}
    -- Add your desired args
    opts.formatters.shfmt = {
      -- use prepend_args so we keep any sane defaults Conform sets
      prepend_args = { "-i", "2", "-ci", "-bn" },
    }
  end,
}
