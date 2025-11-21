# AGENTS.md - Coding Agent Guidelines

## Build/Lint/Test Commands
This is a dotfiles repository - no traditional build process exists.
- **Lint single file**: `<leader>ln` in Neovim (triggers nvim-lint)
- **Format code**: Automatic on save via null-ls formatters
- **Available linters**: Lua (stylua), Python (black/mypy/pylint), JS/TS (eslint_d), Go (gofumpt), C/C++ (clang-format), SQL (sqlfmt)

## Code Style Guidelines
- **Lua**: 4-space indentation, camelCase functions, UPPER_CASE constants, pcall for error handling, require modules at top
- **Bash**: `#!/bin/bash`, UPPER_CASE globals, `if` checks with notify-send feedback, proper quoting, input validation
- **General**: Minimal code, descriptive names, local scoping, extensive comments for complex logic
- **Neovim**: Focus on init.lua/plugins.lua/mappings.lua/chadrc.lua, lazy.nvim format, load_mappings() for keybinds
- **Directory rules**: Ask before modifying hypr/hyprland.conf, nvim/custom/ files, or ghostty/ config
