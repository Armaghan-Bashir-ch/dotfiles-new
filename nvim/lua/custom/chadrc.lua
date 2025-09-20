require("custom.init")

---@type ChadrcConfig
local M = {}

M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")

--TODO: Is this needed?

M.ui = {
    theme = "tokyonight",
    transparency = true,

    statusline = {
        theme = "default",
        separator_style = "round",
        overriden_modules = nil,
    },

    --NOTE: Custamizes the statusline

    tabufline = {
        enabled = false, -- disable NvChad's tab thingi at the top
    },

    --NOTE: Hides the file tabs at the top
}

return M
