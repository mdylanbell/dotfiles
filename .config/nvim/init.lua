-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- set python
vim.g.python3_host_prog = "$XDG_CACHE_HOME/venv/default/bin/python"

-- disable latex rendering
require("render-markdown").setup({ latex = { enabled = false } })
