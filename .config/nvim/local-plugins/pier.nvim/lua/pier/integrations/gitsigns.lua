local M = {}

local function current_signs_enabled()
  local ok, cfg = pcall(require, "gitsigns.config")
  if not ok then
    return nil
  end
  local config = cfg.config or cfg
  if type(config) == "table" and type(config.signcolumn) == "boolean" then
    return config.signcolumn
  end
  return nil
end

---@param _ ReviewSessionState
---@return { signcolumn: boolean|nil }
function M.capture(_)
  return {
    signcolumn = current_signs_enabled(),
  }
end

---@param _ ReviewSessionState
---@param _ { signcolumn: boolean|nil }|nil
function M.apply(_, _)
  local ok, gitsigns = pcall(require, "gitsigns")
  if ok and gitsigns.toggle_signs then
    gitsigns.toggle_signs(false)
    if gitsigns.refresh then
      pcall(gitsigns.refresh)
    end
  end
end

---@param _ ReviewSessionState
---@param snapshot { signcolumn: boolean|nil }|nil
function M.restore(_, snapshot)
  if not snapshot or snapshot.signcolumn == nil then
    return
  end

  local ok, gitsigns = pcall(require, "gitsigns")
  if ok and gitsigns.toggle_signs then
    gitsigns.toggle_signs(snapshot.signcolumn)
    if gitsigns.refresh then
      pcall(gitsigns.refresh)
    end
  end
end

return M
