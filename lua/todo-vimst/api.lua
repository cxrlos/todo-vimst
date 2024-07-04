local M = {}
local config = require('todo-vimst.config')
local curl = require('plenary.curl')
local utils = require('todo-vimst.utils')

local API_BASE_URL = "https://api.todoist.com/rest/v2"

function M.create_task(task)
  local token = config.options.token
  if not token then
    error("Todoist API token not set. Use :TodoVimstSetup to configure.")
  end

  local project_id = config.options.project_id

  local response = curl.post(API_BASE_URL .. "/tasks", {
    headers = {
      Authorization = "Bearer " .. token,
      ["Content-Type"] = "application/json",
    },
    body = vim.fn.json_encode({
      content = task.content,
      project_id = project_id,
      priority = task.priority,
      labels = task.labels,
    }),
  })

  if response.status ~= 200 then
    error("API request failed: " .. response.body)
  end

  return vim.fn.json_decode(response.body)
end

return M
