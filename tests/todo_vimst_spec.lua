local assert = require("luassert")
local todo_vimst = require("todo-vimst")
local api = require("todo-vimst.api")
local parser = require("todo-vimst.parser")
local utils = require("todo-vimst.utils")

describe("todo-vimst", function()
  local api_token = os.getenv("TODOIST_API_TOKEN")

  before_each(function()
    todo_vimst.setup({token = api_token})
  end)

  it("should parse TODO comments", function()
    local mock_lines = {
      "// TODO: Test task 1",
      "# TODO: Test task 2 #P1",
      "-- TODO: Test task 3 #Label1 #Label2",
      "% TODO: Test task 4",
    }

    stub(vim.api, "nvim_buf_get_lines", function() return mock_lines end)

    local todos = parser.parse_current_buffer()
    
    assert.are.same(4, #todos)
    assert.are.same("Test task 1", todos[1].content)
    assert.are.same(1, todos[1].priority)  -- Default priority
    assert.are.same("Test task 2", todos[2].content)
    assert.are.same(4, todos[2].priority)  -- P1 priority
    assert.are.same("Test task 3", todos[3].content)
    assert.are.same({"Label1", "Label2"}, todos[3].labels)
    assert.are.same("Test task 4", todos[4].content)

    vim.api.nvim_buf_get_lines:revert()
  end)

  it("should create a task in Todoist", function()
    local task = {
      content = "Test task from GitHub Actions",
      priority = 2,
      labels = {"GitHubTest"},
    }

    local success, result = pcall(api.create_task, task)
    assert.is_true(success)
    assert.is_not_nil(result)
    assert.is_not_nil(result.id)
    assert.are.same(task.content, result.content)
    assert.are.same(3, result.priority)  -- Todoist API uses 1-4 priority, opposite of our 1-4
    assert.are.same(task.labels, result.labels)

    -- Clean up: Delete the created task
    local delete_success = pcall(api.delete_task, result.id)
    assert.is_true(delete_success)
  end)

  it("should load and save API token", function()
    local config = require("todo-vimst.config")
    local keystore = require("todo-vimst.keystore")

    -- Save a test token
    local test_token = "test_token_123"
    local save_success = config.save_token(test_token)
    assert.is_true(save_success)

    -- Load the saved token
    local loaded_token = keystore.load_token()
    assert.are.same(test_token, loaded_token)

    -- Clean up: Delete the t
    os.remove(vim.loop.os_homedir() .. '/.todo-vimst.key')
  end)
end)
