return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-plenary",
  },
  opts = {
    adapters = {
      ["neotest-python"] = {
        -- Add --no-cov to pytest arguments
        args = { "--no-cov" },
      },
      -- Runs plenary.nvim busted-style `*_spec.lua` tests (e.g. taskfile.nvim).
      ["neotest-plenary"] = {},
    },
    discovery = {
      -- Don't descend into vendored dependency / build output dirs. Otherwise
      -- neotest discovers the `*_spec.lua` files shipped inside cloned deps
      -- (e.g. `build/ext/plenary.nvim`) and tries to run them.
      filter_dir = function(name)
        local ignored = {
          build = true,
          [".git"] = true,
          node_modules = true,
          [".venv"] = true,
          venv = true,
          target = true,
        }
        return not ignored[name]
      end,
    },
  },
}
