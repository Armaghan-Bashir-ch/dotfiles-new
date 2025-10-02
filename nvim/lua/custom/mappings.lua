local M = {}

local utils = require("custom.utils")

M.gopher = {
    plugin = true,
    n = {
        ["<leader>gsj"] = {
            "<cmd> GoTagAdd json <CR>",
            "Add json struct tags",
        },
        ["<leader>gsy"] = {
            "<cmd> GoTagAdd yaml <CR>",
            "Add yaml struct tags",
        },
        ["<leader>gie"] = {
            "<cmd> GoIfErr <CR>",
            "Add json struct tags",
        },
    },
}

M.vim_tmux_navigator = {
    plugin = true,
    n = {
        ["<c-h>"] = { "<cmd>TmuxNavigateLeft<cr>", "Tmux Navigate Left" },
        ["<c-j>"] = { "<cmd>TmuxNavigateDown<cr>", "Tmux Navigate Down" },
        ["<c-k>"] = { "<cmd>TmuxNavigateUp<cr>", "Tmux Navigate Up" },
        ["<c-l>"] = { "<cmd>TmuxNavigateRight<cr>", "Tmux Navigate Right" },
        ["<c-\\>"] = { "<cmd>TmuxNavigatePrevious<cr>", "Tmux Navigate Previous" },
    },
}

M.venv_selector = {
    plugin = true,
    n = {
        ["<leader>vs"] = {
            "<cmd>VenvSelect<cr>",
            "Venv selector",
        },
    },
}

M.text_case = {
    plugin = true,
    n = {
        ["ga."] = {
            "<cmd>TextCaseOpenTelescope<CR>",
            "Telescope for text case",
        },
    },
    x = {
        ["ga."] = {
            "<cmd>TextCaseOpenTelescope<CR>",
            "Telescope for text case",
        },
    },
}

M.yazi = {
    plugin = true,
    n = {
        ["<leader>yz"] = {
            "<cmd>Yazi<cr>",
            "Open yazi at the current file",
        },
        ["<leader>cw"] = {
            "<cmd>Yazi cwd<cr>",
            "Open the file manager in nvim's working directory",
        },
        ["<c-up>"] = {
            "<cmd>Yazi toggle<cr>",
            "Resume the last yazi session",
        },
    },
}

M.snacks = {
    plugin = true,
    n = {
        ["<leader>."] = {
            function()
                Snacks.scratch()
            end,
            "Toggle Scratch Buffer",
        },
        ["<leader>S"] = {
            function()
                Snacks.scratch.select()
            end,
            "Select Scratch Buffer",
        },
        ["<M-l>"] = {
            function()
                Snacks.lazygit()
            end,
            "Lazygit",
        },
        ["<leader>gB"] = {
            function()
                Snacks.gitbrowse()
            end,
            "Git Browse",
            mode = { "n", "v" },
        },

        ["<leader>bB"] = {
            function()
                vim.fn.system("xdg-open https://github.com/Armaghan-Bashir-ch/dotfiles-new &")
            end,
            "Open dotfiles repo",
        },
        ["<leader>nh"] = {
            function()
                Snacks.notifier.show_history()
            end,
            "Git browse",
        },
        ["<leader>nw"] = {
            function()
                Snacks.notifier.hide()
            end,
            "Git browse",
        },
        ["<leader>zn"] = {
            function()
                -- TODO: find diff bw Snacks.zen.zen() and Snacks.zen()
                Snacks.zen.zen()
            end,
            "Toggle Zen",
        },
        ["<leader>zz"] = {
            function()
                Snacks.zen.zoom()
            end,
            "Toggle zoom Zen",
        },
    },
}

M.code_refactor = {
    plugin = true,
    n = {
        ["<leader>cra"] = {
            "<cmd>CodeActions all<CR>",
            "Show code-refactor.nvim (not LSP code actions)",
        },
    },
}

M.spider_motion = {
    plugin = true,
    n = {
        ["w"] = {
            "<cmd>lua require('spider').motion('w')<CR>",
            "Spider-w",
        },
        ["e"] = {
            "<cmd>lua require('spider').motion('e')<CR>",
            "Spider-e",
        },
        ["b"] = {
            "<cmd>lua require('spider').motion('b')<CR>",
            "Spider-b",
        },
    },

    o = {
        ["w"] = {
            "<cmd>lua require('spider').motion('w')<CR>",
            "Spider-w",
        },
        ["e"] = {
            "<cmd>lua require('spider').motion('e')<CR>",
            "Spider-e",
        },
        ["b"] = {
            "<cmd>lua require('spider').motion('b')<CR>",
            "Spider-b",
        },
    },
    x = {
        ["w"] = {
            "<cmd>lua require('spider').motion('w')<CR>",
            "Spider-w",
        },
        ["e"] = {
            "<cmd>lua require('spider').motion('e')<CR>",
            "Spider-e",
        },
        ["b"] = {
            "<cmd>lua require('spider').motion('b')<CR>",
            "Spider-b",
        },
    },
}

M.rulebook = {
    plugin = true,
    n = {
        ["<leader>ri"] = {
            function()
                require("rulebook").ignoreRule()
            end,
            "Ignore a rule",
        },
        ["<leader>rl"] = {
            function()
                require("rulebook").lookupRule()
            end,
            "Lookup a rule",
        },
        ["<leader>ry"] = {
            function()
                require("rulebook").yankDiagnosticCode()
            end,
            "Yank diagnostic code",
        },
    },
    x = {
        ["<leader>rf"] = {
            function()
                require("rulebook").suppressFormatter()
            end,
            "Suppress formatter",
        },
    },
}

M.true_zen = {
    plugin = true,
    n = {
        ["<leader>znn"] = {
            "<cmd>TZNarrow<CR>",
            "Enable TZNarrow in normal mode",
        },
        ["<leader>znf"] = {
            "<cmd>TZFocus<CR>",
            "Enable TZFocus in normal mode",
        },
        ["<leader>znm"] = {
            "<cmd>TZMinimalist<CR>",
            "Enable TZMinimalist in normal mode",
        },
        ["<leader>zna"] = {
            "<cmd>TZAtaraxis<CR>",
            "Enable TZAtaraxis in normal mode",
        },
    },
    v = {
        ["<leader>znn"] = {
            ":'<,'>TZNarrow<CR>",
            "Enable TZNarrow in visual mode",
        },
    },
}

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "<C-f>", "<cmd>FzfLua<CR>", { desc = "Open fzf-lua menu" })

-- Makes it so going half buffer down or up, centers the cursor on the screen

M.general = {
    n = {
        ["G"] = { "Gzz", "center after touching bottom" },
        ["<leader>fy"] = { "<cmd>let @+ = expand('%:t:r')<CR>", "Yank current file's name" },
        ["<leader>bm"] = { "<cmd>BookmarksMark<CR>", "Mark/Toggle bookmark" },
        ["<leader>bg"] = { "<cmd>BookmarksGoto<CR>", "Go to bookmark" },
        ["<leader>bn"] = { "<cmd>BookmarksNewList<CR>", "Create new bookmark list" },
        ["<leader>bl"] = { "<cmd>BookmarksLists<CR>", "Pick bookmark list" },
        ["<leader>bc"] = { "<cmd>BookmarksCommands<CR>", "Find bookmark commands" },

        ["<leader>wpt"] = {
            "viwocPromise<<Esc>pa><Esc>",
            "Wrap selected type in Promise<>",
        },
        ["T"] = { "<cmd>b#<CR>", "Open last closed buffer" },
        ["<leader>tmt"] = { ":silent !tmuxt<CR>", "Toggle tmux status bar" },
        ["<leader>poc"] = { ":silent !git poc &<CR>", "Push to the current branch in the background" },
        ["<leader>acp"] = {
            function()
                vim.ui.input({ prompt = "Commit message: " }, function(msg)
                    if msg and msg ~= "" then
                        local cmd = "git acp " .. vim.fn.shellescape(msg) .. " &"
                        vim.fn.system(cmd) -- Run silently in the background
                        print("✅ Committing & pushing: " .. msg)
                    else
                        print("❌ Commit aborted: No message provided.")
                    end
                end)
            end,
            "Git commit & push",
        },
        -- plugin specifics:
        ["<leader>du"] = { "<cmd>tabnew | DBUIToggle<CR>", "Toggle Dadbod UI in a new tab" },
        ["<leader>db"] = {
            function()
                require("dbee").toggle()
            end,
            "Toggle Dadbod UI in a new tab",
        },
        -- ufo
        ["zR"] = { "<cmd>lua require('ufo').openAllFolds()<CR>", "Open all folds" },
        ["zM"] = { "<cmd>lua require('ufo').closeAllFolds()<CR>", "Close all folds" },
        ["K"] = {
            function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end,
            "Peek Fold/Hover",
        },
        -- timber.nvim
        ["<leader>ctl"] = {
            function()
                require("timber.actions").clear_log_statements({ global = false })
            end,
            "Clear timber log statements in current buffer",
        },
        ["<leader>tls"] = {
            function()
                require("timber.summary").open({ focus = true })
            end,
            "Clear timber log statements in current buffer",
        },

        -- remaps for tabs
        ["<leader>tn"] = { "<cmd>tabnext<CR>", "Go to next tab" },
        ["<leader>tx"] = { "<cmd>tabclose<CR>", "Go to next tab" },
        ["<leader>tp"] = { "<cmd>tabprevious<CR>", "Go to previous tab" },
        ["<leader>t1"] = { "<cmd>tabn 1<CR>", "Go to tab 1" },
        ["<leader>t2"] = { "<cmd>tabn 2<CR>", "Go to tab 2" },
        ["<leader>t3"] = { "<cmd>tabn 2<CR>", "Go to tab 3" },

        ["<leader>tdg"] = {
            function()
                utils.toggleDiagnostics()
            end,
            "Toggle Diagnostics",
        },

        -- lsp remaps
        ["<leader>te"] = {
            "<cmd>execute 'normal! O// @ts-expect-error'<CR>j",
            "Add // @ts-expect-error above the current line",
        },
        ["<leader>ti"] = {
            "<cmd>execute 'normal! O// @ts-ignore'<CR>j",
            "Add // @ts-ignore above the current line",
        },
        ["<leader>tsn"] = { "ggO// @ts-nocheck<Esc>", "Add ts-nocheck at the top of the file" },
        ["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>" },
        ["<leader>ra"] = {
            "<cmd>lua require('nvchad.renamer').open()<CR>",
            "LSP rename",
        },
        ["<leader>esf"] = { "<cmd> EslintFixAll <CR>" },
        ["<leader>ld"] = {
            "<cmd>LspStop<CR>",
            "Start LSP",
        },
        ["<leader>lr"] = {
            "<cmd>LspRestart<CR>",
            "Restart LSP",
        },
        ["<leader>le"] = {
            "<cmd>LspStart<CR>",
            "Stop LSP",
        },
        -- ts tool maps
        ["<leader>toi"] = {
            "<cmd>TSToolsOrganizeImports<CR>",
            "Organize Imports",
        },
        ["<leader>tai"] = {
            "<cmd>TSToolsAddMissingImports<CR>",
            "Add Missing Imports",
        },
        ["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>" },
        ["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>" },
        ["<leader>ts"] = { "<cmd>set spell!<CR>", "Toggle spell check" },

        -- telescope remaps
        ["<M-g>"] = {
            function()
                require("telescope.builtin").live_grep({
                    default_text = vim.fn.expand("<cword>"),
                })
            end,
            "Live grep current word",
        },
        ["<leader>fpk"] = {
            function()
                require("telescope").extensions.package_info.package_info()
            end,
            "Show package info",
        },
        ["<leader>fk"] = {
            function()
                require("telescope.builtin").keymaps()
            end,
            "Live grep current word",
        },
        ["<leader>ffn"] = {
            function()
                utils.addParentheses()
            end,
            "Search function under cursor",
        },
        ["<leader>frc"] = {
            function()
                utils.addAngleBracket()
            end,
            "Search component under cursor",
        },
        ["<leader>fc"] = { "<cmd>Easypick changed_files<CR>", "Show changed files" },
        ["<leader>fgc"] = { "<cmd>Easypick conflicts<CR>", "Show merge conflicts" },
        ["<leader>fh"] = { "<cmd>Easypick hidden_files<CR>", "Show hidden files" },

        ["<leader>fw"] = {
            function()
                utils.multiGrep()
            end,
            "MultiGrep",
        },
        ["<leader>fch"] = { "<cmd> Telescope command_history <CR>", "Find command history" },
        ["<leader>fp"] = { "<cmd> Telescope yank_history <CR>", "Find command history" },
        ["<leader>fss"] = { "<cmd> Telescope spell_suggest <CR>", "Find command history" },
        ["<leader>fr"] = { "<cmd> Telescope registers <CR>", "Find command history" },
        ["<leader>fs"] = { "<cmd> Telescope lsp_document_symbols <CR>", "Find command history" },
        ["<leader>gs"] = { "<cmd>Telescope lsp_workspace_symbols query=q<CR>", "Global Symbols" },
        ["<leader>fd"] = { "<cmd> Telescope diagnostics <CR>", "Find diagnostics" },
        ["<leader>ft"] = { "<cmd> TodoTelescope <CR>" },
        ["<leader>fcm"] = { "<cmd> Telescope commands <CR>", "Find command history" },
        ["<leader>flr"] = { "<cmd> Telescope lsp_references <CR>", "LSP References" },
        ["gt"] = { "<cmd> Telescope lsp_type_definitions <CR>", "Type Definations" },
        ["<leader>u"] = {
            "<cmd>Telescope undo<cr>",
            "Open undo history using Telescope",
        },
        ["<leader>fbc"] = { "<cmd>Telescope git_bcommits<CR>", "Find buffer commits" },
        ["<leader>gvh"] = { "<cmd>Gitsigns select_hunk<CR>", "Visual selection for the git hunk" },
        ["<C-p>"] = { "<cmd>Telescope find_files<CR>" },
        ["<C-g>"] = { "<cmd>Telescope git_status<CR>" },
        ["gd"] = { "<cmd>Telescope lsp_definitions<CR>", "Lsp defination" },

        ["<leader>ba"] = {
            function()
                utils.closeOtherBuffers()
            end,
            "Close all other buffers except the current one and retain position",
        },
        -- GrugFar operations
        ["<leader>gf"] = { "<cmd>GrugFar<CR>", "Open GrugFar buffer" },
        ["<leader>rw"] = {
            function()
                require("grug-far").open({
                    prefills = {
                        search = vim.fn.expand("<cword>"),
                    },
                })
            end,
            "Open GrugFar buffer with word under cursor",
        },
        ["<leader>cf"] = {
            function()
                utils.copyCurrentScopeFunction()
            end,
            "Copy the current function name (inside or at the start) to clipboard",
        },
        ["fws"] = { "1z=", "Fix word speling under cursor" },
        -- for git diff
        ["<leader>gd"] = { "<cmd> DiffviewOpen <CR>", "Open git diff" },
        ["<leader>gdc"] = { "<cmd> DiffviewClose <CR>", "Close git diff" },
        ["<leader>gdo"] = { "<cmd> DiffviewOpen <CR>", "Toggle files git diff" },

        -- basic operation remaps
        ["<leader>rc"] = {
            function()
                local word = vim.fn.expand("<cword>")
                vim.cmd("normal! ciw<" .. word .. " />")
            end,
            "Wrap word under cursor with < />",
        },
        ["<leader>gx"] = {
            function()
                local file = vim.fn.expand("<cfile>")   -- Get the file/URL under cursor
                local escaped_file = vim.fn.shellescape(file, true) -- Escape it safely
                vim.fn.system("wslview " .. escaped_file .. " &") -- Escape it safely
                vim.fn.system("wslview " .. escaped_file .. " &") -- Run in background
            end,
            "Open file with xdg-open silently",
        },
        ["<A-j>"] = { "6j", "Move 6 lines down" },
        ["<A-k>"] = { "6k", "Move 6 lines up" },
        ["<leader>ex"] = {
            "<cmd>execute 'normal! Iexport '<CR>",
            "Add 'export' at the start of the current line",
        },
        ["<leader>asc"] = {
            "<cmd>execute 'normal! Iasync '<CR>",
            "Add 'async' at the start of the current line",
        },
        ["<leader>exd"] = {
            "<cmd>execute 'normal! Iexport default '<CR>",
            "Add 'export default' at the start of the current line",
        },
        ["<leader>,"] = { "mzA,<Esc>`z", "Add comma to the end of the line" },
        ["<leader>;"] = { "mzA;<Esc>`z", "Add comma to the end of the line" },
        ["<leader>uc"] = {
            function()
                utils.addDirective("use client")
            end,
            "Add 'use client' to the top of the file",
        },
        ["<leader>sh"] = {
            function()
                utils.prepareBashFile()
            end,
            "Prepare a bash file by adding shebang and then allowing it to execute",
        },
        ["<leader>us"] = {
            function()
                utils.addDirective("use server")
            end,
            "Add 'use server' to the top of the file",
        },
        ["ul"] = { "O<Esc>:normal j<CR>", "Insert line above and move down" },
        ["dl"] = { "o<Esc>:normal k<CR>", "Insert line below and move up" },
        ["<C-sa>"] = { "<cmd> wa <CR>", "Save file" },
        ["<leader>lz"] = { "<cmd>Lazy<CR>", "Open Lazy" },
        ["dd"] = {
            function()
                -- Check if the current line is empty
                if vim.fn.getline(".") == "" then
                    -- If empty, delete the line without affecting the register
                    vim.cmd('normal! "_dd')
                else
                    -- Otherwise, delete the line normally
                    vim.cmd("normal! dd")
                end
            end,
            "cut line if it is not empty",
        },
        -- Don't copy the replaced text after pasting in visual mode
        -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
        ["pd"] = { 'o<Esc>:normal p:let @+=@0<CR>:let @"=@0<CR>', "Paste below" },
        ["pu"] = { 'O<Esc>:normal p:let @+=@0<CR>:let @"=@0<CR>', "Paste above" },
        ["DD"] = {
            [["_dd"]],
            "Delete single line without overwriting reg",
        },
        ["J"] = {
            "mzJ`z",
            "Join lines and retain cursor position",
        },
        ["<C-d>"] = {
            "<C-d>zz",
            "Half-page down and center",
        },
        ["<C-u>"] = {
            "<C-u>zz",
            "Half-page up and center",
        },
        ["n"] = {
            "nzzzv",
            "Next search result and center",
        },
        ["N"] = {
            "Nzzzv",
            "Previous search result and center",
        },
        ["<leader>sr"] = {
            [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/cgI<Left><Left><Left>]],
            "Search and replace",
        },
        ["<leader>sa"] = { "G$Vgg", "Select all" },
        ["<leader>da"] = { "G$Vgg_d" },
        ["<leader>ef"] = { "va{<ESC>" },
        ["el"] = { "$" },
        ["sl"] = { "_" },

        -- splits
        ["<leader>v"] = { "<cmd>vsplit<CR>" },
        ["<leader>s"] = { "<cmd>split<CR>" },

        -- cmd
        ["<leader>wq"] = { "<cmd>wqa!<CR>" },
        ["<leader>w"] = { "<cmd>wa<CR>" },
        ["<leader>q"] = { "<cmd>q!<CR>" },
        ["<leader>so"] = { ":source %<CR>", "Source the current file" },
        ["<leader>ya"] = { "<cmd>%y<CR>" },

        -- open files
        ["<leader>env"] = {
            function()
                utils.openOrCreateFiles({ ".env", ".env.local", "development.env" })
            end,
            "Open .env file",
        },
        ["<leader>gi"] = {
            function()
                utils.openOrCreateFiles({ ".gitignore" })
            end,
            "Open .gitignore file",
        },
        ["<leader>mk"] = {
            function()
                utils.openOrCreateFiles({ "Makefile" })
            end,
            "Open .gitignore file",
        },

        -- copy to clipboard
        ["<leader>cd"] = {
            function()
                utils.copyDiagnosticToClip()
            end,
            "Copy diagnostic to clipboard",
        },
        ["<leader>ct"] = {
            function()
                utils.copyTypeDefinition()
            end,
            "Copy type defination to clipboard",
        },
        ["<leader>cln"] = {
            function()
                local line_number = vim.fn.line(".")
                vim.fn.setreg("+", tostring(line_number))
                vim.notify("Copied line number: " .. line_number)
            end,
            "Copy current line number to clipboard",
        },

        ["<leader>b1"] = { "<cmd>buffer 1<CR>", "Select buffer 1" },
        ["<leader>b2"] = { "<cmd>buffer 2<CR>", "Select buffer 2" },
        ["<leader>b3"] = { "<cmd>buffer 3<CR>", "Select buffer 3" },
        ["<leader>b4"] = { "<cmd>buffer 4<CR>", "Select buffer 4" },
        ["<leader>b5"] = { "<cmd>buffer 5<CR>", "Select buffer 5" },
        ["<leader>b6"] = { "<cmd>buffer 6<CR>", "Select buffer 6" },
        ["<leader>b7"] = { "<cmd>buffer 7<CR>", "Select buffer 7" },
        ["<leader>b8"] = { "<cmd>buffer 8<CR>", "Select buffer 8" },
        ["<leader>b9"] = { "<cmd>buffer 9<CR>", "Select buffer 9" },
    },

    v = {
        ["<A-j>"] = { "6j", "Move 6 lines down" },
        ["<A-k>"] = { "6k", "Move 6 lines up" },
        ["<leader>w$"] = {
            'c${<C-r>"}<Esc>',
            "Wrap selection with ${} and return to normal mode",
        },
        -- NOTE: added this here because core ones were not working
        ["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>" },

        ["<leader>rw"] = {
            function()
                vim.cmd('noau normal! "vy"') -- Yank the selection into a register
                local selection = vim.fn.getreg("v"):gsub("\n", " ")
                require("grug-far").open({
                    prefills = {
                        search = selection,
                    },
                })
            end,
            "Open GrugFar buffer with word under cursor",
        },

        ["<leader>gw"] = {
            function()
                vim.cmd('noau normal! "vy"') -- Yank the selection into a register
                local selection = vim.fn.getreg("v"):gsub("\n", " ")
                require("telescope.builtin").live_grep({
                    default_text = selection,
                })
            end,
            "Live grep visual selection",
        },

        ["<leader>d"] = {
            [["_d"]],
            "Delete without overwriting register",
        },
        ["<"] = { "<gv" },
        [">"] = { ">gv" },
        ["J"] = {
            ":m '>+1<CR>gv=gv",
            "Move selected lines down",
        },
        ["K"] = {
            ":m '<-2<CR>gv=gv",
            "Move selected lines up",
        },
    },

    x = {
        ["<A-j>"] = { "6j", "Move 6 lines down" },
        ["<A-k>"] = { "6k", "Move 6 lines up" },
        ["<leader>rr"] = {
            function()
                require("telescope").extensions.refactoring.refactors()
            end,
            "Open refactoring options with Telescope",
        },

        ["DD"] = {
            [["_d"]],
            "Delete without overwriting register",
        },
        ["<M-pp>"] = {
            [["_dP"]],
            "Paste without overwriting register",
        },
    },

    i = {
        ["<S-Tab>"] = { "<C-w>" },
        ["<C-h>"] = { "<C-w>" },
    },
}

return M
