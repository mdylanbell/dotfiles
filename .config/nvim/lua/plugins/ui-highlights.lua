return {
  -- If you use neotest, give its floats a nicer border
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      opts = opts or {}
      opts.floating = vim.tbl_deep_extend("force", opts.floating or {}, { border = "rounded" })
      return opts
    end,
  },

  -- All UI highlight/link tweaks live here: floats, pickers, neotest panes
  {
    "LazyVim/LazyVim",
    init = function()
      -----------------------------------------------------------------------
      -- Float/border defaults (play nice with NeoSolarized)
      -----------------------------------------------------------------------
      local aug = vim.api.nvim_create_augroup("neo_ui_highlights", { clear = true })
      local function set_global_float_links()
        -- consistent float look everywhere
        vim.api.nvim_set_hl(0, "NormalFloat", { link = "Pmenu" })
        vim.api.nvim_set_hl(0, "FloatBorder", { link = "WinSeparator" })
        vim.api.nvim_set_hl(0, "FloatTitle", { link = "Title" })
      end

      -----------------------------------------------------------------------
      -- Picker highlights (Snacks default; Telescope/fzf-lua if enabled)
      -----------------------------------------------------------------------
      local function set_picker_hls()
        -- Snacks (LazyVim’s default picker)
        local snacks_links = {
          SnacksPicker = "NormalFloat",
          SnacksPickerBorder = "FloatBorder",
          SnacksPickerTitle = "FloatTitle",
          SnacksPickerPrompt = "Pmenu",
          SnacksPickerPromptTitle = "FloatTitle",
          SnacksPickerList = "NormalFloat",
          SnacksPickerListCursorLine = "CursorLine", -- selected row
          SnacksPickerMatch = "Search",
          SnacksPickerPreview = "NormalFloat",
          SnacksPickerPreviewBorder = "FloatBorder",
          SnacksPickerPreviewTitle = "FloatTitle",
          SnacksPickerPreviewCursorLine = "CursorLine",
        }
        for g, link in pairs(snacks_links) do
          vim.api.nvim_set_hl(0, g, { link = link, default = false })
        end

        -- Telescope (if you enable the extra)
        -- local telescope_links = {
        --   TelescopeSelection = "Visual", -- selected row
        --   TelescopeSelectionCaret = "IncSearch",
        --   TelescopePromptNormal = "NormalFloat",
        --   TelescopeResultsNormal = "NormalFloat",
        --   TelescopePreviewNormal = "NormalFloat",
        --   TelescopePromptBorder = "FloatBorder",
        --   TelescopeResultsBorder = "FloatBorder",
        --   TelescopePreviewBorder = "FloatBorder",
        --   TelescopePromptTitle = "FloatTitle",
        --   TelescopeResultsTitle = "FloatTitle",
        --   TelescopePreviewTitle = "FloatTitle",
        -- }
        -- for g, link in pairs(telescope_links) do
        --   vim.api.nvim_set_hl(0, g, { link = link, default = false })
        -- end

        -- fzf-lua (if you enable it)
        local fzf_links = {
          FzfLuaNormal = "NormalFloat",
          FzfLuaBorder = "FloatBorder",
          FzfLuaTitle = "FloatTitle",
          FzfLuaCursorLine = "CursorLine", -- selected row
          FzfLuaPreviewNormal = "NormalFloat",
          FzfLuaPreviewBorder = "FloatBorder",
          FzfLuaPreviewTitle = "FloatTitle",
          FzfLuaPreviewCursorLine = "CursorLine",
        }
        for g, link in pairs(fzf_links) do
          vim.api.nvim_set_hl(0, g, { link = link, default = false })
        end
      end

      -- Apply on theme load + once at startup
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = aug,
        callback = function()
          set_global_float_links()
          set_picker_hls()
        end,
      })
      set_global_float_links()
      set_picker_hls()

      -----------------------------------------------------------------------
      -- Neotest windows: distinct bg + clearer border, window-local only
      -----------------------------------------------------------------------
      local grp = vim.api.nvim_create_augroup("neotest_contrast_bg", { clear = true })

      local function set_winhl_for_neotest(win)
        -- use themed groups (no hex): Pmenu bg, PmenuSel cursorline, Title border
        local map = {
          "Normal:Pmenu",
          "NormalNC:Pmenu",
          "NormalFloat:Pmenu",
          "CursorLine:PmenuSel",
          "FloatTitle:Title",
          "FloatBorder:Title",
        }
        local joined = table.concat(map, ",")
        local cur = vim.wo[win].winhl
        vim.wo[win].winhl = (cur ~= "" and (cur .. ",") or "") .. joined
      end

      local neotest_fts = {
        "neotest-summary",
        "neotest-output",
        "neotest-output-panel",
        "neotest-attach",
      }

      vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
        group = grp,
        callback = function(ev)
          local ft = vim.bo[ev.buf].filetype
          for _, want in ipairs(neotest_fts) do
            if ft == want then
              set_winhl_for_neotest(0)
              -- tidy UI defaults in these panels
              vim.opt_local.number = false
              vim.opt_local.relativenumber = false
              vim.opt_local.signcolumn = "no"
              vim.opt_local.cursorline = true
              break
            end
          end
        end,
      })
    end,
  },
}
