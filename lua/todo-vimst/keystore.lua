local M = {}
local uv = vim.loop
local base64 = require('todo-vimst.base64')

local function get_config_path()
    return uv.os_homedir() .. '/.todo-vimst.key'
end

local function encrypt(text)
    -- Simple XOR encryption with a fixed key, it's not secure but it's better than plain text
    local key = "TodoVimstSecretKey"
    local result = {}
    for i = 1, #text do
        local byte = text:byte(i)
        local key_byte = key:byte((i - 1) % #key + 1)
        table.insert(result, string.char(bit.bxor(byte, key_byte)))
    end
    return base64.encode(table.concat(result))
end

local function decrypt(text)
    -- Simple XOR decryption with a fixed key, it's not secure but it's better than plain text
    local key = "TodoVimstSecretKey"
    text = base64.decode(text)
    local result = {}
    for i = 1, #text do
        local byte = text:byte(i)
        local key_byte = key:byte((i - 1) % #key + 1)
        table.insert(result, string.char(bit.bxor(byte, key_byte)))
    end
    return table.concat(result)
end

function M.save_token(token)
    local file = io.open(get_config_path(), "w")
    if file then
        file:write(encrypt(token))
        file:close()
        return true
    end
    return false
end

function M.load_token()
    local file = io.open(get_config_path(), "r")
    if file then
        local content = file:read("*all")
        file:close()
        return decrypt(content)
    end
    return nil
end

return M
