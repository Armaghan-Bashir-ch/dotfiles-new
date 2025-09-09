-- custom/options.lua

local opt = vim.opt

opt.updatetime = 200         -- Faster diagnostics / cursor responsiveness
opt.timeoutlen = 300         -- Shorter keymap timeout
opt.lazyredraw = true        -- Redraw only when needed
opt.swapfile = false         -- No swap files
opt.backup = false           -- No backups
opt.cursorlineopt = "number" -- Highlight only number in cursorline
