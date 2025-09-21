return {
  {
    "nvim-mini/mini.splitjoin",
    version = "*", -- stable; use false for latest main
    event = "VeryLazy", -- or remove if you want it always loaded
    -- Keymaps with Which-Key descriptions
    keys = {
      {
        "gS",
        function()
          require("mini.splitjoin").toggle()
        end,
        desc = "Split/Join: Toggle",
        mode = { "n", "x" },
      },
      -- (Optional) separate actions if you like:
      -- { "gs", function() require("mini.splitjoin").split()  end, desc = "Split args to lines", mode = { "n", "x" } },
      -- { "gJ", function() require("mini.splitjoin").join()   end, desc = "Join args to one line", mode = { "n", "x" } },
    },
    opts = {
      -- Disable internal default mappings so only our Which-Key ones are active
      mappings = {
        toggle = "", -- default is 'gS'; '' disables it
        split = "",
        join = "",
      },
      -- Defaults shown here for reference; tweak only if you need to
      -- detect = {
      --   brackets = nil,         -- { '%b()', '%b[]', '%b{}' }
      --   separator = ",",        -- argument separator
      --   exclude_regions = nil,  -- { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
      -- },
    },
    config = function(_, opts)
      require("mini.splitjoin").setup(opts)
    end,
  },
}
