return {
  { "nvim-neotest/neotest-jest" },
  {
    "nvim-neotest/neotest",
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      -- Keep existing adapters (e.g., neotest-go) and append Jest
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          -- Use your working npm script and the project root
          jestCommand = "npm test --",
          -- cwd = function()
          --   return vim.fn.getcwd()
          -- end,
          -- Optional: if you later want separate e2e config, uncomment:
          -- jestConfigFile = function(file)
          --   return file:find("/test/") and "test/jest-e2e.json" or nil
          -- end,
        })
      )
    end,
  },
}
