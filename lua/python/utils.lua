-- lua/python/utils.lua
-- Utility functions for python.nvim

local M = {}

---Check if a file exists
---@param path string File path
---@return boolean exists
function M.file_exists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

---Check if a directory exists
---@param path string Directory path
---@return boolean exists
function M.directory_exists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return vim.fn.isdirectory(path) == 1
    end
    return false
end

---Join path components
---@param ... string Path components
---@return string joined_path
function M.join_paths(...)
    local parts = {...}
    return table.concat(parts, "/")
end

---Get parent directory
---@param path string Directory path
---@return string parent_path
function M.get_parent_directory(path)
    return path:match("(.*)/[^/]*$") or path
end

---Find executable in PATH
---@param command string Command name
---@return string? path
function M.which(command)
    local output = vim.fn.system("which " .. command)
    if vim.v.shell_error == 0 then
        return output:gsub("%s+$", "")
    end
    return nil
end

---Run command and return output
---@param args string[] Command arguments
---@param cwd? string Working directory
---@return string? output
function M.run_command(args, cwd)
    local job_opts = {
        cwd = cwd or vim.fn.getcwd(),
    }
    
    local output = ""
    local job_id = vim.fn.jobstart(args, {
        cwd = job_opts.cwd,
        on_stdout = function(_, data)
            for _, line in ipairs(data) do
                output = output .. line .. "\n"
            end
        end,
        on_stderr = function(_, data)
            for _, line in ipairs(data) do
                output = output .. line .. "\n"
            end
        end,
    })
    
    if job_id > 0 then
        vim.fn.jobwait({job_id})
        return output:gsub("%s+$", "")
    end
    
    return nil
end

---Read file content
---@param path string File path
---@return string? content
function M.read_file(path)
    local file = io.open(path, "r")
    if not file then
        return nil
    end
    
    local content = file:read("*a")
    file:close()
    return content
end

---Write file content
---@param path string File path
---@param content string File content
---@return boolean success
function M.write_file(path, content)
    local file = io.open(path, "w")
    if not file then
        return false
    end
    
    file:write(content)
    file:close()
    return true
end

---Get buffer content
---@param bufnr? number Buffer number (default: current buffer)
---@return string content
function M.get_buffer_content(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    return table.concat(lines, "\n")
end

---Set buffer content
---@param content string Content to set
---@param bufnr? number Buffer number (default: current buffer)
function M.set_buffer_content(content, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

---Safe require with error handling
---@param module_name string Module name
---@return any? module
function M.safe_require(module_name)
    local success, module = pcall(require, module_name)
    if not success then
        vim.notify("Failed to load module: " .. module_name, vim.log.levels.WARN)
        return nil
    end
    return module
end

---Create autocmd with error handling
---@param events string|string[] Events
---@param pattern string|string[] Pattern
---@param callback function Callback function
---@param opts? table Options
function M.create_autocmd(events, pattern, callback, opts)
    opts = opts or {}
    local group = opts.group or "PythonGroup"
    
    vim.api.nvim_create_autocmd(events, {
        pattern = pattern,
        callback = callback,
        group = group,
        once = opts.once or false,
        nested = opts.nested or false,
    })
end

---Notify with title
---@param message string Message
---@param level number Log level
---@param opts? table Options
function M.notify(message, level, opts)
    opts = opts or {}
    opts.title = opts.title or "python.nvim"
    vim.notify(message, level, opts)
end

---Parse JSON safely
---@param json_string string JSON string
---@return table? parsed
function M.parse_json(json_string)
    local ok, parsed = pcall(vim.json_decode, json_string)
    if ok then
        return parsed
    end
    return nil
end

---Stringify table safely
---@param table table Table to stringify
---@return string? json_string
function M.stringify_json(table)
    local ok, json_string = pcall(vim.json_encode, table)
    if ok then
        return json_string
    end
    return nil
end

return M 