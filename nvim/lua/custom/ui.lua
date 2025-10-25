local ui = {
    theme = "tokyonight",
    transparency = false, -- Disable transparency to see bg colors
    statusline = {
        theme = "default",
        separator_style = "block",
        overriden_modules = function(modules)
            -- Available highlight groups (from statusline/default.lua):
            -- %#St_NormalMode# - Blue background (mode colors)
            -- %#St_LspStatus# - White text with background
            -- %#St_gitIcons# - White text, no background
            -- %#St_lspError# - Red text
            -- %#St_lspWarning# - Yellow text
            -- %#St_lspHints# - Cyan text
            -- %#St_lspInfo# - Blue text
            -- %#St_cwd_icon# - Folder icon color
            -- %#St_cwd_text# - White text with background
            -- %#St_file_info# - File info colors
            -- %#St_pos_text# - Position text

            -- Module positions:
            -- 1=mode, 2=fileInfo, 3=git, 4=%=, 5=LSP_progress, 6=%=, 7=LSP_Diagnostics, 8=LSP_status, 9=cwd, 10=cursor_position

            local utils = require("custom.utils")
            modules[3] = "%#St_gitIcons#" .. " " .. (utils.vim_zen or "zen") .. " "
            modules[7] = "" -- Hide LSP diagnostics
            modules[8] = "%#St_lspHints#" .. " " .. (utils.buffer_size or "size") .. " "
             modules[9] = (function()
                 if (utils.streak_display or "") ~= "" then
                     return "%#St_lspWarning#" .. " " .. utils.streak_display .. " "
                 else
                     return ""
                 end
             end)()
             modules[10] = "" -- Hide cursor position
        end,
    },
    tabufline = {
        enabled = false,
        show_numbers = false,
        overriden_modules = function(modules)
            -- Remove the buttons (theme toggle and close all buffers)
            modules[4] = ""
        end,
    },
}

return ui
