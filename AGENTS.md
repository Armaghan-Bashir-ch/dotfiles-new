# AGENTS.md - Coding Agent Guidelines

## Build/Lint/Test Commands

This is a dotfiles repository - no traditional build process exists. Linting and formatting are handled through Neovim plugins:

- **Lint single file**: `<leader>ln` in Neovim (triggers nvim-lint)
- **Format code**: Automatic on save via null-ls formatters
- **Available linters/formatters**:
  - Lua: stylua
  - Python: black, mypy, pylint
  - JavaScript/TypeScript: eslint_d
  - Go: gofumpt, goimports_reviser, golines
  - C/C++: clang-format
  - SQL: sqlfmt

## Code Style Guidelines

### Lua (Neovim Configuration)
- **Indentation**: 4 spaces (vim.opt.tabstop = 4, vim.opt.shiftwidth = 4)
- **Naming**: descriptive variable names, camelCase for functions, UPPER_CASE for constants
- **Comments**: Extensive inline comments explaining complex logic
- **Structure**: Group related functionality, use local variables for scoping
- **Error handling**: Use pcall for potentially failing operations
- **Imports**: Require modules at top, use local aliases for frequently used modules

### Bash Scripts
- **Shebang**: Always `#!/bin/bash`
- **Error handling**: Check command success with `if` statements, use `notify-send` for user feedback
- **Variables**: UPPER_CASE for global constants, descriptive names
- **Comments**: Inline comments for complex logic
- **Safety**: Use proper quoting, validate inputs before processing

### General Guidelines
- **Minimalism**: Keep code as minimal as possible while maintaining quality
- **Focus**: One task at a time, avoid side quests
- **Careful changes**: Test changes that affect other configurations
- **Research**: Consult documentation before implementing new features
- **Comments**: Use comments for complex changes, ask before adding comments to existing code
- **File structure**: Related files in same directories, consistent naming

### Directory-Specific Rules
- **hypr/**: Ask before modifying hyprland.conf or hyprlock.conf
- **nvim/custom/**: Ask before adding code directly to files
- **ghostty/**: Ask before modifying configuration
- **scripts/**: Place tool-specific scripts in respective directories

### Neovim-Specific
- **Main files**: Focus on `init.lua`, `plugins.lua`, `mappings.lua`, `chadrc.lua`
- **Plugins**: Use lazy.nvim format with proper event/cmd triggers
- **Mappings**: Load via core.utils.load_mappings()
- **Big files**: Respect vim.g.customBigFileOpt for performance optimizations
