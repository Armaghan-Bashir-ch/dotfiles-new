local load_mappings = require("core.utils").load_mappings

local plugins = {

    -- {
    --     "rasulomaroff/reactive.nvim",
    --     enabled = false,
    --     event = "VeryLazy",
    --     config = function()
    --         require("reactive").setup({
    --             builtin = {
    --                 cursorline = true,
    --                 cursor = true,
    --                 modemsg = true,
    --             },
    --         })
    --     end,
    -- },
    -- {
    --     "danielfalk/smart-open.nvim",
    --     lazy = false,
    --     branch = "0.2.x",
    --     dependencies = {
    --         "kkharji/sqlite.lua",
    --         -- Only required if using match_algorithm fzf
    --         { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    --         -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
    --         { "nvim-telescope/telescope-fzy-native.nvim" },
    --     },
    -- },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
    {
        "jinh0/eyeliner.nvim",
        enabled = true,
        lazy = false,
        config = function()
            require("eyeliner").setup({
                -- show highlights only after keypress
                highlight_on_key = true,

                -- dim all other characters if set to true (recommended!)
                dim = false,

                -- set the maximum number of characters eyeliner.nvim will check from
                -- your current cursor position; this is useful if you are dealing with
                -- large files: see https://github.com/jinh0/eyeliner.nvim/issues/41
                max_length = 9999,

                -- filetypes for which eyeliner should be disabled;
                -- e.g., to disable on help files:
                -- disabled_filetypes = {"help"}
                disabled_filetypes = {},

                -- buftypes for which eyeliner should be disabled
                -- e.g., disabled_buftypes = {"nofile"}
                disabled_buftypes = {},

                -- add eyeliner to f/F/t/T keymaps;
                -- see section on advanced configuration for more information
                default_keymaps = true,
            })
        end,
    },

    {
        "dmtrKovalenko/fff.nvim",
        build = function()
            require("fff.download").download_or_build_binary()
        end,
        opts = require("custom.configs.fff"),
        lazy = false,
        keys = {
            {
                "ff",
                function()
                    require("fff").find_files()
                end,
                desc = "FFFind files",
            },
        },
    },
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        enabled = true,
        -- or if using mini.icons/mini.nvim
        -- dependencies = { "nvim-mini/mini.icons" },
        opts = {},
    },

    {
        "abecodes/tabout.nvim",
        enabled = false,
        lazy = false,
        config = function()
            require("tabout").setup({
                tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
                backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
                act_as_tab = true, -- shift content if tab out is not possible
                act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
                default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
                default_shift_tab = "<C-d>", -- reverse shift default action,
                enable_backwards = true, -- well ...
                completion = false, -- if the tabkey is used in a completion pum
                tabouts = {
                    { open = "'", close = "'" },
                    { open = '"', close = '"' },
                    { open = "`", close = "`" },
                    { open = "(", close = ")" },
                    { open = "[", close = "]" },
                    { open = "{", close = "}" },
                },
                ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
                exclude = {}, -- tabout will ignore these filetypes
            })
        end,
        dependencies = { -- These are optional
            "nvim-treesitter/nvim-treesitter",
        },
        opt = true,        -- Set this to true if the plugin is optional
        event = "InsertCharPre", -- Set the event to 'InsertCharPre' for better compatibility
        priority = 1000,
    },
    {
        "LintaoAmons/bookmarks.nvim",
        cmd = { "BookmarksMark", "BookmarksGoto", "BookmarksNewList", "BookmarksLists", "BookmarksCommands" },
        dependencies = {
            { "kkharji/sqlite.lua" },
            { "nvim-telescope/telescope.nvim" },
            { "stevearc/dressing.nvim" },
        },
        config = function()
            local opts = {}
            require("bookmarks").setup(opts)
        end,
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {
            modes = {
                chars = {
                    jump_labels = true,
                },
            },
        },
        -- stylua: ignore
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = load_mappings("vim_tmux_navigator"),
    },
    {
        "chrisgrieser/nvim-various-textobjs",
        event = "VeryLazy",
        opts = {
            keymaps = {
                useDefaults = true,
            },
        },
    },

    {
        "edluffy/specs.nvim",
        config = function()
            require("specs").setup({
                popup = {
                    delay_ms = 0,
                    inc_ms = 10,
                    blend = 10,
                    width = 10,
                    winhl = "PMenu",
                    fader = require("specs").linear_fader,
                    resizer = require("specs").shrink_resizer,
                },
            })
        end,
    },

    {
        "sphamba/smear-cursor.nvim",
        enabled = true,
        lazy = false,
        opts = {
            smear_between_buffers = true,
            smear_between_neighbor_lines = true,
            smear_horizontally = true,
            smear_vertically = true,
            smear_diagonally = true,

            smear_to_cmd = true,
            smear_insert_mode = true,
            smear_replace_mode = false,
            smear_terminal_mode = false,

            vertical_bar_cursor = true,
            vertical_bar_cursor_insert_mode = true,
            horizontal_bar_cursor_replace_mode = true,

            never_draw_over_target = true,
            hide_target_hack = false,

            time_interval = 17, -- ~60FPS
            delay_event_to_smear = 1,
            delay_after_key = 3,

            -- Main mode animation
            trailing_stiffness = 0.45, -- stiffer (default was 0.45)
            trailing_exponent = 3, -- favor the head even more
            distance_stop_animating = 0.1, -- stops earlier

            -- Insert mode animation (vertical bar cursor)
            stiffness_insert_mode = 0.5,         -- stronger resistance
            trailing_stiffness_insert_mode = 0.5, -- more stiffness vertically
            trailing_exponent_insert_mode = 1,   -- slightly sharper curve
            distance_stop_animating_vertical_bar = 0.875, -- shorter smear

            -- Smear limits
            max_length = 20,
            max_length_insert_mode = 1,
        },
    },

    --WARN: Do not change the smaer cursor section one bit

    {
        "chrisgrieser/nvim-puppeteer",
        lazy = false,
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        lazy = false,
        config = function()
            require("nvim-surround").setup({})
        end,
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        lazy = false,
        opts = {
            -- config go here
        },
    },

    {
        "johmsalas/text-case.nvim",
        cmd = {
            "Subs",
            "TextCaseOpenTelescope",
            "TextCaseOpenTelescopeQuickChange",
            "TextCaseOpenTelescopeLSPChange",
            "TextCaseStartReplacingCommand",
        },
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("textcase").setup({})
        end,
        keys = load_mappings("text_case"),
    },
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        version = "*",
        config = function()
            require("mini.ai").setup()
        end,
    },
    {
        "echasnovski/mini.operators",
        event = "VeryLazy",
        version = "*",
        config = function()
            require("mini.operators").setup()
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
        opts = {},
    },
    {
        "rmagatti/alternate-toggler",
        config = function()
            require("alternate-toggler").setup({
                alternates = {
                    ["=="] = "!=",
                    ["up"] = "down",
                    ["let"] = "const",
                    ["development"] = "production",
                },
            })

            vim.keymap.set(
                "n",
                "<leader><space>", -- <space><space>
                "<cmd>lua require('alternate-toggler').toggleAlternate()<CR>"
            )
        end,
        event = { "BufReadPost" }, -- lazy load after reading a buffer
    },
    {
        "gbprod/yanky.nvim",
        opts = {},
        config = require("custom.configs.yanky"),
    },

    -- lsp related
    {
        "mfussenegger/nvim-lint",
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                svelte = { "eslint_d" },
                python = { "pylint" },
            }

            vim.keymap.set("n", "<leader>ln", function()
                lint.try_lint()
            end, { desc = "lint file" })
        end,
    },
    { "chrisgrieser/nvim-rulebook",               cmd = "Rulebook", keys = load_mappings("rulebook") },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        lazy = false,
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },

    {
        "NickvanDyke/opencode.nvim",
        lazy = false,
        enabled = true,
        dependencies = {
            -- Recommended for `ask()` and `select()`.
            -- Required for `toggle()`.
            { "folke/snacks.nvim", opts = { input = {}, picker = {} } },
        },
        config = function()
            vim.g.opencode_opts = {
                -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on `opencode_opts`.
            }

            -- Required for `vim.g.opencode_opts.auto_reload`.
            vim.o.autoread = true

            -- Recommended/example keymaps.
            vim.keymap.set({ "n", "x" }, "<leader>oa", function()
                require("opencode").ask("@this: ", { submit = true })
            end, { desc = "Ask about this" })
            vim.keymap.set({ "n", "x" }, "<leader>os", function()
                require("opencode").select()
            end, { desc = "Select prompt" })
            vim.keymap.set({ "n", "x" }, "<leader>o+", function()
                require("opencode").prompt("@this")
            end, { desc = "Add this" })
            vim.keymap.set("n", "<leader>ot", function()
                require("opencode").toggle()
            end, { desc = "Toggle embedded" })
            vim.keymap.set("n", "<leader>oc", function()
                require("opencode").command()
            end, { desc = "Select command" })
            vim.keymap.set("n", "<leader>on", function()
                require("opencode").command("session_new")
            end, { desc = "New session" })
            vim.keymap.set("n", "<leader>oi", function()
                require("opencode").command("session_interrupt")
            end, { desc = "Interrupt session" })
            vim.keymap.set("n", "<leader>oA", function()
                require("opencode").command("agent_cycle")
            end, { desc = "Cycle selected agent" })
            vim.keymap.set("n", "<S-C-u>", function()
                require("opencode").command("messages_half_page_up")
            end, { desc = "Messages half page up" })
            vim.keymap.set("n", "<S-C-d>", function()
                require("opencode").command("messages_half_page_down")
            end, { desc = "Messages half page down" })
        end,
    },

    {
        "alex-popov-tech/store.nvim",
        dependencies = { "OXY2DEV/markview.nvim" },
        opts = {},
        cmd = "Store",
    },

    --INFO: This makes allows you to use a ".md" file as a proper note taking app inside of obsidian, with callouts, etc..

    {
        "folke/trouble.nvim",
        enabled = false,
        opts = {},
        cmd = "Trouble",
        keys = require("custom.configs.trouble"),
    },
    {
        "olrtg/nvim-emmet",
        event = "LspAttach",
        config = function()
            vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = true,
        event = { "BufReadPost", "BufNewFile" },
        config = require("custom.configs.nvim-treesitter-context"),
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            require("ts_context_commentstring").setup({
                enable_autocmd = false,
            })
        end,
    },

    {
        "nvzone/typr",
        dependencies = "nvzone/volt",
        opts = {},
        cmd = { "Typr", "TyprStats" },
    },

    {
        "folke/sidekick.nvim",
        opts = {
            -- add any options here
            cli = {
                mux = {
                    backend = "tmux",
                    enabled = true,
                },
            },
        },
        keys = {
            {
                "<tab>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<Tab>" -- fallback to normal tab
                    end
                end,
                expr = true,
                desc = "Goto/Apply Next Edit Suggestion",
            },
            {
                "<c-.>",
                function()
                    require("sidekick.cli").toggle()
                end,
                desc = "Sidekick Toggle",
                mode = { "n", "t", "i", "x" },
            },
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").toggle()
                end,
                desc = "Sidekick Toggle CLI",
            },
            {
                "<leader>as",
                function()
                    require("sidekick.cli").select()
                end,
                -- Or to select only installed tools:
                -- require("sidekick.cli").select({ filter = { installed = true } })
                desc = "Select CLI",
            },
            {
                "<leader>ad",
                function()
                    require("sidekick.cli").close()
                end,
                desc = "Detach a CLI Session",
            },
            {
                "<leader>at",
                function()
                    require("sidekick.cli").send({ msg = "{this}" })
                end,
                mode = { "x", "n" },
                desc = "Send This",
            },
            {
                "<leader>af",
                function()
                    require("sidekick.cli").send({ msg = "{file}" })
                end,
                desc = "Send File",
            },
            {
                "<leader>av",
                function()
                    require("sidekick.cli").send({ msg = "{selection}" })
                end,
                mode = { "x" },
                desc = "Send Visual Selection",
            },
            {
                "<leader>ap",
                function()
                    require("sidekick.cli").prompt()
                end,
                mode = { "n", "x" },
                desc = "Sidekick Select Prompt",
            },
            -- Example of a keybinding to open Claude directly
            {
                "<leader>ac",
                function()
                    require("sidekick.cli").toggle({ name = "claude", focus = true })
                end,
                desc = "Sidekick Toggle Claude",
            },
        },
    },

    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-tree.lua",
        },
        event = "LspAttach",
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
    {
        "williamboman/mason.nvim",
        opts = require("custom.configs.mason"),
    },
    {
        "neovim/nvim-lspconfig",
        event = "User FilePost",
        dependencies = { "saghen/blink.cmp" },
        config = function()
            require("plugins.configs.lspconfig")
            require("custom.configs.lspconfig")
        end,
    },
    {

        "nvimtools/none-ls.nvim",
        event = "LspAttach",
        opts = function()
            return require("custom.configs.null-ls")
        end,
    },
    {
        "olexsmir/gopher.nvim",
        ft = "go",
        config = function(_, opts)
            require("gopher").setup(opts)
            require("core.utils").load_mappings("gopher")
        end,
        build = function()
            vim.cmd([[silent! GoInstallDeps]])
        end,
    },
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        event = "VeryLazy",
        config = function()
            require("refactoring").setup()
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        event = "LspAttach",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig",
            {
                "saghen/blink.cmp",
                lazy = false,
                priority = 1000,
            },
        },
        ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "svelte" },
        opts = {
            on_attach = function(client, bufnr)
                -- Disable formatting to use a dedicated formatter (like conform.nvim or null-ls)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
            end,
            settings = {
                tsserver_disable_suggestions = true,
                tsserver_log_verbosity = "off",
                tsserver_file_preferences = {
                    includeInlayParameterNameHints = "all",
                    includeCompletionsForModuleExports = true,
                    includeCompletionsWithInsertText = true,
                },
                tsserver_format_options = {}, -- Explicitly empty to disable formatting
                expose_as_code_action = {
                    "fix_all",
                    "add_missing_imports",
                    "remove_unused",
                    "remove_unused_imports",
                    "organize_imports",
                },
                tsserver_max_memory = 8192, -- MB
                tsserver_fsa_use_browser_implementation = false,
            },
        },
    },

    --NOTE: Allows you to custamizd the statusline even more, with themes, style, seperators, etc...

    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function()
            require("venv-selector").setup()
        end,
        ft = { "python" },
        -- keys = load_mappings "venv_selector",
    },
    {
        "MunifTanjim/prettier.nvim",
        event = "LspAttach",
        config = require("custom.configs.prettier"),
    },

    {
        "nvzone/timerly",
        dependencies = "nvzone/volt",
        cmd = "TimerlyToggle",
        config = require("custom.configs.timerly").setup,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "nvimtools/none-ls.nvim",
        },
        config = function()
            require("custom.configs.null-ls")
        end,
    },
    {
        "saghen/blink.cmp",
        event = "InsertEnter",
        dependencies = { "rafamadriz/friendly-snippets", "fang2hou/blink-copilot", "archie-judd/blink-cmp-words" },
        version = "v0.*",
        opts = require("custom.configs.blink"),
        opts_extend = { "sources.default" },
    },
    {
        "tronikelis/ts-autotag.nvim",
        opts = {},
        -- ft = {}, optionally you can load it only in jsx/html
        event = "VeryLazy",
    },
    {
        "Goose97/timber.nvim",
        version = "*",
        event = "VeryLazy",
        config = require("custom.configs.timber"),
    },
    {
        "jdrupal-dev/code-refactor.nvim",
        enabled = false,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        -- keys = load_mappings "code_refactor",
        config = function()
            require("code-refactor").setup({})
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = true,
        config = require("custom.configs.textobjects"),
    },
    {
        "kevinhwang91/nvim-ufo",
        requires = "kevinhwang91/promise-async",
        lazy = false,
        config = require("custom.configs.ufo"),
    },

    -- pickers
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
    {
        "nvim-telescope/telescope.nvim",
        lazy = true,
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "debugloop/telescope-undo.nvim",
        },
        config = require("custom.configs.telescope"),
    },
    {
        "axkirillov/easypick.nvim",
        requires = "nvim-telescope/telescope.nvim",
        cmd = "Easypick",
        config = require("custom.configs.easypick"),
    },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    {
        "stevearc/quicker.nvim",
        event = "FileType qf",
        ---@module "quicker"
        opts = {},
        config = function()
            require("quicker").setup()
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        opts = {
            settings = {
                save_on_toggle = true,
                project = {
                    enable = true,
                    root_files = { ".git" },
                },
            },
        },
        keys = require("custom.configs.harpoon")(),
    },

    {
        "m4xshen/hardtime.nvim",
        lazy = false,
        enabled = true,
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
    },

    --NOTE: Enable this when you get use to vim motions, never before

    {
        "Wansmer/treesj",
        lazy = true,
        cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
        keys = {
            { "gJ", "<cmd>TSJToggle<CR>", desc = "Toggle Split/Join" },
        },
        opts = {
            use_default_keymaps = false,
        },
    },
    {
        "gbprod/stay-in-place.nvim",
        lazy = false,
        config = true, -- run require("stay-in-place").setup()
    },
    {
        "chrisgrieser/nvim-scissors",
        event = "BufEnter",
        dependencies = "nvim-telescope/telescope.nvim",
        opts = {
            snippetDir = vim.fn.stdpath("config") .. "/snippets",
        },
        keys = {
            "<Leader>asa",
            "<Leader>ase",
        },
        config = function()
            local present, wk = pcall(require, "which-key")
            if not present then
                return
            end

            wk.add({
                { "<leader>as", group = "Snippets", nowait = false, remap = false },
                {
                    "<leader>asa",
                    '<cmd>lua require("scissors").addNewSnippet()<CR>',
                    desc = "Add new snippet",
                    nowait = false,
                    remap = false,
                },
                {
                    "<leader>ase",
                    '<cmd>lua require("scissors").editSnippet()<CR>',
                    desc = "Edit snippet",
                    nowait = false,
                    remap = false,
                },
            })

            wk.add({
                {
                    "<leader>as",
                    group = "Snippets",
                    mode = "x",
                    nowait = false,
                    remap = false,
                },
                {
                    "<leader>asa",
                    '<cmd>lua require("scissors").addNewSnippet()<CR>',
                    desc = "Add new snippet from selection",
                    mode = "x",
                    nowait = false,
                    remap = false,
                },
            })
        end,
    },
    {
        "MunifTanjim/nui.nvim",
        lazy = true, -- Load only when needed
    },
    {
        "vuki656/package-info.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        event = "BufEnter package.json",
        opts = {
            highlights = {
                up_to_date = { fg = "#3C4048" }, -- Text color for up to date package virtual text
                outdated = { fg = "#fc514e" }, -- Text color for outdated package virtual text
            },
            icons = {
                enable = true,    -- Whether to display icons
            },
            autostart = true,     -- Whether to autostart when `package.json` is opened
            hide_up_to_date = true, -- It hides up to date versions when displaying virtual text
            hide_unstable_versions = true, -- It hides unstable versions from version list e.g next-11.1.3-canary3

            package_manager = "yarn",
        },
    },
    {
        "chentoast/marks.nvim",
        event = "BufEnter",
        config = true,
    },
    {
        "j-hui/fidget.nvim",
        opts = {
            -- options
        },
    },
    {
        "nacro90/numb.nvim",
        lazy = false,
        opts = {},
    },
    {
        "MaximilianLloyd/tw-values.nvim",
        keys = {
            { "<Leader>cv", "<CMD>TWValues<CR>", desc = "Tailwind CSS values" },
        },
        opts = {
            border = "rounded", -- Valid window border style,
            show_unknown_classes = true, -- Shows the unknown classes popup
        },
    },
    {
        "dmmulroy/ts-error-translator.nvim",
        config = true,
    },
    {
        "razak17/tailwind-fold.nvim",
        enabled = true,
        opts = {
            min_chars = 100,
        },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        event = {
            "BufReadPre /home/armaghan/Obsidian Vault/*.md",
            "BufNewFile /home/armaghan/Obsidian Vault/*.md",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            ui = { enabled = false },
            workspaces = {
                {
                    name = "personal",
                    path = "/home/armaghan/Obsidian Vault/",
                },
            },
            templates = {
                folder = "templates",
                date_format = "%Y-%m-%d-%a",
                time_format = "%H:%M",
            },
        },
    },
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        config = function()
            vim.g.undotree_WindowLayout = 3 -- Position undotree on the right
            vim.g.undotree_SplitWidth = 40 -- Make it wider
        end,
    },
    {
        "ThePrimeagen/vim-be-good",
        cmd = "VimBeGood",
    },

    --NOTE: This is a fun game to learn vim motions, practice with it like you do with a typing website everyday

    -- Task UIs
    ---@type LazySpec
    {
        "mikavilpas/yazi.nvim",
        cmd = "Yazi",
        keys = load_mappings("yazi"),
        opts = {
            open_for_directories = false,
            keymaps = {
                show_help = "<f1>",
            },
        },
    },

    --NOTE: Yazi is pretty useless, once you get used to telescope and harpoon, but its there for the sake of being there
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        init = function()
            vim.api.nvim_set_hl(0, "LazygitActive", { fg = "#b85a3a", bold = true })
            vim.api.nvim_set_hl(0, "LazygitInactive", { fg = "#444444" })
            vim.api.nvim_set_hl(0, "LazygitSelected", { bg = "#2a2a4e" })
            vim.api.nvim_set_hl(0, "LazygitDefault", { fg = "#c0c0c0" })
            vim.api.nvim_set_hl(0, "LazygitUnstaged", { fg = "#ff4444" })
            vim.api.nvim_set_hl(0, "LazygitCherryBg", { fg = "#ffaa00" })
            vim.api.nvim_set_hl(0, "LazygitCherryFg", { fg = "#ffffff" })
            vim.api.nvim_set_hl(0, "LazygitOptions", { fg = "#b85a3a" })
            vim.api.nvim_set_hl(0, "LazygitSearch", { fg = "#ff0088", bold = true })
        end,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            zen = {
                enabled = true,
                on_open = function(_)
                    vim.fn.system("tmux set-option status off")
                end,
                --- Callback when the window is closed.
                ---@param win snacks.win
                on_close = function(_)
                    vim.fn.system("tmux set-option status on")
                end,
                --- Options for the `Snacks.zen.zoom()`
                ---@type snacks.zen.Config
                zoom = {
                    toggles = {},
                    show = { statusline = false, tabline = false },
                    win = {
                        backdrop = false,
                        width = 0, -- full width
                    },
                },
            },
            quickfile = { enabled = true },
            lazygit = {
                enabled = true,
                theme = {
                    activeBorderColor = { fg = "LazygitActive" },
                    cherryPickedCommitBgColor = { fg = "LazygitCherryBg" },
                    cherryPickedCommitFgColor = { fg = "LazygitCherryFg" },
                    defaultFgColor = { fg = "LazygitDefault" },
                    inactiveBorderColor = { fg = "LazygitInactive" },
                    optionsTextColor = { fg = "LazygitOptions" },
                    searchingActiveBorderColor = { fg = "LazygitSearch" },
                    selectedLineBgColor = { bg = "LazygitSelected" },
                    unstagedChangesColor = { fg = "LazygitUnstaged" },
                },
            },
            scratch = { enabled = true },
            gitbrowse = { enabled = true },
            notifier = { enabled = true },
            scroll = {
                enabled = false,
                animate = {
                    duration = { step = 12, total = 180 }, -- nice and smooth
                },
                animate_repeat = {
                    delay = 10,          -- if next scroll happens within 80ms, use fast mode
                    duration = { step = 1, total = 1 }, -- basically instant
                },
            },
        },
        keys = load_mappings("snacks"),
    },
    {
        "kndndrj/nvim-dbee",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        cmd = "Dbee",
        build = function()
            -- Install tries to automatically detect the install method.
            -- if it fails, try calling it with one of these parameters:
            --    "curl", "wget", "bitsadmin", "go"
            require("dbee").install()
        end,
        config = function()
            require("dbee").setup( --[[optional config]])
        end,
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod",                     lazy = true },
            { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },
    { "akinsho/git-conflict.nvim",  version = "*", config = true, event = "VeryLazy" },

    {
        "chrisgrieser/nvim-rip-substitute",
        cmd = "RipSubstitute",
        opts = {},
        keys = {
            {
                "<leader>rs",
                function()
                    require("rip-substitute").sub()
                end,
                mode = { "n", "x" },
                desc = " rip substitute",
            },
        },
    },
    {
        "MagicDuck/grug-far.nvim",
        cmd = "GrugFar",
        config = function()
            require("grug-far").setup({})
        end,
    },
    {
        "letieu/btw.nvim",
        config = function()
            require("btw").setup({
                text = "I use Neovim with Arch (BTW)",
            })
        end,
        lazy = false,
        enabled = true,
    },

    -- This is a cool nvim banner for the default screen

    {
        "rmagatti/auto-session",
        lazy = false,
        config = function()
            require("auto-session").setup({
                auto_restore = false,
                auto_session_enable_last_session = false,
                pre_save_cmds = { "tabdo NvimTreeClose" },
            })
        end,
    },
    {
        "stevearc/oil.nvim",
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            default_file_explorer = false,
        },
        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
        config = function()
            require("oil").setup({
                default_file_explorer = false,
            })
        end,
    },
    {
        "refractalize/oil-git-status.nvim",

        dependencies = {
            "stevearc/oil.nvim",
        },

        config = true,
    },
    {
        "JezerM/oil-lsp-diagnostics.nvim",
        dependencies = { "stevearc/oil.nvim" },
        opts = {},
    },

    -- utils
    { "kevinhwang91/promise-async", lazy = false },
    {
        "nvim-lua/plenary.nvim",
        config = require("custom.configs.plenary"),
    },
    { "wakatime/vim-wakatime", lazy = false },

    -- ADD TOKYONIGHT PLUGIN HERE INSIDE THE TABLE

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "night", -- THIS IS WHAT FORCES THE 'night' variant
            transparent = true, --  This is not needed inside of ghostty and hyprland since the transparency is already enabled by default, but is important if your own some other OS
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        },
        config = function(_, opts)
            require("tokyonight").setup(opts) -- <- you were missing this
            vim.cmd("colorscheme tokyonight")
        end,
    },

    {
        "atiladefreitas/dooing",
        cmd = { "Dooing", "DooingLocal" },
        config = function()
            require("dooing").setup({
                window = {
                    position = "center",
                },
                quick_keys = false,
            })
        end,
    },

    -- ~/.config/nvim/lua/plugins/lualine.lua
    --NOTE: Do not change the theme to anything else

    {
        "rcarriga/nvim-notify",
        opts = function(_, opts)
            opts.top_down = false
            opts.stages = "fade_in_slide_out"
            opts.timeout = 2000
            opts.max_width = 100
            opts.max_height = 50

            -- Position notifications at top to avoid tmux/statusline overlap
            opts.on_open = function(win)
                local config = vim.api.nvim_win_get_config(win)
                config.relative = "editor"
                config.anchor = "NW"

                local width = 50
                local height = 5
                config.row = 1                           -- Top position (small offset from edge)
                config.col = math.floor((vim.o.columns - width) / 2) -- Center horizontally

                vim.api.nvim_win_set_config(win, config)
            end

            return opts
        end,
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        enabled = false,
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
    },

    --NOTE: Noice.nvim makes it so that, the statusline stays low on the screen, and also that it collides with the tmux                 status line
}

return plugins
