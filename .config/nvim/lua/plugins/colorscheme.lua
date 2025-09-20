return {
  -- disable LazyVim's default colorscheme (tokyonight)
  { "folke/tokyonight.nvim", enabled = false },

  -- add NeoSolarized
  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = false, -- load at startup
    priority = 1000, -- load before other start plugins
    config = function()
      require("NeoSolarized").setup({
        style = "dark", -- "dark" | "light"
        transparent = false, -- true for transparent background
      })
      vim.cmd.colorscheme("NeoSolarized")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "NeoSolarized",
    },
  },
  -- Statusline: let lualine auto-derive its palette from the active theme
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "auto"
    end,
  },

  -- Nice float/border defaults so popups (notify/noice, LSP, pickers) blend in
  -- Works whether you use fzf-lua or enable Telescope as an extra later.
  {
    "rcarriga/nvim-notify",
    optional = true,
    opts = {},
  },
  {
    "folke/noice.nvim",
    optional = true,
    opts = {},
  },
  {
    -- apply/repair float highlights whenever the colorscheme changes
    -- (covers LSP hovers, diagnostics, notify/noice popups, pickers, etc.)
    "nvim-lua/plenary.nvim",
    lazy = false,
    config = function()
      local aug = vim.api.nvim_create_augroup("neo_solarized_ui_links", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = aug,
        callback = function()
          -- keep float backgrounds and borders consistent with the theme
          vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
          vim.api.nvim_set_hl(0, "FloatBorder", { link = "WinSeparator" })
          vim.api.nvim_set_hl(0, "FloatTitle", { link = "Title" })
        end,
      })
    end,
  },

  -- Indent guides (ibl): give gentle, theme-aware links
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    optional = true,
    opts = {
      -- keep defaults; rely on theme links below for colors
    },
    config = function(_, opts)
      require("ibl").setup(opts)
      local aug = vim.api.nvim_create_augroup("neo_solarized_ibl_links", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = aug,
        callback = function()
          -- Link indent guides to subtle theme groups so they always match
          vim.api.nvim_set_hl(0, "IblIndent", { link = "NonText" })
          vim.api.nvim_set_hl(0, "IblWhitespace", { link = "NonText" })
          vim.api.nvim_set_hl(0, "IblScope", { link = "Comment" })
        end,
      })
    end,
  },
  -- Make picker selections clearly visible across Snacks / Telescope / fzf-lua
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
    config = function()
      local aug = vim.api.nvim_create_augroup("neo_solarized_picker_hls", { clear = true })
      local function set_picker_hls()
        -- Snacks (LazyVim’s default picker)
        local snacks_links = {
          SnacksPicker = "NormalFloat",
          SnacksPickerBorder = "FloatBorder",
          SnacksPickerTitle = "FloatTitle",
          SnacksPickerPrompt = "Pmenu",
          SnacksPickerPromptTitle = "FloatTitle",
          SnacksPickerList = "NormalFloat",
          SnacksPickerListCursorLine = "CursorLine", -- <— selected row
          SnacksPickerMatch = "Search",
          SnacksPickerPreview = "NormalFloat",
          SnacksPickerPreviewBorder = "FloatBorder",
          SnacksPickerPreviewTitle = "FloatTitle",
          SnacksPickerPreviewCursorLine = "CursorLine",
        }
        for group, link in pairs(snacks_links) do
          vim.api.nvim_set_hl(0, group, { link = link, default = false })
        end

        -- Telescope (if you enable the extra)
        local telescope_links = {
          TelescopeSelection = "Visual", -- <— selected row
          TelescopeSelectionCaret = "IncSearch",
          TelescopePromptNormal = "NormalFloat",
          TelescopeResultsNormal = "NormalFloat",
          TelescopePreviewNormal = "NormalFloat",
          TelescopePromptBorder = "FloatBorder",
          TelescopeResultsBorder = "FloatBorder",
          TelescopePreviewBorder = "FloatBorder",
          TelescopePromptTitle = "FloatTitle",
          TelescopeResultsTitle = "FloatTitle",
          TelescopePreviewTitle = "FloatTitle",
        }
        for group, link in pairs(telescope_links) do
          vim.api.nvim_set_hl(0, group, { link = link, default = false })
        end

        -- fzf-lua (if you enable the extra)
        local fzf_links = {
          FzfLuaNormal = "NormalFloat",
          FzfLuaBorder = "FloatBorder",
          FzfLuaTitle = "FloatTitle",
          FzfLuaCursorLine = "CursorLine", -- <— selected row
          FzfLuaPreviewNormal = "NormalFloat",
          FzfLuaPreviewBorder = "FloatBorder",
          FzfLuaPreviewTitle = "FloatTitle",
          FzfLuaPreviewCursorLine = "CursorLine",
        }
        for group, link in pairs(fzf_links) do
          vim.api.nvim_set_hl(0, group, { link = link, default = false })
        end

        -- Generic float tweaks (keeps popups consistent)
        vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
        vim.api.nvim_set_hl(0, "FloatBorder", { link = "WinSeparator" })
        vim.api.nvim_set_hl(0, "FloatTitle", { link = "Title" })
      end

      vim.api.nvim_create_autocmd("ColorScheme", { group = aug, callback = set_picker_hls })
      set_picker_hls() -- run once on startup
    end,
  },
}
