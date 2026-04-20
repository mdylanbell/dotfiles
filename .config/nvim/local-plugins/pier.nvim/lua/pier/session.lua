---@class PierSessionState
---@field active boolean
---@field container string|nil
---@field pr_num string|number|nil
---@field base_ref string|nil
---@field repo_dir string|nil
---@field review_buf integer|nil
---@field octo_opened boolean
---@field octo_tab integer|nil
---@field octo_tab_created boolean
---@field integration_state table<string, any>

---@type PierSessionState
local state = {
  active = false,
  container = nil,
  pr_num = nil,
  base_ref = nil,
  repo_dir = nil,
  review_buf = nil,
  octo_opened = false,
  octo_tab = nil,
  octo_tab_created = false,
  integration_state = {},
}

return state
