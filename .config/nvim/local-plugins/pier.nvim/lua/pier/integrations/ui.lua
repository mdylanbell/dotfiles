local M = {}

---@return { showtabline: integer }
function M.capture()
  return {
    showtabline = vim.o.showtabline,
  }
end

function M.apply()
  vim.o.showtabline = 2
end

---@param snapshot { showtabline: integer }|nil
function M.restore(_, snapshot)
  if snapshot and type(snapshot.showtabline) == "number" then
    vim.o.showtabline = snapshot.showtabline
  end
end

return M
