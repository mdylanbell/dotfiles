require("config.patch_lsp_double_stop")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- disable latex rendering
require("render-markdown").setup({ latex = { enabled = false } })
