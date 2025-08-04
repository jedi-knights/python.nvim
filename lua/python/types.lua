---@class python.Config
---@field python_command string Python command to use (default: "python3")
---@field enable_virtual_env boolean Enable virtual environment support (default: true)
---@field auto_detect_venv boolean Auto-detect virtual environments (default: true)
---@field formatters python.FormatterConfig Configuration for code formatters
---@field linters python.LinterConfig Configuration for code linters
---@field test_frameworks python.TestFrameworkConfig Configuration for test frameworks
---@field environments python.EnvironmentConfig Configuration for environment management
---@field package_manager string Package manager to use (default: "pip")
---@field auto_install_deps boolean Auto-install dependencies (default: true)
---@field enable_import_sorting boolean Enable import sorting (default: true)
---@field enable_auto_import boolean Enable auto-import (default: true)
---@field enable_type_checking boolean Enable type checking (default: true)
---@field test_coverage python.CoverageConfig Configuration for test coverage
---@field debugger python.DebuggerConfig Configuration for debugging
---@field repl python.REPLConfig Configuration for REPL
---@field enable_floating_terminals boolean Enable floating terminals (default: true)
---@field enable_notifications boolean Enable notifications (default: true)
---@field enable_debugging boolean Enable debugging features (default: true)
---@field debug boolean Enable debug mode (default: false)
---@field log_level number Log verbosity level (default: vim.log.levels.INFO)

---@class python.FormatterConfig
---@field black python.FormatterSettings Black formatter settings
---@field isort python.FormatterSettings isort formatter settings
---@field autopep8 python.FormatterSettings autopep8 formatter settings

---@class python.FormatterSettings
---@field enabled boolean Whether the formatter is enabled (default: true)
---@field line_length? number Line length for formatting (default: 88)
---@field profile? string Profile to use (e.g., "black" for isort)

---@class python.LinterConfig
---@field flake8 python.LinterSettings Flake8 linter settings
---@field pylint python.LinterSettings Pylint linter settings
---@field mypy python.LinterSettings MyPy linter settings

---@class python.LinterSettings
---@field enabled boolean Whether the linter is enabled (default: true)
---@field config_file? string Path to configuration file
---@field args? string[] Additional arguments

---@class python.TestFrameworkConfig
---@field pytest python.TestFrameworkSettings Pytest settings
---@field unittest python.TestFrameworkSettings Unittest settings
---@field nose python.TestFrameworkSettings Nose settings

---@class python.TestFrameworkSettings
---@field enabled boolean Whether the test framework is enabled (default: true)
---@field config_file? string Path to configuration file
---@field args? string[] Additional arguments

---@class python.EnvironmentConfig
---@field default string Default environment type (default: "venv")
---@field auto_create boolean Auto-create environments (default: true)
---@field auto_activate boolean Auto-activate environments (default: true)
---@field venv_path string Virtual environment path (default: ".venv")

---@class python.CoverageConfig
---@field enabled boolean Enable coverage reporting (default: true)
---@field tool string Coverage tool to use (default: "coverage")
---@field show_inline boolean Show inline coverage (default: true)

---@class python.DebuggerConfig
---@field enabled boolean Enable debugging (default: true)
---@field adapter string Debug adapter to use (default: "debugpy")
---@field port number Debug port (default: 5678)

---@class python.REPLConfig
---@field enabled boolean Enable REPL (default: true)
---@field floating boolean Use floating terminal (default: true)
---@field auto_import boolean Auto-import from current file (default: true)

---@class python.VirtualEnvironment
---@field path string Path to the virtual environment
---@field python_path string Path to Python executable
---@field name string Name of the environment
---@field type string Type of environment (venv, conda, etc.)
---@field active boolean Whether the environment is active

---@class python.Package
---@field name string Package name
---@field version string Package version
---@field description? string Package description
---@field location? string Package location

---@class python.TestResult
---@field name string Test name
---@field status string Test status (passed, failed, skipped)
---@field duration number Test duration in seconds
---@field output string Test output
---@field error? string Test error message

---@class python.ImportItem
---@field module string Module name
---@field name string Import name
---@field alias? string Import alias
---@field line number Line number in file

---@class python.FormatterResult
---@field success boolean Whether formatting was successful
---@field output string Formatted output
---@field error? string Error message

---@class python.LinterResult
---@field success boolean Whether linting was successful
---@field issues python.LintIssue[] Linting issues found
---@field error? string Error message

---@class python.LintIssue
---@field line number Line number
---@field column number Column number
---@field message string Issue message
---@field severity string Issue severity (error, warning, info)
---@field code string Issue code

---@class python.PickerItem
---@field value any The item value
---@field display string Formatted display string
---@field ordinal string Searchable text for fuzzy matching
---@field description? string Item description

---@class python.RunnerOptions
---@field cwd? string Working directory (default: current directory)
---@field env? table Environment variables
---@field on_exit? fun(code: number) Callback when process exits
---@field on_stdout? fun(line: string) Callback for stdout lines
---@field on_stderr? fun(line: string) Callback for stderr lines
---@field timeout? number Timeout in seconds

return {} 