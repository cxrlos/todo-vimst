local M = {}

local COMMENT_PATTERNS = {
  "^%s*//",
  "^%s*#",
  "^%s*%-%-",
  "^%s*%%",
}

local PRIORITY_MAP = {
  P1 = 4,
  P2 = 3,
  P3 = 2,
  P4 = 1,
}

function M.parse_current_buffer()
  local todos = {}
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  for _, line in ipairs(lines) do
    for _, pattern in ipairs(COMMENT_PATTERNS) do
      local todo = line:match(pattern .. "%s*TODO:%s*(.*)")
      if todo then
        local priority = "P4"  -- Default priority
        local labels = {}

        -- Extract priority and labels
        todo = todo:gsub("#(%S+)", function(tag)
          if PRIORITY_MAP[tag] then
            priority = tag
            return ""
          else
            table.insert(labels, tag)
            return ""
          end
        end)

        -- Clean up the todo text
        todo = todo:gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")

        table.insert(todos, {
          content = todo,
          priority = PRIORITY_MAP[priority],
          labels = labels
        })
        break
      end
    end
  end

  return todos
end

return M
