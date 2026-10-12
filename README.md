# python.nvim

A comprehensive Neovim plugin that provides quality-of-life functionality for Python development. Designed to work seamlessly with any Neovim distribution while providing powerful Python-specific features.

## Overview

If you work in Python inside Neovim, you probably already have pyright or pylsp running, ruff or black on save, and pytest in a terminal split. The parts in between — switching virtual environments, remembering the right linter invocation, re-running tests, organizing imports — still send you out to the terminal and break the flow.

`python.nvim` closes that gap. It wraps the day-to-day Python toolchain behind a consistent `:Python*` command surface, auto-detects your project's virtual environment, surfaces interactive pickers for environments, packages, tests, and imports, and gives you `:PythonInfo` for a one-shot diagnostic view of what the plugin thinks about your current project. One keymap namespace (`<leader>p…`), one mental model, no leaving the editor.

## Features

### Core Python Development
- **Virtual Environment Management**: Auto-detect and manage Python virtual environments
- **Package Management**: Install, uninstall, and manage Python packages
- **Import Management**: Organize and clean up imports automatically
- **Code Formatting**: Integrated formatting with black, isort, and autopep8
- **Linting**: Real-time linting with flake8, pylint, and mypy

### Testing & Debugging
- **Test Discovery**: Automatically find and run tests
- **Test Runner**: Execute tests with pytest, unittest, and nose
- **Debug Integration**: Seamless debugging with debugpy
- **Test Navigation**: Jump between test files and implementations

### Project Management
- **Project Detection**: Auto-detect Python projects and their structure
- **Dependency Management**: Manage requirements.txt, pyproject.toml, and setup.py
- **Environment Switching**: Switch between different Python environments

### Code Intelligence
- **Symbol Navigation**: Navigate classes, functions, and imports
- **Documentation**: Generate and view docstrings
- **Type Hints**: Enhanced type hint support and validation

### Development Tools
- **REPL Integration**: Interactive Python REPL in floating terminal
- **Package Explorer**: Browse installed packages
- **Environment Inspector**: Inspect current Python environment via `:PythonInfo`

## Requirements

- **Neovim >= 0.8** (the native `vim.pack` install block below additionally requires **Neovim >= 0.12**; the lazy.nvim and packer blocks work on 0.8+)
- **Python 3.7+**
- **[snacks.nvim](https://github.com/folke/snacks.nvim)** — required by the interactive pickers (`:PythonVenvPicker`, `:PythonPackagePicker`, `:PythonTestPicker`, `:PythonImportPicker`). Non-picker commands (`:PythonFormat`, `:PythonLint`, `:PythonTest`, `:PythonDebug`, `:PythonREPL`, etc.) work without it.
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** — only required to run the plugin's own test suite via `plenary.test_harness`. End users do not need it.

## Installation

### Using [Lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "jedi-knights/python.nvim",
  dependencies = {
    "folke/snacks.nvim", -- required for interactive pickers
  },
  event = { "BufReadPre *.py", "BufNewFile *.py" },
  config = function()
    require("python").setup()
  end,
}
```

### Using native `vim.pack` (Neovim >= 0.12)

`vim.pack.add` does not run `setup()` for you — the follow-up call is explicit.
Dependencies also need to be added separately.

```lua
vim.pack.add({
  { src = "https://github.com/folke/snacks.nvim" }, -- required for interactive pickers
  { src = "https://github.com/jedi-knights/python.nvim" },
})

require("python").setup()
```

Pin to a tag or branch with `version = "..."`. `vim.pack.add` is idempotent — it clones on first run and does nothing on subsequent runs. To pull new upstream commits across every added source later, run `:lua vim.pack.update()`.

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
  "jedi-knights/python.nvim",
  requires = {
    "folke/snacks.nvim",
  },
  config = function()
    require("python").setup()
  end,
})
```

## Configuration

### Required vs. optional

`setup()` is **optional**. Calling `require("python").setup()` with no arguments is equivalent to accepting every default below — every key in the config table is optional and merged over the defaults, so only pass what you want to change.

The plugin's user commands (`:PythonFormat`, `:PythonTest`, etc.) are registered at startup from `plugin/python.lua` and do **not** require `setup()` to be called. The main thing `setup()` does is let you override defaults such as formatter/linter selection, venv path, debugger adapter, and REPL behavior.

### Feature → dependency map

| Feature | Depends on |
|---|---|
| Interactive pickers (`:PythonVenvPicker`, `:PythonPackagePicker`, `:PythonTestPicker`, `:PythonImportPicker`) | `snacks.nvim` |
| Formatting (`:PythonFormat`) | `black`, `isort`, or `autopep8` on `$PATH` |
| Linting (`:PythonLint`) | `flake8`, `pylint`, or `mypy` on `$PATH` |
| Testing (`:PythonTest`) | `pytest`, `unittest`, or `nose` installed in the active env |
| Debugging (`:PythonDebug`, `:PythonToggleDebug`) | `debugpy` installed in the active env |
| Running the plugin's own test suite | `plenary.nvim` |

### Basic setup

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

### Advanced configuration

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

## Usage

### Commands

Every `:Python*` user command registered by `plugin/python.lua`, grouped by category.

#### Environment & setup

| Command | Description |
|---------|-------------|
| `:PythonSetup` | Setup Python environment for current project |
| `:PythonVenv` | Manage virtual environments |
| `:PythonVenvPicker` | Show virtual-environment picker |
| `:PythonInfo` | Show diagnostic report (config, project, Python path, venv) |

#### Packages & imports

| Command | Description |
|---------|-------------|
| `:PythonInstall` | Install a Python package (prompts for name) |
| `:PythonUninstall` | Uninstall a Python package (prompts for name) |
| `:PythonPackagePicker` | Browse and manage installed packages |
| `:PythonOrganizeImports` | Organize imports in the current buffer |
| `:PythonImportPicker` | Interactive import picker |

#### Formatting & linting

| Command | Description |
|---------|-------------|
| `:PythonFormat` | Format the current buffer |
| `:PythonLint` | Lint the current buffer |

#### Testing

| Command | Description |
|---------|-------------|
| `:PythonTest` | Run tests |
| `:PythonTestPicker` | Discover and run tests interactively |

#### Debugging & REPL

| Command | Description |
|---------|-------------|
| `:PythonDebug` | Start debugging session |
| `:PythonToggleDebug` | Toggle debug mode |
| `:PythonREPL` | Open Python REPL in a floating terminal |

### Keymaps (default)

Registered only when `vim.g.mapleader` is set, by `plugin/python.lua`.

| Keymap | Command |
|--------|---------|
| `<leader>pv` | `:PythonVenvPicker` |
| `<leader>pi` | `:PythonInstall` |
| `<leader>pu` | `:PythonUninstall` |
| `<leader>pp` | `:PythonPackagePicker` |
| `<leader>pm` | `:PythonImportPicker` |
| `<leader>po` | `:PythonOrganizeImports` |
| `<leader>pf` | `:PythonFormat` |
| `<leader>pl` | `:PythonLint` |
| `<leader>pt` | `:PythonTest` |
| `<leader>ptp` | `:PythonTestPicker` |
| `<leader>pd` | `:PythonDebug` |
| `<leader>pr` | `:PythonREPL` |
| `<leader>p?` | `:PythonInfo` |

If you prefer different bindings, remap on top of these — none of them are set when `mapleader` is unset.

### Interactive pickers

All pickers require `snacks.nvim`.

- **`:PythonVenvPicker`** — switch between Python environments
- **`:PythonPackagePicker`** — browse and manage packages
- **`:PythonTestPicker`** — discover and run tests
- **`:PythonImportPicker`** — organize imports

## Architecture

Modules under `lua/python/`, grouped by concern.

```
python.nvim/
├── lua/python/
│   │   # Core
│   ├── init.lua              # Main plugin entry point (public API)
│   ├── config.lua            # Configuration management + defaults
│   ├── types.lua             # Type definitions (LuaCATS)
│   ├── utils.lua             # Shared utility helpers
│   │
│   │   # Environment detection
│   └── detector.lua          # Project / Python / venv detection
│
├── plugin/python.lua         # Plugin bootstrap: user commands + keymaps
└── README.md                 # This file
```

Non-core concerns (formatters, linters, pickers, debugger, REPL, pytest, task runner) are composed through `plugin/python.lua` and additional modules landing in future releases.

## Development

### Adding new features

1. **Follow DRY principles**: Extract common functionality into reusable modules
2. **Use dependency injection**: Make functions testable with `deps` parameter
3. **Implement proper error handling**: Use `pcall` and provide helpful error messages
4. **Add comprehensive documentation**: Document all public APIs
5. **Write tests**: Include unit tests for new functionality

### Testing

```bash
nvim --headless -c "lua require('plenary.test_harness').test_directory('tests', { minimal_init = 'tests/minimal_init.lua' })"
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the established code patterns
4. Add tests for new functionality
5. Update documentation
6. Submit a pull request

## License

This project is licensed under the [MIT License](LICENSE).

## Contributing

See [Contributing Guide](CONTRIBUTING.md) for details.
