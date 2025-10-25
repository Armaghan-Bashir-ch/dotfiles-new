-- Custom configuration for fff.nvim to make it look pretty/cool
-- Using Catppuccin Mocha color scheme for a sleek, modern look

-- Define custom highlight groups for a cool appearance with transparent backgrounds
vim.api.nvim_set_hl(0, 'FFFBorder', { fg = '#585b70', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'FFFNormal', { bg = 'NONE', fg = '#cdd6f4' })
vim.api.nvim_set_hl(0, 'FFFCursor', { bg = '#313244', fg = '#cdd6f4' })
vim.api.nvim_set_hl(0, 'FFFMatched', { fg = '#f38ba8', bold = true })
vim.api.nvim_set_hl(0, 'FFFTitle', { fg = '#89b4fa', bold = true })
vim.api.nvim_set_hl(0, 'FFFPrompt', { fg = '#f9e2af', bold = true })
vim.api.nvim_set_hl(0, 'FFFActiveFile', { bg = '#45475a', fg = '#cdd6f4' })
vim.api.nvim_set_hl(0, 'FFFFrecency', { fg = '#a6e3a1' })
vim.api.nvim_set_hl(0, 'FFFDebug', { fg = '#6c7086', italic = true })

return {
  prompt = '',
  title = 'FFFinder',
  max_results = 150,
  max_threads = 8,
  lazy_sync = true,
  layout = {
    height = 0.9,
    width = 0.9,
    prompt_position = 'bottom',
    preview_position = 'right',
    preview_size = 0.6,
  },
  preview = {
    enabled = true,
    max_size = 10 * 1024 * 1024,
    chunk_size = 8192,
    binary_file_threshold = 1024,
    imagemagick_info_format_str = '%m: %wx%h, %[colorspace], %q-bit',
    line_numbers = true,
    wrap_lines = false,
    show_file_info = true,
    filetypes = {
      svg = { wrap_lines = true },
      markdown = { wrap_lines = true },
      text = { wrap_lines = true },
    },
  },
  keymaps = {
    close = '<Esc>',
    select = '<CR>',
    select_split = '<C-s>',
    select_vsplit = '<C-v>',
    select_tab = '<C-t>',
    move_up = { '<Up>', '<C-p>', '<C-k>' },
    move_down = { '<Down>', '<C-n>', '<C-j>' },
    preview_scroll_up = '<C-u>',
    preview_scroll_down = '<C-d>',
    toggle_debug = '<F2>',
  },
  hl = {
    border = 'FFFBorder',
    normal = 'FFFNormal',
    cursor = 'FFFCursor',
    matched = 'FFFMatched',
    title = 'FFFTitle',
    prompt = 'FFFPrompt',
    active_file = 'FFFActiveFile',
    frecency = 'FFFFrecency',
    debug = 'FFFDebug',
  },
  frecency = {
    enabled = true,
    db_path = vim.fn.stdpath('cache') .. '/fff_nvim',
  },
  debug = {
    enabled = false,
    show_scores = false,
  },
  logging = {
    enabled = true,
    log_file = vim.fn.stdpath('log') .. '/fff.log',
    log_level = 'info',
  }
}