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

    code_blocks = {
        enable = true,
        border_hl = "MarkviewCode",
        info_hl = "MarkviewCodeInfo",
        label_direction = "right",
        min_width = 60,
        pad_amount = 2,
        pad_char = " ",
        default = {
            block_hl = "MarkviewCode",
            pad_hl = "MarkviewCode",
        },
        style = "block",
        sign = true,
    },

    markdown = {
        headings = {
            enable = true,
            heading_1 = {
                style = "icon",
                sign = "󰌕 ",
                sign_hl = "MarkviewHeading1Sign",
                icon = "󰼏  ",
                hl = "MarkviewHeading1",
            },
            heading_2 = {
                style = "icon",
                sign = "󰌖 ",
                sign_hl = "MarkviewHeading2Sign",
                icon = "󰎨  ",
                hl = "MarkviewHeading2",
            },
            heading_3 = {
                style = "icon",
                icon = "󰼑  ",
                hl = "MarkviewHeading3",
            },
            heading_4 = {
                style = "icon",
                icon = "󰎲  ",
                hl = "MarkviewHeading4",
            },
            heading_5 = {
                style = "icon",
                icon = "󰼓  ",
                hl = "MarkviewHeading5",
            },
            heading_6 = {
                style = "icon",
                icon = "󰎴  ",
                hl = "MarkviewHeading6",
            },
            setext_1 = {
                style = "decorated",
                sign = "󰌕 ",
                sign_hl = "MarkviewHeading1Sign",
                icon = "  ",
                hl = "MarkviewHeading1",
                border = "▂",
            },
            setext_2 = {
                style = "decorated",
                sign = "󰌖 ",
                sign_hl = "MarkviewHeading2Sign",
                icon = "  ",
                hl = "MarkviewHeading2",
                border = "▁",
            },
            shift_width = 1,
        },
        horizontal_rules = {
            enable = true,
            parts = {
                {
                    type = "repeating",
                    direction = "left",
                    repeat_amount = 20,
                    text = "─",
                    hl = {
                        "MarkviewGradient1",
                        "MarkviewGradient2",
                        "MarkviewGradient3",
                        "MarkviewGradient4",
                        "MarkviewGradient5",
                        "MarkviewGradient6",
                        "MarkviewGradient7",
                        "MarkviewGradient8",
                        "MarkviewGradient9",
                    },
                },
                {
                    type = "text",
                    text = "  ",
                    hl = "MarkviewIcon3Fg",
                },
                {
                    type = "repeating",
                    direction = "right",
                    repeat_amount = 20,
                    text = "─",
                    hl = {
                        "MarkviewGradient1",
                        "MarkviewGradient2",
                        "MarkviewGradient3",
                        "MarkviewGradient4",
                        "MarkviewGradient5",
                        "MarkviewGradient6",
                        "MarkviewGradient7",
                        "MarkviewGradient8",
                        "MarkviewGradient9",
                    },
                },
            },
        },
        tables = {
            enable = true,
            strict = false,
            block_decorator = true,
            use_virt_lines = false,
            parts = {
                top = { "╭", "─", "╮", "┬" },
                header = { "│", "│", "│" },
                separator = { "├", "─", "┤", "┼" },
                row = { "│", "│", "│" },
                bottom = { "╰", "─", "╯", "┴" },
                overlap = { "┝", "━", "┥", "┿" },
                align_left = "╼",
                align_right = "╾",
                align_center = { "╴", "╶" },
            },
            hl = {
                top = { "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader" },
                header = { "MarkviewTableHeader", "MarkviewTableHeader", "MarkviewTableHeader" },
                separator = {
                    "MarkviewTableHeader",
                    "MarkviewTableHeader",
                    "MarkviewTableHeader",
                    "MarkviewTableHeader",
                },
                row = { "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder" },
                bottom = { "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder" },
                overlap = { "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder", "MarkviewTableBorder" },
                align_left = "MarkviewTableAlignLeft",
                align_right = "MarkviewTableAlignRight",
                align_center = { "MarkviewTableAlignCenter", "MarkviewTableAlignCenter" },
            },
        },
    },

    list_items = {
        enable = true,
        indent_size = function (buffer)
            if type(buffer) ~= "number" then
                return vim.bo.shiftwidth or 4;
            end

            -- Use 'shiftwidth' value.
            return vim.bo[buffer].shiftwidth or 4;
        end,
        shift_width = 2,
        marker_minus = {
            text = function(_, item)
                local level = item.indent + 1
                if level == 1 then return "●"
                elseif level == 2 then return "□"
                elseif level == 3 then return "○"
                else return "△" end
            end,
            hl = "MarkviewListItemMinus",
        },
        marker_plus = {
            text = function(_, item)
                local level = item.indent + 1
                if level == 1 then return "◈"
                elseif level == 2 then return "□"
                elseif level == 3 then return "○"
                else return "△" end
            end,
            hl = "MarkviewListItemPlus",
        },
        marker_star = {
            text = function(_, item)
                local level = item.indent + 1
                if level == 1 then return "◇"
                elseif level == 2 then return "□"
                elseif level == 3 then return "○"
                else return "△" end
            end,
            hl = "MarkviewListItemStar",
        },
        marker_dot = {
            text = function(_, item)
                return string.format("%d.", item.n)
            end,
            hl = "@markup.list.markdown",
        },
        marker_parenthesis = {
            text = function(_, item)
                return string.format("%d)", item.n)
            end,
            hl = "@markup.list.markdown",
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
