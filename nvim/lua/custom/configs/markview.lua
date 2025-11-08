local config = {
    enable = true,

    block_quotes = {
        enable = true,
        wrap = true,
        default = {
            border = "▋",
            hl = "MarkviewBlockQuoteDefault",
        },
        ["NOTE"] = {
            hl = "MarkviewBlockQuoteNote",
            preview = "󰋽 Note",
            title = true,
            icon = "󰋽",
        },
        ["TIP"] = {
            hl = "MarkviewBlockQuoteOk",
            preview = " Tip",
            title = true,
            icon = "",
        },
        ["WARNING"] = {
            hl = "MarkviewBlockQuoteWarn",
            preview = " Warning",
            title = true,
            icon = "",
        },
        ["CAUTION"] = {
            hl = "MarkviewBlockQuoteError",
            preview = "󰳦 Caution",
            title = true,
            icon = "󰳦",
        },
    },

    list_items = {
        enable = true,
        wrap = true,

        indent_size = function(buffer)
            if type(buffer) ~= "number" then
                return vim.bo.shiftwidth or 4
            end

            --- Use 'shiftwidth' value.
            return vim.bo[buffer].shiftwidth or 4
        end,
        shift_width = 4,

        marker_minus = {
            add_padding = true,
            text = function(_, item)
                local level = math.floor(item.indent / 4) + 1
                local icons = { "●", "○", "◉", "◎", "◍", "▪", "▫", "◆", "◇", "◈" }
                return icons[((level - 1) % #icons) + 1]
            end,
            hl = "MarkviewListItemMinus",
        },

        marker_plus = {
            add_padding = true,
            text = function(_, item)
                local level = math.floor(item.indent / 4) + 1
                local icons = { "●", "○", "◉", "◎", "◍", "▪", "▫", "◆", "◇", "◈" }
                return icons[((level - 1) % #icons) + 1]
            end,
            hl = "MarkviewListItemPlus",
        },

        marker_star = {
            add_padding = true,
            text = function(_, item)
                local level = math.floor(item.indent / 4) + 1
                local icons = { "●", "○", "◉", "◎", "◍", "▪", "▫", "◆", "◇", "◈" }
                return icons[((level - 1) % #icons) + 1]
            end,
            hl = "MarkviewListItemStar",
        },
    },
}

-- Define custom highlights
vim.api.nvim_set_hl(0, "MarkviewHeading1", { fg = "#F38BA8", bold = true })
vim.api.nvim_set_hl(0, "MarkviewHeading2", { fg = "#FAB387", bold = true })
vim.api.nvim_set_hl(0, "MarkviewHeading3", { fg = "#F9E2AF", bold = true })
vim.api.nvim_set_hl(0, "MarkviewHeading4", { fg = "#A6E3A1", bold = true })
vim.api.nvim_set_hl(0, "MarkviewHeading5", { fg = "#74C7EC", bold = true })
vim.api.nvim_set_hl(0, "MarkviewHeading6", { fg = "#B4BEFE", bold = true })

vim.api.nvim_set_hl(0, "MarkviewListItemMinus", { fg = "#FF9E64" })
vim.api.nvim_set_hl(0, "MarkviewListItemPlus", { fg = "#FF9E64" })
vim.api.nvim_set_hl(0, "MarkviewListItemStar", { fg = "#FF9E64" })

return config
