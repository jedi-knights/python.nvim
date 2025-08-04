-- lua/python/detector.lua
-- Project and environment detection for python.nvim

local M = {}

---Check if we should load the plugin
---@param deps? table Dependencies for testing
---@return boolean should_load
function M.should_load(deps)
    deps = deps or {}
    local config = deps.config or require("python.config")
    local notify = deps.notify or vim.notify
    
    -- Check if current buffer is a Python file
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)
    
    if filename:match("%.py$") then
        if config.debug then
            notify("python.nvim: Loading for Python file: " .. filename, config.log_level, { title = "python.nvim" })
        end
        return true
    end
    
    -- Check if we're in a Python project directory
    local project_info = M.get_project_info(deps)
    if project_info.is_python_project then
        if config.debug then
            notify("python.nvim: Loading for Python project: " .. project_info.root, config.log_level, { title = "python.nvim" })
        end
        return true
    end
    
    return false
end

---Get project information
---@param deps? table Dependencies for testing
---@return table project_info
function M.get_project_info(deps)
    deps = deps or {}
    local config = deps.config or require("python.config")
    local utils = deps.utils or require("python.utils")
    
    local cwd = vim.fn.getcwd()
    local project_info = {
        root = cwd,
        is_python_project = false,
        has_requirements = false,
        has_pyproject = false,
        has_setup_py = false,
        has_venv = false,
        venv_path = nil,
        python_path = nil,
        package_manager = config.package_manager,
    }
    
    -- Check for Python project files
    local files_to_check = {
        "requirements.txt",
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "Pipfile",
        "poetry.lock",
    }
    
    for _, file in ipairs(files_to_check) do
        local file_path = utils.join_paths(cwd, file)
        if utils.file_exists(file_path) then
            project_info.is_python_project = true
            
            if file == "requirements.txt" then
                project_info.has_requirements = true
            elseif file == "pyproject.toml" then
                project_info.has_pyproject = true
            elseif file == "setup.py" then
                project_info.has_setup_py = true
            end
        end
    end
    
    -- Check for virtual environment
    local venv_path = M.find_venv_path(cwd, deps)
    if venv_path then
        project_info.has_venv = true
        project_info.venv_path = venv_path
        project_info.python_path = utils.join_paths(venv_path, "bin", "python")
        
        -- Check if Python executable exists
        if not utils.file_exists(project_info.python_path) then
            project_info.python_path = utils.join_paths(venv_path, "Scripts", "python.exe")
        end
    else
        -- Use system Python
        project_info.python_path = M.get_system_python_path(deps)
    end
    
    return project_info
end

---Find virtual environment path
---@param cwd string Current working directory
---@param deps? table Dependencies for testing
---@return string? venv_path
function M.find_venv_path(cwd, deps)
    deps = deps or {}
    local config = deps.config or require("python.config")
    local utils = deps.utils or require("python.utils")
    
    if not config.enable_virtual_env then
        return nil
    end
    
    -- Common virtual environment directories
    local venv_dirs = {
        ".venv",
        "venv",
        "env",
        ".env",
        "virtualenv",
        ".virtualenv",
    }
    
    -- Check for virtual environment in current directory
    for _, dir in ipairs(venv_dirs) do
        local venv_path = utils.join_paths(cwd, dir)
        if utils.directory_exists(venv_path) then
            return venv_path
        end
    end
    
    -- Check parent directories for virtual environment
    local current_dir = cwd
    for i = 1, 5 do -- Limit search depth
        local parent_dir = utils.get_parent_directory(current_dir)
        if parent_dir == current_dir then
            break
        end
        
        for _, dir in ipairs(venv_dirs) do
            local venv_path = utils.join_paths(parent_dir, dir)
            if utils.directory_exists(venv_path) then
                return venv_path
            end
        end
        
        current_dir = parent_dir
    end
    
    return nil
end

---Get system Python path
---@param deps? table Dependencies for testing
---@return string? python_path
function M.get_system_python_path(deps)
    deps = deps or {}
    local config = deps.config or require("python.config")
    local utils = deps.utils or require("python.utils")
    
    -- Try to find Python executable
    local python_commands = {
        config.python_command,
        "python3",
        "python",
        "py",
    }
    
    for _, cmd in ipairs(python_commands) do
        local path = utils.which(cmd)
        if path then
            return path
        end
    end
    
    return nil
end

---Get Python executable path
---@param deps? table Dependencies for testing
---@return string? python_path
function M.get_python_path(deps)
    deps = deps or {}
    local project_info = M.get_project_info(deps)
    return project_info.python_path
end

---Check if Python is available
---@param deps? table Dependencies for testing
---@return boolean available
function M.is_python_available(deps)
    deps = deps or {}
    local python_path = M.get_python_path(deps)
    return python_path ~= nil
end

---Check if virtual environment is active
---@param deps? table Dependencies for testing
---@return boolean active
function M.is_venv_active(deps)
    deps = deps or {}
    local utils = deps.utils or require("python.utils")
    
    -- Check VIRTUAL_ENV environment variable
    local virtual_env = vim.env.VIRTUAL_ENV
    if virtual_env and utils.directory_exists(virtual_env) then
        return true
    end
    
    -- Check if current Python path is in a virtual environment
    local python_path = M.get_python_path(deps)
    if python_path then
        return python_path:match("/venv/") or python_path:match("/env/") or python_path:match("/virtualenv/")
    end
    
    return false
end

---Get Python version
---@param deps? table Dependencies for testing
---@return string? version
function M.get_python_version(deps)
    deps = deps or {}
    local python_path = M.get_python_path(deps)
    local utils = deps.utils or require("python.utils")
    
    if not python_path then
        return nil
    end
    
    local output = utils.run_command({ python_path, "--version" })
    if output then
        return output:match("Python (%d+%.%d+%.%d+)")
    end
    
    return nil
end

---Check if package is installed
---@param package_name string Name of the package
---@param deps? table Dependencies for testing
---@return boolean installed
function M.is_package_installed(package_name, deps)
    deps = deps or {}
    local python_path = M.get_python_path(deps)
    local utils = deps.utils or require("python.utils")
    
    if not python_path then
        return false
    end
    
    local output = utils.run_command({ python_path, "-c", "import " .. package_name })
    return output ~= nil
end

---Get installed packages
---@param deps? table Dependencies for testing
---@return string[] packages
function M.get_installed_packages(deps)
    deps = deps or {}
    local python_path = M.get_python_path(deps)
    local utils = deps.utils or require("python.utils")
    
    if not python_path then
        return {}
    end
    
    local output = utils.run_command({ python_path, "-m", "pip", "list", "--format=freeze" })
    if not output then
        return {}
    end
    
    local packages = {}
    for line in output:gmatch("[^\r\n]+") do
        local package_name = line:match("^([^=]+)=")
        if package_name then
            table.insert(packages, package_name)
        end
    end
    
    return packages
end

---Check if formatter is available
---@param formatter_name string Name of the formatter
---@param deps? table Dependencies for testing
---@return boolean available
function M.is_formatter_available(formatter_name, deps)
    deps = deps or {}
    local utils = deps.utils or require("python.utils")
    
    local formatter_commands = {
        black = "black",
        isort = "isort",
        autopep8 = "autopep8",
    }
    
    local command = formatter_commands[formatter_name]
    if not command then
        return false
    end
    
    return utils.which(command) ~= nil
end

---Check if linter is available
---@param linter_name string Name of the linter
---@param deps? table Dependencies for testing
---@return boolean available
function M.is_linter_available(linter_name, deps)
    deps = deps or {}
    local utils = deps.utils or require("python.utils")
    
    local linter_commands = {
        flake8 = "flake8",
        pylint = "pylint",
        mypy = "mypy",
    }
    
    local command = linter_commands[linter_name]
    if not command then
        return false
    end
    
    return utils.which(command) ~= nil
end

---Check if test framework is available
---@param framework_name string Name of the test framework
---@param deps? table Dependencies for testing
---@return boolean available
function M.is_test_framework_available(framework_name, deps)
    deps = deps or {}
    local utils = deps.utils or require("python.utils")
    
    local framework_commands = {
        pytest = "pytest",
        unittest = "python", -- unittest is built-in
        nose = "nosetests",
    }
    
    local command = framework_commands[framework_name]
    if not command then
        return false
    end
    
    if framework_name == "unittest" then
        return true -- unittest is always available
    end
    
    return utils.which(command) ~= nil
end

return M 