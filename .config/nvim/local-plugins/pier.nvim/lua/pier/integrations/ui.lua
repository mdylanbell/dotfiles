local M = {}

---@param _ ReviewSessionState
---@return { showtabline: integer }
function M.capture(_)
  return {
    showtabline = vim.o.showtabline,
  }
end

---@param _ ReviewSessionState
---@param _ { showtabline: integer }|nil
function M.apply(_, _)
  vim.o.showtabline = 2
end

---@param _ ReviewSessionState
---@param snapshot { showtabline: integer }|nil
function M.restore(_, snapshot)
  if snapshot and type(snapshot.showtabline) == "number" then
    vim.o.showtabline = snapshot.showtabline
  end
end

return M
