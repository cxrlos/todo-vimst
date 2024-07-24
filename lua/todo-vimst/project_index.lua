local M = {}
local uv = vim.loop
local utils = require('todo-vimst.utils')

local function get_index_path()
    return uv.os_homedir() .. '/.todo-vimst/project_index.json'
end

local function load_index()
    local file = io.open(get_index_path(), "r")
    if file then
        local content = file:read("*all")
        file:close()
        return vim.fn.json_decode(content) or {}
    end
    return {}
end

local function save_index(index)
    local file = io.open(get_index_path(), "w")
    if file then
        file:write(vim.fn.json_encode(index))
        file:close()
        return true
    end
    return false
end

function M.get_project(name)
    local index = load_index()
    return index[name:lower()]
end

function M.add_project(name, todoist_id, location)
    local index = load_index()
    index[name:lower()] = {name = name, todoist_id = todoist_id, location = location}
    return save_index(index)
end

function M.find_project_by_name(name, get_projects_fn, create_project_fn)
    local projects = get_projects_fn()
    local matches = {}
    local search_pattern = "^" .. name:gsub("%s+", "%-"):lower() .. "%-"
    
    for _, project in ipairs(projects) do
        if project.name:lower():match(search_pattern) then
            table.insert(matches, project)
        end
    end
    
    if #matches == 1 then
        return matches[1]
    elseif #matches > 1 then
        utils.log_info("Multiple projects found. Please select one:")
        for i, project in ipairs(matches) do
            utils.log_info(string.format("%d. %s", i, project.name))
        end
        utils.log_info(string.format("%d. Create new project", #matches + 1))
        
        vim.ui.input({prompt = "Enter selection: "}, function(input)
            local selection = tonumber(input)
            if selection and selection >= 1 and selection <= #matches then
                return matches[selection]
            elseif selection == #matches + 1 then
                return create_project_fn(name)
            end
        end)
    else
        utils.log_info("No matching projects found.")
        vim.ui.input({prompt = "Create new project? [Y/n]: "}, function(input)
            if input:lower() ~= "n" then
                return create_project_fn(name)
            else
                vim.ui.input({prompt = "Enter project ID manually: "}, function(id)
                    return {name = name, id = id}
                end)
            end
        end)
    end
end

function M.get_or_create_project(name, get_projects_fn, create_project_fn)
    local project = M.get_project(name)
    if not project then
        project = M.find_project_by_name(name, get_projects_fn, create_project_fn)
        if project then
            M.add_project(project.name, project.id)
        end
    end
    return project
end

return M
