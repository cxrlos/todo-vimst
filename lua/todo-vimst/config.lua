local M = {}
local keystore = require('todo-vimst.keystore')

M.options = {
  token = nil,
  project_id = nil,
  log_level = "error",
  create_on_save = false,
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
  
  -- Load token from keystore if not provided
  if not M.options.token then
    M.options.token = keystore.load_token()
  end
end

function M.save_token(token)
  M.options.token = token
  return keystore.save_token(token)
end

return M
