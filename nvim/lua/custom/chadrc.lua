require("custom.init")

---@type ChadrcConfig
local M = {}

M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")

--TODO: Is this needed?

--NOTE: Custamizes the statusline

M.ui = {
    theme = "tokyonight",
    transparency = false,

    statusline = {
        theme = "default",
        separator_style = "default",
        overriden_modules = nil,
    },
    tabufline = {
        enabled = false, -- disable NvChad's tab thingi at the top
    },

    --NOTE: Hides the file tabs at the top
}

local custom_ui = require("custom.ui")
M.ui.statusline.overriden_modules = custom_ui.statusline.overriden_modules
M.ui.tabufline = custom_ui.tabufline

return M
