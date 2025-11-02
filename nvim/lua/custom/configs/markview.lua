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

        indent_size = function (buffer)
            if type(buffer) ~= "number" then
                return vim.bo.shiftwidth or 4;
            end

            --- Use 'shiftwidth' value.
            return vim.bo[buffer].shiftwidth or 4;
        end,
        shift_width = 4,

        marker_minus = {
            add_padding = true,
            text = function(_, item)
                local level = math.floor(item.indent / 4) + 1
                local icons = {"●", "○", "▪", "▫"}
                return icons[((level - 1) % #icons) + 1]
            end,
            hl = "MarkviewListItemMinus",
        },

        marker_plus = {
            add_padding = true,
            text = function(_, item)
                local level = math.floor(item.indent / 4) + 1
                local icons = {"●", "○", "▪", "▫"}
                return icons[((level - 1) % #icons) + 1]
            end,
            hl = "MarkviewListItemPlus",
        },

        marker_star = {
            add_padding = true,
            text = function(_, item)
                local level = math.floor(item.indent / 4) + 1
                local icons = {"●", "○", "▪", "▫"}
                return icons[((level - 1) % #icons) + 1]
            end,
            hl = "MarkviewListItemStar",
        },

        marker_dot = {
            text = function(_, item)
                return string.format("%d.", item.n)
            end,
            hl = "@markup.list.markdown",
            add_padding = true,
        },

        marker_parenthesis = {
            text = function(_, item)
                return string.format("%d)", item.n)
            end,
            hl = "@markup.list.markdown",
            add_padding = true,
        },
    },
}

-- Define custom highlights
vim.api.nvim_set_hl(0, "MarkviewHeading1", { fg = "#f38ba8", bold = true })
vim.api.nvim_set_hl(0, "MarkviewHeading2", { fg = "#fab387", bold = true })
vim.api.nvim_set_hl(0, "MarkviewHeading3", { fg = "#f9e2af", bold = true })
vim.api.nvim_set_hl(0, "MarkviewHeading4", { fg = "#a6e3a1", bold = true })
vim.api.nvim_set_hl(0, "MarkviewHeading5", { fg = "#74c7ec", bold = true })
vim.api.nvim_set_hl(0, "MarkviewHeading6", { fg = "#b4befe", bold = true })

vim.api.nvim_set_hl(0, "MarkviewListItemMinus", { fg = "#FF9E64" })
vim.api.nvim_set_hl(0, "MarkviewListItemPlus", { fg = "#FF9E64" })
vim.api.nvim_set_hl(0, "MarkviewListItemStar", { fg = "#FF9E64" })

return config
