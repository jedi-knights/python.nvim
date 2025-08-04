-- lua/python/config.lua
-- Configuration management for python.nvim

local M = {}

-- Default configuration following DRY principles
local default_config = {
    python_command = "python3",
    enable_virtual_env = true,
    auto_detect_venv = true,
    
    -- Formatters
    formatters = {
        black = { enabled = true, line_length = 88 },
        isort = { enabled = true, profile = "black" },
        autopep8 = { enabled = false },
    },
    
    -- Linters
    linters = {
        flake8 = { enabled = true },
        pylint = { enabled = false },
        mypy = { enabled = true },
    },
    
    -- Test frameworks
    test_frameworks = {
        pytest = { enabled = true },
        unittest = { enabled = true },
        nose = { enabled = false },
    },
    
    -- Environment management
    environments = {
        default = "venv",
        auto_create = true,
        auto_activate = true,
        venv_path = ".venv",
    },
    
    -- Package management
    package_manager = "pip",
    auto_install_deps = true,
    
    -- Code intelligence
    enable_import_sorting = true,
    enable_auto_import = true,
    enable_type_checking = true,
    
    -- Testing
    test_coverage = {
        enabled = true,
        tool = "coverage",
        show_inline = true,
    },
    
    -- Debugging
    debugger = {
        enabled = true,
        adapter = "debugpy",
        port = 5678,
    },
    
    -- REPL
    repl = {
        enabled = true,
        floating = true,
        auto_import = true,
    },
    
    -- UI
    enable_floating_terminals = true,
    enable_notifications = true,
    enable_debugging = true,
    debug = false,
    log_level = vim.log.levels.INFO,
}

-- Validate configuration values
local function validate_config(config)
    -- Validate core settings
    if type(config.python_command) ~= "string" or config.python_command == "" then
        error("python_command must be a non-empty string")
    end
    
    if type(config.enable_virtual_env) ~= "boolean" then
        error("enable_virtual_env must be a boolean")
    end
    
    if type(config.auto_detect_venv) ~= "boolean" then
        error("auto_detect_venv must be a boolean")
    end
    
    -- Validate formatters
    if config.formatters then
        for name, settings in pairs(config.formatters) do
            if type(settings.enabled) ~= "boolean" then
                error(string.format("formatters.%s.enabled must be a boolean", name))
            end
            if settings.line_length and type(settings.line_length) ~= "number" then
                error(string.format("formatters.%s.line_length must be a number", name))
            end
        end
    end
    
    -- Validate linters
    if config.linters then
        for name, settings in pairs(config.linters) do
            if type(settings.enabled) ~= "boolean" then
                error(string.format("linters.%s.enabled must be a boolean", name))
            end
        end
    end
    
    -- Validate test frameworks
    if config.test_frameworks then
        for name, settings in pairs(config.test_frameworks) do
            if type(settings.enabled) ~= "boolean" then
                error(string.format("test_frameworks.%s.enabled must be a boolean", name))
            end
        end
    end
    
    -- Validate environments
    if config.environments then
        if type(config.environments.default) ~= "string" then
            error("environments.default must be a string")
        end
        if type(config.environments.auto_create) ~= "boolean" then
            error("environments.auto_create must be a boolean")
        end
        if type(config.environments.auto_activate) ~= "boolean" then
            error("environments.auto_activate must be a boolean")
        end
    end
    
    -- Validate package manager
    if type(config.package_manager) ~= "string" then
        error("package_manager must be a string")
    end
    
    -- Validate debugging settings
    if config.debugger then
        if type(config.debugger.enabled) ~= "boolean" then
            error("debugger.enabled must be a boolean")
        end
        if type(config.debugger.adapter) ~= "string" then
            error("debugger.adapter must be a string")
        end
        if type(config.debugger.port) ~= "number" then
            error("debugger.port must be a number")
        end
    end
    
    -- Validate REPL settings
    if config.repl then
        if type(config.repl.enabled) ~= "boolean" then
            error("repl.enabled must be a boolean")
        end
        if type(config.repl.floating) ~= "boolean" then
            error("repl.floating must be a boolean")
        end
        if type(config.repl.auto_import) ~= "boolean" then
            error("repl.auto_import must be a boolean")
        end
    end
    
    -- Validate UI settings
    if type(config.enable_floating_terminals) ~= "boolean" then
        error("enable_floating_terminals must be a boolean")
    end
    
    if type(config.enable_notifications) ~= "boolean" then
        error("enable_notifications must be a boolean")
    end
    
    if type(config.enable_debugging) ~= "boolean" then
        error("enable_debugging must be a boolean")
    end
    
    if type(config.debug) ~= "boolean" then
        error("debug must be a boolean")
    end
    
    if type(config.log_level) ~= "number" then
        error("log_level must be a number")
    end
end

---Setup the configuration with validation
---@param opts? python.Config Configuration options
---@param deps? table Dependencies for testing
function M.setup(opts, deps)
    deps = deps or {}
    local notify = deps.notify or vim.notify
    local tbl_extend = deps.tbl_extend or vim.tbl_deep_extend
    
    local new_config = tbl_extend("force", default_config, opts or {})
    
    -- Validate configuration
    local ok, err = pcall(validate_config, new_config)
    if not ok then
        notify("Invalid python.nvim configuration: " .. tostring(err), vim.log.levels.ERROR, { title = "python.nvim" })
        return false
    end
    
    -- Update the module state
    for k, v in pairs(new_config) do
        M[k] = v
    end
    
    -- Log successful setup
    if M.debug then
        notify("python.nvim configuration loaded successfully", M.log_level, { title = "python.nvim" })
    end
    
    return true
end

---Get current configuration
---@param deps? table Dependencies for testing
---@return python.Config config
function M.get(deps)
    deps = deps or {}
    return M
end

---Toggle debug mode
---@param deps? table Dependencies for testing
function M.toggle_debug(deps)
    deps = deps or {}
    local notify = deps.notify or vim.notify
    
    M.debug = not M.debug
    notify(
        "python.nvim debug: " .. (M.debug and "enabled" or "disabled"), 
        M.log_level, 
        { title = "python.nvim" }
    )
end

---Reset configuration to defaults (useful for testing)
---@param deps? table Dependencies for testing
function M.reset(deps)
    deps = deps or {}
    local notify = deps.notify or vim.notify
    
    for k, v in pairs(default_config) do
        M[k] = v
    end
    
    if deps.debug then
        notify("Configuration reset to defaults", vim.log.levels.INFO, { title = "python.nvim" })
    end
end

---Create a new config instance (useful for testing)
---@param opts? python.Config Configuration options
---@param deps? table Dependencies for testing
---@return python.Config config
function M.new(opts, deps)
    deps = deps or {}
    local tbl_extend = deps.tbl_extend or vim.tbl_deep_extend
    
    local config = tbl_extend("force", default_config, opts or {})
    local ok, err = pcall(validate_config, config)
    if not ok then
        error("Invalid configuration: " .. tostring(err))
    end
    return config
end

---Check if a formatter is enabled
---@param formatter_name string Name of the formatter
---@param deps? table Dependencies for testing
---@return boolean enabled
function M.is_formatter_enabled(formatter_name, deps)
    deps = deps or {}
    if not M.formatters or not M.formatters[formatter_name] then
        return false
    end
    return M.formatters[formatter_name].enabled
end

---Check if a linter is enabled
---@param linter_name string Name of the linter
---@param deps? table Dependencies for testing
---@return boolean enabled
function M.is_linter_enabled(linter_name, deps)
    deps = deps or {}
    if not M.linters or not M.linters[linter_name] then
        return false
    end
    return M.linters[linter_name].enabled
end

---Check if a test framework is enabled
---@param framework_name string Name of the test framework
---@param deps? table Dependencies for testing
---@return boolean enabled
function M.is_test_framework_enabled(framework_name, deps)
    deps = deps or {}
    if not M.test_frameworks or not M.test_frameworks[framework_name] then
        return false
    end
    return M.test_frameworks[framework_name].enabled
end

---Get formatter settings
---@param formatter_name string Name of the formatter
---@param deps? table Dependencies for testing
---@return python.FormatterSettings? settings
function M.get_formatter_settings(formatter_name, deps)
    deps = deps or {}
    if not M.formatters or not M.formatters[formatter_name] then
        return nil
    end
    return M.formatters[formatter_name]
end

---Get linter settings
---@param linter_name string Name of the linter
---@param deps? table Dependencies for testing
---@return python.LinterSettings? settings
function M.get_linter_settings(linter_name, deps)
    deps = deps or {}
    if not M.linters or not M.linters[linter_name] then
        return nil
    end
    return M.linters[linter_name]
end

---Get test framework settings
---@param framework_name string Name of the test framework
---@param deps? table Dependencies for testing
---@return python.TestFrameworkSettings? settings
function M.get_test_framework_settings(framework_name, deps)
    deps = deps or {}
    if not M.test_frameworks or not M.test_frameworks[framework_name] then
        return nil
    end
    return M.test_frameworks[framework_name]
end

return M 