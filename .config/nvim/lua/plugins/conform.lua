-- Formatting via Conform, using CLIs installed with mise (on PATH).
return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    local fb = opts.formatters_by_ft

    -- Python: ruff fix (incl. import sorting) then ruff format
    fb.python = { "ruff_fix", "ruff_format" }

    -- Lua / TOML
    fb.lua = { "stylua" }
    fb.toml = { "taplo" }

    -- JS/TS/JSON/YAML/Markdown
    fb.javascript = { "prettier" }
    fb.typescript = { "prettier" }
    fb.javascriptreact = { "prettier" }
    fb.typescriptreact = { "prettier" }
    fb.json = { "prettier" }
    fb.yaml = { "prettier" }
    fb.markdown = { "prettier" }

    -- Terraform (only works on hosts where terraform is present; enabled via MISE_ENV=work)
    fb.terraform = { "terraform_fmt" }
    fb["terraform-vars"] = { "terraform_fmt" }
  end,
}
