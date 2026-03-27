local M = {}

---@param tool_name string
---@param mode "resume"|"continue"
---@param opts? { show?: boolean, focus?: boolean }
function M.launch(tool_name, mode, opts)
  local Config = require("sidekick.config")
  local Session = require("sidekick.cli.session")
  local State = require("sidekick.cli.state")

  local tool = Config.get_tool(tool_name)
  local extra = tool[mode]
  if not extra then
    vim.notify(
      ("Sidekick tool %q has no %s command"):format(tool_name, mode),
      vim.log.levels.WARN
    )
    return
  end

  local session = Session.new({
    tool = tool:clone({
      cmd = vim.list_extend(vim.deepcopy(tool.cmd), vim.deepcopy(extra)),
    }),
    id = ("%s:%s:%d"):format(tool.name, mode, vim.uv.hrtime()),
  })

  State.attach(State.get_state(session), {
    show = opts == nil or opts.show ~= false,
    focus = opts == nil or opts.focus ~= false,
  })
end

---@param mode "resume"|"continue"
---@return fun(picker:any, item:any)
function M.picker_action(mode)
  return function(picker, item)
    local state = item and item.item or nil
    local tool_name = state and state.tool and state.tool.name or nil
    if not tool_name then
      return
    end

    picker:close()
    vim.schedule(function()
      M.launch(tool_name, mode, { show = true, focus = true })
    end)
  end
end

return M
