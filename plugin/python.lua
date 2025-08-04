-- plugin/python.lua
-- Plugin bootstrap for python.nvim

-- Create user commands
vim.api.nvim_create_user_command("PythonSetup", function()
    require("python").setup_environment()
end, { desc = "Setup Python environment for current project" })

vim.api.nvim_create_user_command("PythonVenv", function()
    require("python").show_venv_picker()
end, { desc = "Manage virtual environments" })

vim.api.nvim_create_user_command("PythonInstall", function()
    local package_name = vim.fn.input("Package name: ")
    if package_name and package_name ~= "" then
        require("python").install_package(package_name)
    end
end, { desc = "Install Python package" })

vim.api.nvim_create_user_command("PythonUninstall", function()
    local package_name = vim.fn.input("Package name: ")
    if package_name and package_name ~= "" then
        require("python").uninstall_package(package_name)
    end
end, { desc = "Uninstall Python package" })

vim.api.nvim_create_user_command("PythonFormat", function()
    require("python").format_buffer()
end, { desc = "Format current buffer" })

vim.api.nvim_create_user_command("PythonLint", function()
    require("python").lint_buffer()
end, { desc = "Lint current buffer" })

vim.api.nvim_create_user_command("PythonTest", function()
    require("python").run_tests()
end, { desc = "Run tests" })

vim.api.nvim_create_user_command("PythonDebug", function()
    require("python").start_debugging()
end, { desc = "Start debugging session" })

vim.api.nvim_create_user_command("PythonREPL", function()
    require("python").open_repl()
end, { desc = "Open Python REPL" })

vim.api.nvim_create_user_command("PythonOrganizeImports", function()
    require("python").organize_imports()
end, { desc = "Organize imports in current buffer" })

vim.api.nvim_create_user_command("PythonVenvPicker", function()
    require("python").show_venv_picker()
end, { desc = "Show virtual environment picker" })

vim.api.nvim_create_user_command("PythonPackagePicker", function()
    require("python").show_package_picker()
end, { desc = "Show package picker" })

vim.api.nvim_create_user_command("PythonTestPicker", function()
    require("python").show_test_picker()
end, { desc = "Show test picker" })

vim.api.nvim_create_user_command("PythonImportPicker", function()
    require("python").show_import_picker()
end, { desc = "Show import picker" })

vim.api.nvim_create_user_command("PythonToggleDebug", function()
    require("python").toggle_debug()
end, { desc = "Toggle debug mode" })

vim.api.nvim_create_user_command("PythonInfo", function()
    local config = require("python").get_config()
    local detector = require("python.detector")
    local project_info = detector.get_project_info()
    local python_path = detector.get_python_path()
    local python_version = detector.get_python_version()
    local venv_info = require("python").get_venv_info()
    
    local info = {
        "Python.nvim Information:",
        "",
        "Configuration:",
        "  Python command: " .. (config.python_command or "python3"),
        "  Virtual env enabled: " .. tostring(config.enable_virtual_env),
        "  Auto detect venv: " .. tostring(config.auto_detect_venv),
        "",
        "Project:",
        "  Root: " .. (project_info.root or "unknown"),
        "  Is Python project: " .. tostring(project_info.is_python_project),
        "  Has requirements.txt: " .. tostring(project_info.has_requirements),
        "  Has pyproject.toml: " .. tostring(project_info.has_pyproject),
        "  Has setup.py: " .. tostring(project_info.has_setup_py),
        "  Has virtual env: " .. tostring(project_info.has_venv),
        "",
        "Python:",
        "  Path: " .. (python_path or "not found"),
        "  Version: " .. (python_version or "unknown"),
        "  Available: " .. tostring(detector.is_python_available()),
    }
    
    if venv_info then
        table.insert(info, "")
        table.insert(info, "Virtual Environment:")
        table.insert(info, "  Path: " .. venv_info.path)
        table.insert(info, "  Python path: " .. venv_info.python_path)
        table.insert(info, "  Name: " .. venv_info.name)
        table.insert(info, "  Type: " .. venv_info.type)
        table.insert(info, "  Active: " .. tostring(venv_info.active))
    end
    
    vim.notify(table.concat(info, "\n"), vim.log.levels.INFO, { title = "Python.nvim Info" })
end, { desc = "Show Python.nvim information" })

-- Set up keymaps if leader is defined
if vim.g.mapleader then
    local keymap_opts = { noremap = true, silent = true }
    
    -- Virtual environment management
    vim.keymap.set("n", "<leader>pv", "<cmd>PythonVenvPicker<cr>", keymap_opts)
    
    -- Package management
    vim.keymap.set("n", "<leader>pi", "<cmd>PythonInstall<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>pu", "<cmd>PythonUninstall<cr>", keymap_opts)
    
    -- Code formatting and linting
    vim.keymap.set("n", "<leader>pf", "<cmd>PythonFormat<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>pl", "<cmd>PythonLint<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>po", "<cmd>PythonOrganizeImports<cr>", keymap_opts)
    
    -- Testing
    vim.keymap.set("n", "<leader>pt", "<cmd>PythonTest<cr>", keymap_opts)
    vim.keymap.set("n", "<leader>ptp", "<cmd>PythonTestPicker<cr>", keymap_opts)
    
    -- Debugging
    vim.keymap.set("n", "<leader>pd", "<cmd>PythonDebug<cr>", keymap_opts)
    
    -- REPL
    vim.keymap.set("n", "<leader>pr", "<cmd>PythonREPL<cr>", keymap_opts)
    
    -- Package picker
    vim.keymap.set("n", "<leader>pp", "<cmd>PythonPackagePicker<cr>", keymap_opts)
    
    -- Import picker
    vim.keymap.set("n", "<leader>pi", "<cmd>PythonImportPicker<cr>", keymap_opts)
    
    -- Information
    vim.keymap.set("n", "<leader>p?", "<cmd>PythonInfo<cr>", keymap_opts)
end

-- Auto-setup for Python files
vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = "*.py",
    callback = function()
        -- Check if we should load the plugin
        if require("python").should_load() then
            -- Auto-setup environment if enabled
            local config = require("python").get_config()
            if config.environments and config.environments.auto_activate then
                require("python").setup_environment()
            end
        end
    end,
})

-- Auto-format on save if enabled
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        local config = require("python").get_config()
        if config.formatters and config.formatters.black and config.formatters.black.enabled then
            require("python").format_buffer()
        end
    end,
}) 