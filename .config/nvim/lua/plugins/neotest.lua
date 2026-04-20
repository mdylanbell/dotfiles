return {
  "nvim-neotest/neotest",
  opts = {
    adapters = {
      ["neotest-python"] = {
        -- Add --no-cov to pytest arguments
        args = { "--no-cov" },
      },
    },
  },
}
