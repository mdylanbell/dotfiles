local function root()
  local source = debug.getinfo(1, "S").source:sub(2)
  return vim.fs.normalize(vim.fn.fnamemodify(source, ":p:h:h"))
end

local plugin_root = root()
local plenary_path = vim.env.PLENARY_PATH

if not plenary_path or plenary_path == "" then
  error("PLENARY_PATH must point to a plenary.nvim checkout")
end

vim.opt.runtimepath = {
  vim.env.VIMRUNTIME,
  plenary_path,
  plugin_root,
}
