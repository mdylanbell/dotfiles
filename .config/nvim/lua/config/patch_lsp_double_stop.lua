-- Neovim 0.11 compatibility: avoid duplicate graceful shutdown requests on
-- VimLeavePre. Upstream master uses a single-pass exit handler.
if vim.fn.has("nvim-0.12") == 0 then
  local Client = require("vim.lsp.client")
  local orig_stop = Client.stop

  ---@diagnostic disable-next-line: duplicate-set-field
  function Client:stop(force)
    -- Ignore redundant graceful-stop requests while shutdown is already in
    -- progress. Still allow timeout/forced termination paths through.
    if self._is_stopping and force ~= true and type(force) ~= "number" then
      return
    end
    return orig_stop(self, force)
  end
end
