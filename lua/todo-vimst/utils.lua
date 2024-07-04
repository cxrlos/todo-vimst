local M = {}
local config = require('todo-vimst.config')

local LOG_LEVELS = {
  debug = 1,
  info = 2,
  warn = 3,
  error = 4,
}

local function log(level, message)
  if LOG_LEVELS[level] >= LOG_LEVELS[config.options.log_level] then
    vim.notify("[todo-vimst] " .. message, vim.log.levels[level:upper()])
  end
end

function M.log_debug(message) log("debug", message) end
function M.log_info(message) log("info", message) end
function M.log_warn(message) log("warn", message) end
function M.log_error(message) log("error", message) end

return M
