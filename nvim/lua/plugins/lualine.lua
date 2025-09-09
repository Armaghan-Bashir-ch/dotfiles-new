local mode_color = {
  n = "#A6E3A1",      -- normal mode
  i = "#89B4FA",      -- insert mode
  v = "#F38BA8",      -- visual mode
  [""] = "#F38BA8",  -- visual block
  V = "#F38BA8",      -- visual line
  c = "#FAB387",      -- command mode
  no = "#F9E2AF",     -- operator pending
  s = "#F5C2E7",      -- select mode
  S = "#F5C2E7",      -- select line
  ic = "#94E2D5",     -- insert completion
  R = "#F38BA8",      -- replace mode
  Rv = "#F38BA8",     -- virtual replace
  cv = "#FAB387",     -- ex mode
  ce = "#FAB387",     -- ex mode
  r = "#89DCEB",      -- hit-enter prompt
  rm = "#89DCEB",     -- more prompt
  ["r?"] = "#89DCEB", -- confirm prompt
  ["!"] = "#89DCEB",  -- shell
  t = "#94E2D5",      -- terminal
}
-- ~/.config/nvim/lua/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local theme = require "lualine.themes.auto" -- or "onedark", "gruvbox", etc.

    -- change normal mode section a colors
    theme.normal.a.bg = "#ff007c"
    theme.normal.a.fg = "#000000"
    theme.normal.a.gui = "bold"

    -- override theme
    opts.options.theme = theme
  end,
}
