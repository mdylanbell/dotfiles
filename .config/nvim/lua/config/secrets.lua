local M = {}

function M.vault()
  return vim.env.DOTFILES_1PASSWORD_VAULT or "dotfiles-personal"
end

function M.op_read(item, field)
  field = field or "credential"
  return ("cmd:op read op://%s/%s/%s"):format(M.vault(), item, field)
end

return M
