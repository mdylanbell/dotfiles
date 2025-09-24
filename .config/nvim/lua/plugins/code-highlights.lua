return {
  {
    "LazyVim/LazyVim",
    init = function()
      local aug = vim.api.nvim_create_augroup("solarized_role_overrides", { clear = true })

      local function get_colors()
        -- Prefer maxmx03/solarized.nvim palette if available
        local ok, utils = pcall(require, "solarized.utils")
        if ok and utils.get_colors then
          return utils.get_colors()
        end
        -- Fallback: sample colors from existing highlight groups (works with other themes)
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
        -- apply only if something to set (prevents clobbering with empty tables)
        if spec.fg or spec.bg or spec.bold or spec.italic or spec.underline or spec.undercurl or spec.link then
          vim.api.nvim_set_hl(0, name, spec)
        end
      end

      local function apply()
        local c = get_colors()

        -- ROLE → COLOR (Solarized rationale):
        -- Variables neutral (base0), params/fields subtle italics, functions blue landmarks,
        -- keywords green, strings cyan, constants orange, modules yellow,
        -- decorators violet, exceptions magenta, ops/punct base1, types base3.
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
        local KWFUNC = KW -- keywords that introduce/relate to functions (e.g., def/fn)
        local KWTYPE = KW -- keywords that introduce/relate to types (e.g., class/type/interface)

        ----------------------------------------------------------------------
        -- Tree-sitter (generic, multi-language)
        ----------------------------------------------------------------------
        -- Variables & identifiers
        set("@variable", { fg = VAR })
        set("@variable.parameter", { fg = PARAM, italic = true })
        set("@variable.member", { fg = FIELD, italic = true })
        -- set("@variable.builtin",      { fg = VAR }) -- OPTIONAL: keep default if you like 'self/cls' distinct

        -- Properties / fields
        set("@property", { fg = FIELD, italic = true })
        set("@field", { fg = FIELD, italic = true })

        -- Functions / methods / constructors
        set("@function", { fg = FUNC, italic = true })
        set("@function.call", { fg = FUNC, italic = true })
        set("@function.method", { fg = FUNC, italic = true })
        set("@function.method.call", { fg = FUNC, italic = true })
        set("@constructor", { fg = FUNC })

        -- Types / classes / interfaces / enums
        set("@type", { fg = TYPE })
        set("@type.builtin", { fg = TYPE, italic = true })

        -- Modules / namespaces
        set("@module", { fg = MOD })
        set("@namespace", { fg = MOD })

        -- Constants / numbers / booleans
        set("@constant", { fg = CONST })
        set("@constant.builtin", { fg = CONST })
        set("@number", { fg = CONST })
        set("@boolean", { fg = CONST })

        -- Strings / chars
        set("@string", { fg = STR })
        set("@string.special", { fg = STR })
        set("@character", { fg = STR })

        -- Decorators / annotations
        set("@attribute", { fg = DECOR, italic = true })

        -- Exceptions
        set("@exception", { fg = EXC })
        set("@keyword.exception", { fg = EXC })

        -- Keywords / control
        set("@keyword", { fg = KW }) -- generic fallback
        set("@keyword.import", { fg = KW })

        -- Function-ish keywords (e.g., def, function, fn)
        set("@keyword.function", { fg = KWFUNC })

        -- Type-ish keywords (e.g., class, type, interface)
        set("@keyword.type", { fg = KWTYPE })

        -- Other useful keyword families you might want aligned (optional):
        set("@keyword.return", { fg = KW })
        set("@keyword.conditional", { fg = KW })
        set("@keyword.repeat", { fg = KW })

        -- Operators / punctuation
        set("@operator", { fg = OP_PUNC })
        set("@punctuation", { fg = OP_PUNC })

        ----------------------------------------------------------------------
        -- LSP semantic tokens (mirror roles so LSP can’t “repaint” differently)
        ----------------------------------------------------------------------
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

        -- (Intentionally leave @lsp.type.keyword and diagnostics to the theme.)
      end

      -- Re-apply after any colorscheme, and once at UI start
      vim.api.nvim_create_autocmd("ColorScheme", { group = aug, callback = apply })
      vim.api.nvim_create_autocmd("UIEnter", { group = aug, once = true, callback = apply })
    end,
  },
}
