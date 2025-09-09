return {
    "folke/noice.nvim",
    opts = {
        lsp = {
            progress = {
                enabled = false,
            },
        },
        presets = {
            bottom_search = false,
            command_palette = false,
            long_message_to_split = true,
        },
        cmdline = {
            view = "cmdline_popup", -- 👈 force popup instead of bottom bar
        },
        views = {
            cmdline_popup = {
                position = {
                    row = 5,
                    col = "50%",
                },
                size = {
                    width = 300,
                    height = "auto",
                },
                border = {
                    style = "rounded",
                },
                win_options = {
                    winhighlight = {
                        Normal = "NormalFloat",
                        FloatBorder = "FloatBorder",
                    },
                },
            },
            popupmenu = {
                relative = "editor",
                position = {
                    row = 8,
                    col = "50%",
                },
                size = {
                    width = 60,
                    height = 10,
                },
                border = {
                    style = "rounded",
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = {
                        Normal = "NormalFloat",
                        FloatBorder = "FloatBorder",
                    },
                },
            },
        },
        routes = {
            {
                filter = {
                    event = "msg_showmode",
                },
                view = "notify",
                opts = {
                    title = "Mode",
                    timeout = 1000,
                },
            },
        },
    },
}
