return {
  {
    "nvim-mini/mini.splitjoin",
    event = "VeryLazy",
    opts = function()
      local msj = require("mini.splitjoin")
      local gen = msj.gen_hook

      -- ── Hook factories ──────────────────────────────────────────────
      local add_curly_square = gen.add_trailing_separator({ brackets = { "%b{}", "%b[]" } })
      local del_curly_square = gen.del_trailing_separator({ brackets = { "%b{}", "%b[]" } })
      local add_paren = gen.add_trailing_separator({ brackets = { "%b()" } })
      local del_paren = gen.del_trailing_separator({ brackets = { "%b()" } })

      -- ── Filetype policy sets ────────────────────────────────────────
      local disallow_all = {
        json = true,
        jsonc = true,
        json5 = true,
        toml = true,
        yaml = true,
        yml = true,
        ini = true,
        conf = true,
        env = true,
      }

      local paren_ok = {
        python = true,
        go = true,
        rust = true,
        typescript = true,
        typescriptreact = true,
        javascript = true,
        javascriptreact = true,
      }

      -- ── Wrappers to enforce policies ────────────────────────────────
      local function guarded_add_curly_square(positions, right_end)
        if disallow_all[vim.bo.filetype] then
          return positions
        end
        return add_curly_square(positions, right_end)
      end

      local function guarded_del_curly_square(positions, right_end)
        -- always allow deletions (safe)
        return del_curly_square(positions, right_end)
      end

      local function guarded_add_paren(positions, right_end)
        if paren_ok[vim.bo.filetype] then
          return add_paren(positions, right_end)
        end
        -- Lua tables `{}` still handled by curly hook; skip ()
        return positions
      end

      local function guarded_del_paren(positions, right_end)
        return del_paren(positions, right_end)
      end

      -- ── Return opts merged by Lazy.nvim ─────────────────────────────
      return {
        mappings = { toggle = "" }, -- disable plugin’s own gS
        split = {
          hooks_post = {
            guarded_add_curly_square,
            guarded_add_paren,
          },
        },
        join = {
          hooks_post = {
            guarded_del_curly_square,
            guarded_del_paren,
          },
        },
      }
    end,

    -- ── which-key style mappings ──────────────────────────────────────
    keys = {
      {
        "gS",
        function()
          require("mini.splitjoin").toggle()
        end,
        desc = "Split/Join (mini.splitjoin)",
      },
      -- {
      --   "<leader>cs",
      --   function()
      --     require("mini.splitjoin").split()
      --   end,
      --   desc = "Split arguments",
      -- },
      -- {
      --   "<leader>cj",
      --   function()
      --     require("mini.splitjoin").join()
      --   end,
      --   desc = "Join arguments",
      -- },
    },
  },
}

-- return {
--   {
--     "nvim-mini/mini.splitjoin",
--     version = "*", -- stable; use false for latest main
--     event = "VeryLazy",
--     keys = {
--       {
--         "gS",
--         function()
--           require("mini.splitjoin").toggle()
--         end,
--         desc = "Split/Join: Toggle",
--         mode = { "n", "x" },
--       },
--     },
--     opts = {
--       -- Disable internal default mappings so only our Which-Key ones are active
--       mappings = {
--         toggle = "",
--         split = "",
--         join = "",
--       },
--       -- Defaults shown here for reference; tweak only if you need to
--       -- detect = {
--       --   brackets = nil,         -- { '%b()', '%b[]', '%b{}' }
--       --   separator = ",",        -- argument separator
--       --   exclude_regions = nil,  -- { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
--       -- },
--     },
--     -- config = function(_, opts)
--     --   require("mini.splitjoin").setup(opts)
--     -- end,
--   },
-- }
