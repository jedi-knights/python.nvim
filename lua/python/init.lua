-- lua/python/init.lua
-- Main entry point for python.nvim plugin

local M = {}

---Setup the plugin with configuration
---@param opts? python.Config Configuration options
---@param deps? table Dependencies for testing
function M.setup(opts, deps)
    deps = deps or {}
    local config = deps.config or require("python.config")
    config.setup(opts, deps)
end

---Get the current configuration
---@param deps? table Dependencies for testing
---@return python.Config config
function M.get_config(deps)
    deps = deps or {}
    local config = deps.config or require("python.config")
    return config.get(deps)
end

---Check if we should load the plugin
---@param deps? table Dependencies for testing
---@return boolean should_load
function M.should_load(deps)
    deps = deps or {}
    local detector = deps.detector or require("python.detector")
    return detector.should_load(deps)
end

---Get project information
---@param deps? table Dependencies for testing
---@return table project_info
function M.get_project_info(deps)
    deps = deps or {}
    local detector = deps.detector or require("python.detector")
    return detector.get_project_info(deps)
end

---Setup Python environment for current project
---@param deps? table Dependencies for testing
function M.setup_environment(deps)
    deps = deps or {}
    local venv = deps.venv or require("python.venv")
    venv.setup_environment(deps)
end

---Format current buffer
---@param deps? table Dependencies for testing
function M.format_buffer(deps)
    deps = deps or {}
    local formatter = deps.formatter or require("python.formatter")
    formatter.format_buffer(deps)
end

---Lint current buffer
---@param deps? table Dependencies for testing
function M.lint_buffer(deps)
    deps = deps or {}
    local linter = deps.linter or require("python.linter")
    linter.lint_buffer(deps)
end

---Run tests
---@param deps? table Dependencies for testing
function M.run_tests(deps)
    deps = deps or {}
    local runner = deps.runner or require("python.runner")
    runner.run_tests(deps)
end

---Start debugging session
---@param deps? table Dependencies for testing
function M.start_debugging(deps)
    deps = deps or {}
    local debugger = deps.debugger or require("python.debugger")
    debugger.start_session(deps)
end

---Open Python REPL
---@param deps? table Dependencies for testing
function M.open_repl(deps)
    deps = deps or {}
    local repl = deps.repl or require("python.repl")
    repl.open(deps)
end

---Install Python package
---@param package_name string Name of the package to install
---@param deps? table Dependencies for testing
function M.install_package(package_name, deps)
    deps = deps or {}
    local package = deps.package or require("python.package")
    package.install(package_name, deps)
end

---Uninstall Python package
---@param package_name string Name of the package to uninstall
---@param deps? table Dependencies for testing
function M.uninstall_package(package_name, deps)
    deps = deps or {}
    local package = deps.package or require("python.package")
    package.uninstall(package_name, deps)
end

---Organize imports in current buffer
---@param deps? table Dependencies for testing
function M.organize_imports(deps)
    deps = deps or {}
    local imports = deps.imports or require("python.imports")
    imports.organize(deps)
end

---Show virtual environment picker
---@param deps? table Dependencies for testing
function M.show_venv_picker(deps)
    deps = deps or {}
    local ui = deps.ui or require("python.ui")
    ui.show_venv_picker(deps)
end

---Show package picker
---@param deps? table Dependencies for testing
function M.show_package_picker(deps)
    deps = deps or {}
    local ui = deps.ui or require("python.ui")
    ui.show_package_picker(deps)
end

---Show test picker
---@param deps? table Dependencies for testing
function M.show_test_picker(deps)
    deps = deps or {}
    local ui = deps.ui or require("python.ui")
    ui.show_test_picker(deps)
end

---Show import picker
---@param deps? table Dependencies for testing
function M.show_import_picker(deps)
    deps = deps or {}
    local ui = deps.ui or require("python.ui")
    ui.show_import_picker(deps)
end

---Toggle debug mode
---@param deps? table Dependencies for testing
function M.toggle_debug(deps)
    deps = deps or {}
    local config = deps.config or require("python.config")
    config.toggle_debug(deps)
end

---Get Python executable path
---@param deps? table Dependencies for testing
---@return string? python_path
function M.get_python_path(deps)
    deps = deps or {}
    local detector = deps.detector or require("python.detector")
    return detector.get_python_path(deps)
end

---Get virtual environment information
---@param deps? table Dependencies for testing
---@return python.VirtualEnvironment? venv_info
function M.get_venv_info(deps)
    deps = deps or {}
    local venv = deps.venv or require("python.venv")
    return venv.get_current_venv(deps)
end

---Get installed packages
---@param callback fun(packages: python.Package[])
---@param deps? table Dependencies for testing
function M.get_installed_packages(callback, deps)
    deps = deps or {}
    local package = deps.package or require("python.package")
    package.get_installed_packages(callback, deps)
end

---Get test results
---@param callback fun(results: python.TestResult[])
---@param deps? table Dependencies for testing
function M.get_test_results(callback, deps)
    deps = deps or {}
    local runner = deps.runner or require("python.runner")
    runner.get_test_results(callback, deps)
end

---Get import items from current buffer
---@param deps? table Dependencies for testing
---@return python.ImportItem[] imports
function M.get_imports(deps)
    deps = deps or {}
    local imports = deps.imports or require("python.imports")
    return imports.get_imports(deps)
end

---Format code with specific formatter
---@param formatter_name string Name of the formatter
---@param code string Code to format
---@param deps? table Dependencies for testing
---@return python.FormatterResult result
function M.format_code(formatter_name, code, deps)
    deps = deps or {}
    local formatter = deps.formatter or require("python.formatter")
    return formatter.format_code(formatter_name, code, deps)
end

---Lint code with specific linter
---@param linter_name string Name of the linter
---@param code string Code to lint
---@param deps? table Dependencies for testing
---@return python.LinterResult result
function M.lint_code(linter_name, code, deps)
    deps = deps or {}
    local linter = deps.linter or require("python.linter")
    return linter.lint_code(linter_name, code, deps)
end

---Run specific test
---@param test_name string Name of the test to run
---@param deps? table Dependencies for testing
---@return python.TestResult result
function M.run_test(test_name, deps)
    deps = deps or {}
    local runner = deps.runner or require("python.runner")
    return runner.run_test(test_name, deps)
end

---Execute Python code
---@param code string Python code to execute
---@param opts? python.RunnerOptions Execution options
---@param deps? table Dependencies for testing
---@return string? output
function M.execute_code(code, opts, deps)
    deps = deps or {}
    local runner = deps.runner or require("python.runner")
    return runner.execute_code(code, opts, deps)
end

return M 