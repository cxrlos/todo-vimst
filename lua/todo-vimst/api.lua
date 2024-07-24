local M = {}
local config = require('todo-vimst.config')
local curl = require('plenary.curl')
local utils = require('todo-vimst.utils')
local project_index = require('todo-vimst.project_index')

local API_BASE_URL = "https://api.todoist.com/rest/v2"

function M.create_task(task)
  local token = config.options.token
  if not token then
    error("Todoist API token not set. Use :TodoVimstSetup to configure.")
  end

  local project = project_index.get_or_create_project(task.project or config.options.project_id, M.get_projects, M.create_project)

  local labels = vim.list_extend(task.labels, {"todo-vimst"})

  local response = curl.post(API_BASE_URL .. "/tasks", {
    headers = {
      Authorization = "Bearer " .. token,
      ["Content-Type"] = "application/json",
    },
    body = vim.fn.json_encode({
      content = task.content,
      -- project_id = project and project.todoist_id or nil,
      project_id = "2336783752",
      priority = task.priority,
      labels = labels,
    }),
  })
  if response.status ~= 200 then
    error("API request failed: " .. response.body)
  end

  return vim.fn.json_decode(response.body)
end

function M.get_projects()
  local token = config.options.token
  if not token then
    error("Todoist API token not set. Use :TodoVimstSetup to configure.")
  end

  local response = curl.get(API_BASE_URL .. "/projects", {
    headers = {
      Authorization = "Bearer " .. token,
    },
  })

  if response.status ~= 200 then
    error("API request failed: " .. response.body)
  end

  return vim.fn.json_decode(response.body)
end

function M.create_project(name)
  local token = config.options.token
  if not token then
    error("Todoist API token not set. Use :TodoVimstSetup to configure.")
  end

  local response = curl.post(API_BASE_URL .. "/projects", {
    headers = {
      Authorization = "Bearer " .. token,
      ["Content-Type"] = "application/json",
    },
    body = vim.fn.json_encode({
      name = name,
    }),
  })

  if response.status ~= 200 then
    error("API request failed: " .. response.body)
  end

  return vim.fn.json_decode(response.body)
end

function M.delete_task(task_id)
  local token = config.options.token
  if not token then
    error("Todoist API token not set. Use :TodoVimstSetup to configure.")
  end

  local response = curl.delete(API_BASE_URL .. "/tasks/" .. task_id, {
    headers = {
      Authorization = "Bearer " .. token,
    },
  })

  if response.status ~= 204 then
    error("API request failed: " .. response.body)
  end

  return true
end

return M
