return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  optional = true,
  version = false,
  -- fix color mismatch on pill rendering with catppuccin
  config = function(_, opts)
    require("avante").setup(opts)

    local function set_header_highlights()
      local ok, palettes = pcall(require, "catppuccin.palettes")
      if not ok then
        return
      end

      local colors = palettes.get_palette(vim.g.colors_name == "catppuccin-latte" and "latte" or "mocha")

      vim.api.nvim_set_hl(0, "AvanteTitle", { fg = colors.base, bg = colors.lavender })
      vim.api.nvim_set_hl(0, "AvanteReversedTitle", { fg = colors.lavender, bg = colors.base })
      vim.api.nvim_set_hl(0, "AvanteSubtitle", { fg = colors.base, bg = colors.peach })
      vim.api.nvim_set_hl(0, "AvanteReversedSubtitle", { fg = colors.peach, bg = colors.base })
      vim.api.nvim_set_hl(0, "AvanteThirdTitle", { fg = colors.base, bg = colors.blue })
      vim.api.nvim_set_hl(0, "AvanteReversedThirdTitle", { fg = colors.blue, bg = colors.base })
    end

    set_header_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("avante-header-highlights", { clear = true }),
      callback = set_header_highlights,
    })
  end,
  -- Actual config with providers and secrets helper
  opts = function()
    local secrets = require("config.secrets")

    return {
      provider = "copilot",
      providers = {
        copilot = {
          model = "gpt-5-mini",
        },
        openai = {
          model = "gpt-5.4-mini",
          api_key_name = secrets.op_read("openai"),
        },
      },
    }
  end,
}
