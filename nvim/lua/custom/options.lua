-- custom/options.lua

local opt = vim.opt

opt.updatetime = 200         -- Faster diagnostics / cursor responsiveness
opt.timeout = false          -- Disable timeout for mappings
opt.ttimeoutlen = 0          -- No delay for key codes
opt.timeoutlen = 100         -- Shorter keymap timeout (for when timeout is true)
opt.lazyredraw = true        -- Redraw only when needed
opt.swapfile = false         -- No swap files
opt.backup = false           -- No backups
opt.cursorlineopt = "number" -- Highlight only number in cursorline
