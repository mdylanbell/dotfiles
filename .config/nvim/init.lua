-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Expand XDG_CACHE_HOME so provider resolves to the actual venv path
vim.g.python3_host_prog = vim.fn.expand("$XDG_CACHE_HOME/venv/default/bin/python")

-- disable latex rendering
require("render-markdown").setup({ latex = { enabled = false } })
