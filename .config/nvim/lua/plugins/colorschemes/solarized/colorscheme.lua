return {
  "maxmx03/solarized.nvim",
  priority = 900,
  opts = {},
  config = function(_, opts)
    vim.o.termguicolors = true
    require("solarized").setup(opts)

    local group = vim.api.nvim_create_augroup("solarized_term_palette", { clear = true })

    local function hex(c)
      if type(c) == "number" then
        return string.format("#%06x", c)
      end
      if type(c) == "string" then
        if c:sub(1, 1) ~= "#" then
          c = "#" .. c:gsub("^0x", "")
        end
        return c:lower()
      end
    end

    local function get_solarized_dark_ansi()
      local ok, utils = pcall(require, "solarized.utils")
      if not (ok and utils.get_colors) then
        return nil
      end
      local c = utils.get_colors()
      return {
        [0] = hex(c.base02),
        [1] = hex(c.red),
        [2] = hex(c.green),
        [3] = hex(c.yellow),
        [4] = hex(c.blue),
        [5] = hex(c.magenta),
        [6] = hex(c.cyan),
        [7] = hex(c.base2),
        [8] = hex(c.base03),
        [9] = hex(c.orange),
        [10] = hex(c.base01),
        [11] = hex(c.base00),
        [12] = hex(c.base0),
        [13] = hex(c.violet),
        [14] = hex(c.base1),
        [15] = hex(c.base3),
      }
    end

    local function is_solarized_dark()
      return (vim.g.colors_name == "solarized") and (vim.o.background == "dark")
    end

    local function clear_terminal_palette()
      for i = 0, 15 do
        vim.g["terminal_color_" .. i] = nil
      end
    end

    local function apply_palette()
      if is_solarized_dark() then
        vim.o.background = "dark"
        local s = get_solarized_dark_ansi()
        if s then
          for i = 0, 15 do
            vim.g["terminal_color_" .. i] = s[i]
          end
        end
      else
        clear_terminal_palette()
      end
    end

    vim.api.nvim_create_autocmd("UIEnter", { group = group, once = true, callback = apply_palette })
    vim.api.nvim_create_autocmd("ColorScheme", { group = group, callback = apply_palette })

    vim.api.nvim_create_autocmd("TermOpen", {
      group = group,
      callback = function(ev)
        if not is_solarized_dark() then
          return
        end
        vim.schedule(function()
          local win = vim.fn.bufwinid(ev.buf)
          if win ~= -1 then
            vim.api.nvim_set_option_value(
              "winhighlight",
              "Normal:Normal,NormalNC:Normal,SignColumn:SignColumn,FloatBorder:FloatBorder",
              { scope = "local", win = win }
            )
          end
        end)
      end,
    })
  end,
}
