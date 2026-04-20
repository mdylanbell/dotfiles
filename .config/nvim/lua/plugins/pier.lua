local function diffview_toggle()
  local ok, lib = pcall(require, "diffview.lib")
  if ok and lib.get_current_view() then
    vim.cmd("DiffviewClose")
    return
  end
  pcall(vim.api.nvim_cmd, { cmd = "DiffviewOpen" }, {})
end

local function add_pier_dashboard_key(keys)
  local ret = vim.deepcopy(keys or {})
  for _, item in ipairs(ret) do
    if item.key == "R" then
      return ret
    end
  end

  local ok, pier = pcall(require, "pier")
  if ok and pier.container_root() then
    table.insert(ret, {
      icon = "󰈈 ",
      key = "R",
      desc = "Review PR",
      action = function()
        vim.cmd("Pier open")
      end,
    })
  end

  return ret
end

return {
  {
    dir = vim.fn.stdpath("config") .. "/local-plugins/pier.nvim",
    name = "pier.nvim",
    lazy = false,
    config = function()
      require("pier").setup()
    end,
  },

  {
    "nvim-mini/mini.diff",
    event = "VeryLazy",
  },

  {
    "pwntester/octo.nvim",
    opts = {
      enable_builtin = true,
      default_to_projects_v2 = false,
      use_local_fs = true,
    },
    keys = {
      { "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List Issues (Octo)" },
      { "<leader>gI", "<cmd>Octo issue search<CR>", desc = "Search Issues (Octo)" },
      { "<leader>go", "<cmd>Octo<CR>", desc = "Octo Palette" },
      { "<leader>gp", "<cmd>Octo pr list<CR>", desc = "List PRs (Octo)" },
      { "<leader>gP", "<cmd>Octo pr search<CR>", desc = "Search PRs (Octo)" },
      { "<leader>gr", "<cmd>Octo repo list<CR>", desc = "List Repos (Octo)" },
      { "<leader>gS", "<cmd>Octo search<CR>", desc = "Search (Octo)" },
      { "<leader>Ro", "<cmd>Octo<CR>", desc = "Octo Palette" },
    },
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = function(_, opts)
      opts = opts or {}
      opts.spec = opts.spec or {}
      table.insert(opts.spec, { "<leader>R", group = "Review" })
      return opts
    end,
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      opts = opts or {}
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}
      opts.dashboard.preset.keys = add_pier_dashboard_key(opts.dashboard.preset.keys)

      return opts
    end,
  },

  {
    "sindrets/diffview.nvim",
    keys = {
      {
        "<leader>RP",
        function()
          require("pier").toggle()
        end,
        desc = "Pier Toggle",
      },
      {
        "<leader>RO",
        function()
          require("pier").open_octo()
        end,
        desc = "Pier Octo Open",
      },
      {
        "<leader>RF",
        function()
          require("pier").open_octo_file()
        end,
        desc = "Pier Octo Open File",
      },
      {
        "<leader>RD",
        diffview_toggle,
        desc = "Pier Diffview Toggle",
      },
    },
  },
}
