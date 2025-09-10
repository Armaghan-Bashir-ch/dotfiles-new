require("noice").setup({
    cmdline = {
        enabled = true,   -- keep cmdline features
        view = "cmdline_popup", -- use floating popup instead of bottom bar
        format = {},      -- optional: no formatting to interfere
    },
    views = {
        cmdline_popup = {
            position = { row = 5, col = "50%" },
            size = { width = 300, height = "auto" },
            border = { style = "rounded" },
            win_options = {
                winhighlight = { Normal = "NormalFloat", FloatBorder = "FloatBorder" },
            },
        },
    },
    presets = {
        bottom_search = false, -- disables bottom search bar
        command_palette = false, -- disables bottom command palette
    },
})
