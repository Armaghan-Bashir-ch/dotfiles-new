return {
    defaults = { lazy = true },

    ui = {
        border = "rounded",
        title_pos = "center",
        icons = {
            ft = "", -- file type: nf-fa-file_o
            loaded = "", -- loaded: nf-fa-check_circle
            not_loaded = "", -- not loaded: nf-md-circle_outline
            backdrop = 50,
            title = " Lazy Plugin Manager",
        },
        colors = {
            loaded = "#00ff88",
            not_loaded = "#ff4444",
            special = "#ffaa00",
        },
        highlights = {
            LazyProgressDone = { fg = "#00ff88" },
            LazyError = { fg = "#ff4444" },
            LazyWarning = { fg = "#ffaa00" },
        },
    },

    performance = {
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "tohtml",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "netrw",
                "netrwPlugin",
                "netrwSettings",
                "netrwFileHandlers",
                "matchit",
                "tar",
                "tarPlugin",
                "rrhelper",
                "spellfile_plugin",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
                "tutor",
                "rplugin",
                "syntax",
                "synmenu",
                "optwin",
                "compiler",
                "bugreport",
                "ftplugin",
            },
        },
    },
}

--WARN: NEVER CHANGE THIS
