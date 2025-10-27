return function()
    -- Define custom highlight groups for a cooler cyberpunk appearance with fully transparent backgrounds
    vim.api.nvim_set_hl(0, "FFFBorder", { fg = "#ff007f", bg = "NONE" })
    vim.api.nvim_set_hl(0, "FFFNormal", { bg = "NONE", fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "FFFCursor", { bg = "NONE", fg = "#00ffff", underline = true })
    vim.api.nvim_set_hl(0, "FFFMatched", { fg = "#ff4500", bold = true, bg = "NONE" })
    vim.api.nvim_set_hl(0, "FFFTitle", { fg = "#00ff00", bold = true, bg = "NONE" })
    vim.api.nvim_set_hl(0, "FFFPrompt", { fg = "#ffff00", bold = true, bg = "NONE" })
    vim.api.nvim_set_hl(0, "FFFActiveFile", { bg = "NONE", fg = "#ff69b4", italic = true })
    vim.api.nvim_set_hl(0, "FFFFrecency", { fg = "#87ceeb", bg = "NONE" })
    vim.api.nvim_set_hl(0, "FFFDebug", { fg = "#808080", italic = true, bg = "NONE" })

    require("fff").setup({
        title = "FFFinder",
        max_results = 150,
        max_threads = 8,
        lazy_sync = true,
        layout = {
            height = 0.95,
            width = 0.95,
            prompt_position = "top",
            preview_position = "bottom",
            preview_size = 0.4,
        },
        preview = {
            enabled = true,
            max_size = 10 * 1024 * 1024,
            chunk_size = 8192,
            binary_file_threshold = 1024,
            imagemagick_info_format_str = "%m: %wx%h, %[colorspace], %q-bit",
            line_numbers = true,
            wrap_lines = false,
            show_file_info = true,
            filetypes = {
                svg = { wrap_lines = true },
                markdown = { wrap_lines = true },
                text = { wrap_lines = true },
            },
        },
        keymaps = {
            close = "<Esc>",
            select = "<CR>",
            select_split = "<C-s>",
            select_vsplit = "<C-v>",
            select_tab = "<C-t>",
            move_up = { "<Up>", "<C-p>", "<C-k>" },
            move_down = { "<Down>", "<C-n>", "<C-j>" },
            preview_scroll_up = "<C-u>",
            preview_scroll_down = "<C-d>",
            toggle_debug = "<F2>",
        },
        hl = {
            border = "FFFBorder",
            normal = "FFFNormal",
            cursor = "FFFCursor",
            matched = "FFFMatched",
            title = "FFFTitle",
            prompt = "FFFPrompt",
            active_file = "FFFActiveFile",
            frecency = "FFFFrecency",
            debug = "FFFDebug",
        },
        frecency = {
            enabled = true,
            db_path = vim.fn.stdpath("cache") .. "/fff_nvim",
        },
        debug = {
            enabled = false,
            show_scores = false,
        },
        logging = {
            enabled = true,
            log_file = vim.fn.stdpath("log") .. "/fff.log",
            log_level = "info",
        },
    })

    local builtin = require("fff")
    vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
    vim.keymap.set("n", "<C-p>", builtin.find_in_git_root, {})
    vim.keymap.set("n", "<leader>ps", builtin.scan_files, {})
end

