local M = {}

M.options = {
  token = nil,
  project_id = nil,
  log_level = "info",
  create_on_save = false,
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
