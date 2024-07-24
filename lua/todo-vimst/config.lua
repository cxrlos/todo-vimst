local M = {}
local keystore = require('todo-vimst.keystore')
local uv = vim.loop

M.options = {
  token = nil,
  project_id = nil,
  log_level = "error",
  create_on_save = false,
}

local function ensure_config_folder()
    local config_path = uv.os_homedir() .. '/.todo-vimst'
    uv.fs_mkdir(config_path, 448) -- 448 is 0700 in octal (rwx------)
    return config_path
end

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
  
  -- Ensure config folder exists
  local config_path = ensure_config_folder()
  if config_path then
    -- utils.log_info("Todo-vimst config folder created at: " .. config_path)
    print("Todo-vimst config folder created at: " .. config_path)
  end

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
