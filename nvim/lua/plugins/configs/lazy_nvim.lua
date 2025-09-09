return {
    defaults = { lazy = true },
    install = { colorscheme = { "nvchad" } },

    ui = {
        icons = {
            ft = "", -- file type: nf-md-file_document_outline
            lazy = "󰒲", -- lazy.nvim: nf-md-rocket_launch or nf-md-power
            loaded = "󰄴 ", -- loaded: nf-md-check_circle_outline
            not_loaded = "󰚌", -- not loaded: nf-md-circle_dashed
            backdrop = 100,
            title = "Lazy Plugin Manager",
        },
    },

    --TODO: Find better icons, and see if they suit this or not

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
