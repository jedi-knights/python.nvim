# python.nvim

A comprehensive Neovim plugin that provides quality-of-life functionality for Python development. Designed to work seamlessly with any Neovim distribution while providing powerful Python-specific features.

## ✨ Features

### 🐍 **Core Python Development**
- **Virtual Environment Management**: Auto-detect and manage Python virtual environments
- **Package Management**: Install, uninstall, and manage Python packages
- **Import Management**: Organize and clean up imports automatically
- **Code Formatting**: Integrated formatting with black, isort, and autopep8
- **Linting**: Real-time linting with flake8, pylint, and mypy

### 🧪 **Testing & Debugging**
- **Test Discovery**: Automatically find and run tests
- **Test Runner**: Execute tests with pytest, unittest, and nose
- **Debug Integration**: Seamless debugging with debugpy
- **Coverage**: View test coverage reports inline
- **Test Navigation**: Jump between test files and implementations

### 📦 **Project Management**
- **Project Detection**: Auto-detect Python projects and their structure
- **Dependency Management**: Manage requirements.txt, pyproject.toml, and setup.py
- **Environment Switching**: Switch between different Python environments
- **Project Templates**: Create new Python projects with templates

### 🔍 **Code Intelligence**
- **Symbol Navigation**: Navigate classes, functions, and imports
- **Refactoring**: Safe refactoring operations
- **Documentation**: Generate and view docstrings
- **Type Hints**: Enhanced type hint support and validation
- **Code Actions**: Quick fixes and code improvements

### 🛠 **Development Tools**
- **REPL Integration**: Interactive Python REPL in floating terminal
- **Jupyter Integration**: Run Jupyter notebooks and cells
- **Package Explorer**: Browse installed packages and their documentation
- **Environment Inspector**: Inspect current Python environment
- **Performance Profiling**: Profile Python code execution

## 📦 Requirements

- **Neovim >= 0.8**
- **Python 3.7+**
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** - Required for async operations
- **[snacks.nvim](https://github.com/folke/snacks.nvim)** - For interactive pickers (optional but recommended)

## 🚀 Installation

### Using [Lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "jedi-knights/python.nvim",
  dependencies = { 
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim", -- Optional but recommended
  },
  event = { "BufReadPre *.py", "BufNewFile *.py" },
  config = function()
    require("python").setup()
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
  "jedi-knights/python.nvim",
  requires = { 
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
  },
  config = function()
    require("python").setup()
  end,
})
```

## ⚙️ Configuration

### Basic Setup

```lua
require("python").setup({
  -- Core settings
  python_command = "python3",
  enable_virtual_env = true,
  auto_detect_venv = true,
  
  -- Formatting
  formatters = {
    black = { enabled = true, line_length = 88 },
    isort = { enabled = true, profile = "black" },
    autopep8 = { enabled = false },
  },
  
  -- Linting
  linters = {
    flake8 = { enabled = true },
    pylint = { enabled = false },
    mypy = { enabled = true },
  },
  
  -- Testing
  test_frameworks = {
    pytest = { enabled = true },
    unittest = { enabled = true },
    nose = { enabled = false },
  },
  
  -- UI
  enable_floating_terminals = true,
  enable_notifications = true,
  enable_debugging = true,
})
```

### Advanced Configuration

```lua
require("python").setup({
  -- Environment management
  environments = {
    default = "venv",
    auto_create = true,
    auto_activate = true,
    venv_path = ".venv",
  },
  
  -- Package management
  package_manager = "pip", -- or "poetry", "pipenv"
  auto_install_deps = true,
  
  -- Code intelligence
  enable_import_sorting = true,
  enable_auto_import = true,
  enable_type_checking = true,
  
  -- Testing
  test_coverage = {
    enabled = true,
    tool = "coverage", -- or "pytest-cov"
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
})
```

## 🎯 Usage

### Core Commands

| Command | Description |
|---------|-------------|
| `:PythonSetup` | Setup Python environment for current project |
| `:PythonVenv` | Manage virtual environments |
| `:PythonInstall` | Install Python packages |
| `:PythonFormat` | Format current buffer |
| `:PythonLint` | Lint current buffer |
| `:PythonTest` | Run tests |
| `:PythonDebug` | Start debugging session |
| `:PythonREPL` | Open Python REPL |

### Keymaps (Default)

| Keymap | Description |
|--------|-------------|
| `<leader>pv` | Open virtual environment picker |
| `<leader>pi` | Install package |
| `<leader>pu` | Uninstall package |
| `<leader>pf` | Format buffer |
| `<leader>pl` | Lint buffer |
| `<leader>pt` | Run tests |
| `<leader>pd` | Start debugging |
| `<leader>pr` | Open REPL |

### Interactive Pickers

- **Environment Picker**: `:PythonVenvPicker` - Switch between Python environments
- **Package Picker**: `:PythonPackagePicker` - Browse and manage packages
- **Test Picker**: `:PythonTestPicker` - Discover and run tests
- **Import Picker**: `:PythonImportPicker` - Organize imports

## 🏗️ Architecture

```
python.nvim/
├── lua/python/
│   ├── init.lua              # Main plugin entry point
│   ├── config.lua            # Configuration management
│   ├── types.lua             # Type definitions
│   ├── detector.lua          # Project and environment detection
│   ├── commands.lua          # User commands
│   ├── ui.lua               # UI components and pickers
│   ├── runner.lua           # Code execution and testing
│   ├── formatter.lua        # Code formatting
│   ├── linter.lua           # Code linting
│   ├── debugger.lua         # Debugging integration
│   ├── repl.lua             # REPL management
│   ├── package.lua          # Package management
│   ├── venv.lua             # Virtual environment management
│   ├── imports.lua          # Import management
│   ├── coverage.lua         # Test coverage
│   └── utils.lua            # Utility functions
├── plugin/python.lua        # Plugin bootstrap
└── README.md               # This file
```

## 🔧 Development

### Adding New Features

1. **Follow DRY principles**: Extract common functionality into reusable modules
2. **Use dependency injection**: Make functions testable with `deps` parameter
3. **Implement proper error handling**: Use `pcall` and provide helpful error messages
4. **Add comprehensive documentation**: Document all public APIs
5. **Write tests**: Include unit tests for new functionality

### Testing

```bash
# Run tests
nvim --headless -c "lua require('plenary.test_harness').test_directory('tests', { minimal_init = 'tests/minimal_init.lua' })"
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the established code patterns
4. Add tests for new functionality
5. Update documentation
6. Submit a pull request

## 📄 License

This project is licensed under the [MIT License](LICENSE).

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

---

**Made with ❤️ for the Python and Neovim communities** 