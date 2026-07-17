local opts = {
    fuzzy = {
        implementation = "prefer_rust_with_warning",
    },
    cmdline = {
        keymap = {
            preset = "super-tab",
            ["<Tab>"] = { "show", "select_next", "fallback" },
            ["<S-Tab>"] = { "select_prev", "fallback" },
        },
        completion = {
            menu = {
                auto_show = false,
            },
        },
    },
    completion = {
        ghost_text = {
            enabled = true,
        },
        trigger = {
            show_on_trigger_character = true,
            show_on_insert_on_trigger_character = true,
            show_on_x_blocked_trigger_characters = { "'", '"', "(", "{", ">" },
        },
        accept = {
            auto_brackets = {
                enabled = true,
            },
        },
        menu = {
            scrollbar = false,
            border = "rounded",
            draw = {
                columns = {
                    { "kind_icon", "label", "label_description", gap = 1 },
                    { "kind" },
                },
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
    },
    keymap = {
        preset = "super-tab",
        ["<A-Space>"] = { "show" },
        ["<CR>"] = { "accept", "fallback" },
    },
    appearance = {
        nerd_font_variant = "mono",
    },
    sources = {
        default = { "lsp", "snippets", "path", "buffer", "copilot" },
        per_filetype = {
            sql = { "dadbod", "snippets", "buffer" },
            mysql = { "dadbod", "snippets", "buffer" },
            text = { "dictionary" },
            markdown = { "lsp", "buffer", "thesaurus" },
        },
        providers = {
            lsp = {
                name = "lsp",
                module = "blink.cmp.sources.lsp",
                score_offset = 20,
                async = true,
            },
            snippets = {
                name = "snippets",
                module = "blink.cmp.sources.snippets",
                score_offset = -3,
            },
            path = {
                name = "path",
                module = "blink.cmp.sources.path",
                score_offset = -5,
            },
            buffer = {
                name = "buffer",
                module = "blink.cmp.sources.buffer",
                score_offset = -8,
                max_items = 5,
            },
            dadbod = { name = "dadbod", module = "vim_dadbod_completion.blink" },
            copilot = {
                name = "copilot",
                module = "blink-copilot",
                score_offset = 10,
                async = true,
            },
            thesaurus = {
                name = "blink-cmp-words",
                module = "blink-cmp-words.thesaurus",
                opts = {
                    score_offset = 0,
                    definition_pointers = { "!", "&", "^" },
                },
            },
            dictionary = {
                name = "blink-cmp-words",
                module = "blink-cmp-words.dictionary",
                opts = {
                    dictionary_search_threshold = 3,
                    score_offset = 0,
                    definition_pointers = { "!", "&", "^" },
                },
            },
        },
    },
    signature = {
        enabled = true,
        window = {
            border = "rounded",
        },
    },
}

return opts
