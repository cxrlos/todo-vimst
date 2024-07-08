-- parser.lua
local M = {}

local COMMENT_PATTERNS = {
  -- Default patterns (used when file type is not recognized)
  default = {
    { start = "^%s*//", continue = "^%s*//", end_pattern = nil },
    { start = "^%s*#", continue = "^%s*#", end_pattern = nil },
    { start = "^%s*%-%-", continue = "^%s*%-%-", end_pattern = nil },
    { start = "^%s*%%", continue = "^%s*%%", end_pattern = nil },
    { start = "^%s*/[*]", continue = "^%s*[*]?", end_pattern = "[*]/" },
  },
  -- C, C++, Java, JavaScript, TypeScript, PHP, Go, Rust, Swift
  c = {
    { start = "^%s*//", continue = "^%s*//", end_pattern = nil },
    { start = "^%s*/[*]", continue = "^%s*[*]?", end_pattern = "[*]/" },
  },
  -- Python, Ruby, Shell scripts, Perl
  python = {
    { start = "^%s*#", continue = "^%s*#", end_pattern = nil },
    { start = "^%s*'''", continue = "^%s*", end_pattern = "'''" },
    { start = '^%s*"""', continue = "^%s*", end_pattern = '"""' },
  },
  -- Lua
  lua = {
    { start = "^%s*%-%-", continue = "^%s*%-%-", end_pattern = nil },
    { start = "^%s*%-%-[[", continue = "^%s*", end_pattern = "]]" },
  },
  -- HTML, XML
  html = {
    { start = "^%s*<!%-%-", continue = "^%s*", end_pattern = "%-%->" },
  },
  -- SQL
  sql = {
    { start = "^%s*%-%-", continue = "^%s*%-%-", end_pattern = nil },
    { start = "^%s*/[*]", continue = "^%s*[*]?", end_pattern = "[*]/" },
  },
  -- MATLAB, Octave
  matlab = {
    { start = "^%s*%%", continue = "^%s*%%", end_pattern = nil },
    { start = "^%s*%[*", continue = "^%s*", end_pattern = "[*]/" },
  },
  -- Haskell
  haskell = {
    { start = "^%s*%-%-", continue = "^%s*%-%-", end_pattern = nil },
    { start = "^%s*{%-", continue = "^%s*", end_pattern = "%-}" },
  },
  -- Lisp, Clojure
  lisp = {
    { start = "^%s*;;", continue = "^%s*;;", end_pattern = nil },
  },
  -- Scala
  scala = {
    { start = "^%s*//", continue = "^%s*//", end_pattern = nil },
    { start = "^%s*/[*]", continue = "^%s*[*]?", end_pattern = "[*]/" },
  },
}

local PRIORITY_MAP = {
  P1 = 4,
  P2 = 3,
  P3 = 2,
  P4 = 1,
}

local function trim(s)
  return s:match("^%s*(.-)%s*$")
end

local function parse_todo(content)
  local priority = "P4"  -- Default priority
  local labels = {}
  
  -- Extract priority and labels
  content = content:gsub("#(%S+)", function(tag)
    if PRIORITY_MAP[tag] then
      priority = tag
      return ""
    else
      table.insert(labels, tag)
      return ""
    end
  end)
  
  -- Clean up the todo text
  content = content:gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
  
  return {
    content = content,
    priority = PRIORITY_MAP[priority],
    labels = labels
  }
end

function M.parse_current_buffer()
  local todos = {}
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local in_multiline = false
  local current_todo = nil
  local comment_pattern = nil
  
  -- Get the file type
  local file_type = vim.bo.filetype
  local patterns = COMMENT_PATTERNS[file_type] or COMMENT_PATTERNS.default

  for i, line in ipairs(lines) do
    if not in_multiline then
      for _, pattern in ipairs(patterns) do
        local todo_start = line:match(pattern.start .. "%s*TODO:%s*(.*)")
        if todo_start then
          current_todo = todo_start
          comment_pattern = pattern
          if pattern.end_pattern then
            in_multiline = true
          end
          break
        end
      end
    else
      if comment_pattern.end_pattern and line:match(comment_pattern.end_pattern) then
        in_multiline = false
        todos[#todos + 1] = parse_todo(current_todo)
        current_todo = nil
      elseif line:match(comment_pattern.continue) then
        current_todo = current_todo .. " " .. trim(line:gsub(comment_pattern.continue, ""))
      else
        in_multiline = false
        todos[#todos + 1] = parse_todo(current_todo)
        current_todo = nil
      end
    end

    if current_todo and not in_multiline then
      if i < #lines and lines[i+1]:match(comment_pattern.continue) then
        current_todo = current_todo .. " " .. trim(lines[i+1]:gsub(comment_pattern.continue, ""))
      else
        todos[#todos + 1] = parse_todo(current_todo)
        current_todo = nil
      end
    end
  end

  if current_todo then
    todos[#todos + 1] = parse_todo(current_todo)
  end

  return todos
end

return M
