local function is_solarized_dark()
  return (vim.g.colors_name == "solarized") and (vim.o.background == "dark")
end

return {
  {
    "LazyVim/LazyVim",
    init = function()
      local aug = vim.api.nvim_create_augroup("solarized_role_overrides", { clear = true })

      local function get_colors()
        local ok, utils = pcall(require, "solarized.utils")
        if ok and utils.get_colors then
          return utils.get_colors()
        end
        local function fg(name)
          local ok2, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
          return (ok2 and hl and hl.fg) or nil
        end
        return {
          base0 = fg("Normal"),
          base1 = fg("NonText") or fg("LineNr"),
          blue = fg("Function") or fg("Identifier"),
          green = fg("Type") or fg("Identifier"),
          cyan = fg("String") or fg("Special"),
          orange = fg("Constant") or fg("DiagnosticWarn"),
          yellow = fg("Identifier") or fg("MoreMsg"),
          violet = fg("PreProc") or fg("Keyword"),
          magenta = fg("Keyword") or fg("Statement"),
        }
      end

      local function set(name, spec)
        if not spec then
          return
        end
        if spec.fg or spec.bg or spec.bold or spec.italic or spec.underline or spec.undercurl or spec.link then
          vim.api.nvim_set_hl(0, name, spec)
        end
      end

      local function apply()
        if not is_solarized_dark() then
          return {}
        end

        local c = get_colors()

        local VAR = c.base0
        local PARAM = c.base0
        local FIELD = c.base1
        local FUNC = c.blue
        local TYPE = c.green
        local STR = c.cyan
        local CONST = c.orange
        local MOD = c.yellow
        local DECOR = c.violet
        local EXC = c.magenta
        local OP_PUNC = c.base1
        local KW = c.base3
        local KWFUNC = KW
        local KWTYPE = KW

        set("@variable", { fg = VAR })
        set("@variable.parameter", { fg = PARAM, italic = true })
        set("@variable.member", { fg = FIELD, italic = true })

        set("@property", { fg = FIELD, italic = true })
        set("@field", { fg = FIELD, italic = true })

        set("@function", { fg = FUNC, italic = true })
        set("@function.call", { fg = FUNC, italic = true })
        set("@function.method", { fg = FUNC, italic = true })
        set("@function.method.call", { fg = FUNC, italic = true })
        set("@constructor", { fg = FUNC })

        set("@type", { fg = TYPE })
        set("@type.builtin", { fg = TYPE, italic = true })

        set("@module", { fg = MOD })
        set("@namespace", { fg = MOD })

        set("@constant", { fg = CONST })
        set("@constant.builtin", { fg = CONST })
        set("@number", { fg = CONST })
        set("@boolean", { fg = CONST })

        set("@string", { fg = STR })
        set("@string.special", { fg = STR })
        set("@character", { fg = STR })

        set("@attribute", { fg = DECOR, italic = true })

        set("@exception", { fg = EXC })
        set("@keyword.exception", { fg = EXC })

        set("@keyword", { fg = KW })
        set("@keyword.import", { fg = KW })
        set("@keyword.function", { fg = KWFUNC })
        set("@keyword.type", { fg = KWTYPE })
        set("@keyword.return", { fg = KW })
        set("@keyword.conditional", { fg = KW })
        set("@keyword.repeat", { fg = KW })

        set("@operator", { fg = OP_PUNC })
        set("@punctuation", { fg = OP_PUNC })

        set("@lsp.type.variable", { fg = VAR })
        set("@lsp.type.parameter", { fg = PARAM, italic = true })
        set("@lsp.type.selfParameter", { fg = PARAM, italic = true })
        set("@lsp.type.property", { fg = FIELD, italic = true })
        set("@lsp.type.field", { fg = FIELD, italic = true })
        set("@lsp.type.function", { fg = FUNC, italic = true })
        set("@lsp.type.method", { fg = FUNC, italic = true })
        set("@lsp.type.class", { fg = TYPE })
        set("@lsp.type.interface", { fg = TYPE })
        set("@lsp.type.enum", { fg = TYPE })
        set("@lsp.type.type", { fg = TYPE })
        set("@lsp.type.enumMember", { fg = CONST })
        set("@lsp.type.string", { fg = STR })
        set("@lsp.type.number", { fg = CONST })
        set("@lsp.type.boolean", { fg = CONST })
        set("@lsp.type.namespace", { fg = MOD })
        set("@lsp.typemod.variable.member", { fg = FIELD, italic = true })
        set("@lsp.typemod.property.readonly", { fg = FIELD, italic = true })

        set("@attribute.go_tags", { fg = FIELD, bold = true, italic = true })
        set("@string.go_tags", { fg = STR })
        set("@punctuation.delimiter.go_tags", { fg = OP_PUNC })
        set("@punctuation.special.go_tags", { fg = OP_PUNC })
        set("@operator.go_tags", { fg = OP_PUNC })
      end

      vim.api.nvim_create_autocmd("ColorScheme", { group = aug, callback = apply })
      vim.api.nvim_create_autocmd("UIEnter", { group = aug, once = true, callback = apply })
    end,
  },
}
