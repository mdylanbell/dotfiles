local M = {}

local function load_minidiff()
  local ok, lazy = pcall(require, "lazy")
  if ok then
    lazy.load({ plugins = { "mini.diff" }, wait = true })
  end
  local ok_diff, diff = pcall(require, "mini.diff")
  if not ok_diff then
    return nil
  end
  return diff
end

local function is_enabled(buf)
  return vim.api.nvim_buf_is_valid(buf) and vim.b[buf].minidiff_summary ~= nil
end

---@param state PierSessionState
---@return { buf: integer|nil, enabled: boolean, global_disable: boolean }
function M.capture(state)
  local buf = state.review_buf
  return {
    buf = buf,
    enabled = type(buf) == "number" and is_enabled(buf) or false,
    global_disable = vim.g.minidiff_disable == true,
  }
end

---@param state PierSessionState
---@param snapshot { buf: integer|nil, enabled: boolean, global_disable: boolean }|nil
function M.apply(state, snapshot)
  local diff = load_minidiff()
  local buf = state.review_buf or (snapshot and snapshot.buf) or nil
  if not diff or type(buf) ~= "number" or not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  vim.g.minidiff_disable = false
  diff.enable(buf)
end

---@param state PierSessionState
---@param snapshot { buf: integer|nil, enabled: boolean, global_disable: boolean }|nil
function M.restore(state, snapshot)
  local diff = load_minidiff()
  vim.g.minidiff_disable = snapshot and snapshot.global_disable == true or false

  local session_buf = state.review_buf
  if diff and type(session_buf) == "number" and vim.api.nvim_buf_is_valid(session_buf) then
    local keep_enabled = snapshot and snapshot.enabled and snapshot.buf == session_buf
    if not keep_enabled then
      diff.disable(session_buf)
    end
  end

  if not snapshot or type(snapshot.buf) ~= "number" or not vim.api.nvim_buf_is_valid(snapshot.buf) then
    return
  end
  if snapshot.buf ~= session_buf and not snapshot.enabled then
    if diff and diff.disable then
      diff.disable(snapshot.buf)
    end
  end
end

return M
