return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      sh = { "shfmt" },
      bash = { "shfmt" },
    },
    formatters = {
      shfmt = {
        prepend_args = { "-i", "2", "-ci", "-bn" },
      },
    },
  },
}
