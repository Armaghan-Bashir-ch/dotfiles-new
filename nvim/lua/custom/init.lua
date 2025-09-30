local opt = vim.opt                                                                                    -- Shortcut alias for Neovim's option settings

opt.relativenumber = true                                                                              -- Adding Relative Line Numbers to be turned on every single time on starup
vim.opt.expandtab = true                                                                               -- Convert tabs to spaces
vim.opt.tabstop = 4                                                                                    -- Number of spaces a tab represents
vim.opt.shiftwidth = 4                                                                                 -- Number of spaces for autoindent
vim.opt.showtabline = 0                                                                                -- Disables file tab names at the top, don't know the right name for it
vim.opt.cmdheight = 1                                                                                  -- Sets the Command Line height to be one line above the bottom edge
vim.opt.wrap = false                                                                                   -- Sets the wrap to be false, still deciding on whether to leave it enabled or not
vim.opt.cursorline = false                                                                             -- Disables the annoying highlight line on the current line that I am on, helps me with keeping my focus
vim.g.fancyScroll = true                                                                               -- Disabling fancy scroll, fancy scroll is basically replacement of control+d/u but with the mice
vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE" })                                                     -- Needed for the lastest --version of nvim (0.11.4)
vim.opt.statusline = "%#ModeBright# %{mode()}%=%f %y"                                                  -- Why doesn't this work?
vim.opt.laststatus = 2                                                                                 -- always show statusline
vim.g.nvchad_hot_reload = false                                                                        -- Don't automatically reload the NvChad config. You'll have to restart Neovim to see your changes.
vim.g.lazyvim_prettier_needs_config = false                                                            -- Run Prettier without requiring a config file
vim.g.auto_ai = false                                                                                  -- Disable automatic AI completions/integrations out of the box, nobody needs AI
vim.g.customBigFileOpt = true                                                                          -- Enable custom optimizations for large files
vim.o.swapfile = false                                                                                 -- Disable creation of swap files
vim.g.disableFormat = false                                                                            -- Keep code formatting enabled
vim.o.sessionoptions =
"blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"                        -- Define what gets saved/restored in a Vim session
vim.api.nvim_set_hl(0, "CursorLineNr", { underline = false, undercurl = false })                       -- Remove underline/undercurl from the line number of the current cursor line
vim.api.nvim_set_hl(0, "CursorLine", { underline = false, undercurl = false })                         -- Remove underline/undercurl from the background of the current cursor line
-- opt.foldmethod = "expr"
-- opt.foldlevelstart = 99
-- opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.keymap.set("n", "<C-Tab>", function()
    require("harpoon"):list():next()
end, { desc = "Next Harpoon file" })

vim.api.nvim_create_augroup("PasteRemoveCarriageReturn", { clear = true })
vim.g.maplocalleader = ","

-- adds .env to sh group
vim.cmd([[
  autocmd BufRead,BufNewFile *.env* set filetype=sh
]])
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = "#1e1e2e", bg = "#89b4fa", bold = true })
    end,
})

vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- Remove carriage returns after pasting in normal mode
vim.api.nvim_create_autocmd("VimEnter", {
    group = "PasteRemoveCarriageReturn",
    callback = function()
        vim.cmd([[
      nnoremap <silent> P :execute "normal! P" <bar> silent! %s/\r//g<CR>
      nnoremap <silent> p :execute "normal! p" <bar> silent! %s/\r//g<CR>
    ]])
    end,
})

-- Remove carriage returns after pasting in insert mode
-- nnoremap <silent> <C-r> :execute "normal! <C-r>" <bar> silent! %s/\r//g<CR>
vim.api.nvim_create_autocmd("InsertLeave", {
    group = "PasteRemoveCarriageReturn",
    callback = function()
        vim.cmd([[
      silent! %s/\r//g
    ]])
    end,
})

-- Define autocmd group
vim.cmd([[
  augroup LineNumberToggle
    autocmd!
    autocmd InsertLeave * setlocal relativenumber
    autocmd InsertEnter * setlocal norelativenumber
  augroup END
]])

local highLightClr = "#3e4451"

-- set highlight color as this
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    group = vim.api.nvim_create_augroup("Color", {}),
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "LspReferenceRead", { fg = highLightClr })
        vim.api.nvim_set_hl(0, "LspReferenceWrite", { fg = highLightClr })
        vim.api.nvim_set_hl(0, "LspReferenceText", { fg = highLightClr })
    end,
})

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd([[
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=300})
  augroup END
]])

vim.api.nvim_create_augroup("Shape", { clear = true })
vim.api.nvim_create_autocmd("VimLeave", {
    group = "Shape",
    -- this is for underscore
    command = "set guicursor=a:hor30",
})

local uv = vim.loop

vim.api.nvim_create_autocmd({ "VimEnter", "VimLeave" }, {
    callback = function()
        if vim.env.TMUX_PLUGIN_MANAGER_PATH then
            uv.spawn(vim.env.TMUX_PLUGIN_MANAGER_PATH .. "/tmux-window-name/scripts/rename_session_windows.py", {})
        end
    end,
})

-- vim.api.nvim_create_autocmd("CmdlineEnter", {
--     callback = function()
--         vim.api.nvim_set_keymap("c", "<CR>", "<CR>", { noremap = true, silent = true })
--     end,
-- })

function TestLearningLsp()
    local client = vim.lsp.start_client({
        name = "learninglsp",
        cmd = { basePath .. "/main" },
        on_attach = require("plugins.configs.lspconfig").on_attach,
    })

    if not client then
        vim.notify("Failed to start LSP client: learninglsp", vim.log.levels.ERROR)
        return
    end

    vim.lsp.buf_attach_client(0, client)

    vim.notify("LSP client 'learninglsp' successfully started and attached!", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command(
    "TestLearningLsp", -- The command name
    function()
        TestLearningLsp()
    end,
    { desc = "Test the custom LSP client: learninglsp" } -- Optional description
)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "hyprlang",
    callback = function()
        vim.schedule(function()
            pcall(vim.cmd, "TSBufDisable highlight")
        end)
    end,
})

local eslint_active = false

vim.api.nvim_create_user_command("ToggleESLint", function()
    eslint_active = not eslint_active
    if eslint_active then
        vim.lsp.start_client({ name = "eslint" })
        print("ESLint enabled")
    else
        vim.lsp.stop_client(vim.lsp.get_active_clients({ name = "eslint" })[1].id)
        print("ESLint disabled")
    end
end, {})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        local filetypes = { "sql", "mysql", "psql" }
        if vim.tbl_contains(filetypes, vim.bo.filetype) then
            vim.bo.commentstring = "-- %s"
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "nvcheatsheet", "neo-tree", "dbui", "dbee" },
    callback = function()
        require("ufo").detach()
        vim.opt_local.foldenable = false
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname:match("env") then
            vim.lsp.stop_client(vim.lsp.get_clients({ bufnr = 0 }))
        end
    end,
})

vim.keymap.set("n", "<leader>y", "<cmd>Telescope yank_history<CR>", { desc = "Yank history" })

vim.api.nvim_create_autocmd("BufReadPre", {
    pattern = "*",
    desc = "Disable features on big files",
    callback = function(args)
        local bufnr = args.buf
        local size = vim.fn.getfsize(vim.fn.expand("%"))
        local max_filesize = 500 * 1024

        if size < max_filesize or not vim.g.customBigFileOpt then
            return
        end

        vim.b[bufnr].bigfile_disable = true

        -- Set up Treesitter module disable
        local module = require("nvim-treesitter.configs").get_module("indent")
        module.disable = function(lang, bufnr)
            return vim.b[bufnr].bigfile_disable == true
        end

        -- Disable autoindent
        vim.bo.indentexpr = ""
        vim.bo.autoindent = false
        vim.bo.smartindent = false
        -- Disable folding
        vim.opt_local.foldmethod = "manual"
        vim.opt_local.foldexpr = "0"
        -- Disable statuscolumn
        vim.opt_local.statuscolumn = ""
        -- Disable search highlight
        vim.opt_local.hlsearch = false
        -- Disable line wrapping
        -- Disable cursorline
        vim.opt_local.cursorline = false
        -- Disable swapfile
        vim.opt_local.swapfile = false
        -- Disable spell checking
        vim.opt_local.spell = false
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        for _, client in pairs((vim.lsp.get_clients({}))) do
            if client.name == "tailwindcss" then
                client.server_capabilities.completionProvider.triggerCharacters =
                { '"', "'", "`", ".", "(", "[", "!", "/", ":" }
            end
        end
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv()[0]) == 1 then
            vim.cmd("silent bwipeout") -- Close any loaded buffers
            vim.cmd("enew")   -- Create new empty buffer to trigger btw.nvim banner
        end
    end,
})
