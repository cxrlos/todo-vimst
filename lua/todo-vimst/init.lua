local M = {}
local config = require('todo-vimst.config')
local api = require('todo-vimst.api')
local parser = require('todo-vimst.parser')
local utils = require('todo-vimst.utils')

function M.setup(opts)
  config.setup(opts)
  
  if config.options.create_on_save then
      -- print debug message
    utils.log_debug("Setting up autocmd for BufWritePost")
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = vim.api.nvim_create_augroup("TodoVimst", { clear = true }),
      callback = function()
        M.create_tasks()
      end,
    })
  end
end

function M.create_tasks()
  local todos = parser.parse_current_buffer()
  for _, todo in ipairs(todos) do
    local success, result = pcall(api.create_task, todo)
    if success then
      local priority_str = "P" .. (5 - todo.priority)
      local labels_str = table.concat(todo.labels, ", ")
      local log_msg = string.format("Task created: %s (Priority: %s", todo.content, priority_str)
      if #todo.labels > 0 then
        log_msg = log_msg .. ", Labels: " .. labels_str
      end
      log_msg = log_msg .. ")"
      utils.log_info(log_msg)
    else
      utils.log_error("Failed to create task: " .. todo.content .. ". Error: " .. result)
    end
  end
end

return M
