local null_ls = require("null-ls")

local opts = {
    sources = {
        -- Go
        null_ls.builtins.formatting.gofumpt.with({ temp_dir = "/tmp" }),
        null_ls.builtins.formatting.goimports_reviser.with({ temp_dir = "/tmp" }),
        null_ls.builtins.formatting.golines.with({ temp_dir = "/tmp" }),
        -- Python
        null_ls.builtins.formatting.black.with({
            filetypes = { "python" },
        }),
        null_ls.builtins.diagnostics.mypy.with({
            filetypes = { "python" },
        }),
        -- C/C++
        null_ls.builtins.formatting.clang_format,
        -- Lua
        null_ls.builtins.formatting.stylua,
        -- SQL
        null_ls.builtins.formatting.sqlfmt,
        -- JavaScript/TypeScript/HTML/CSS/JSON/Markdown (via prettierd)
        null_ls.builtins.formatting.prettierd.with({
            filetypes = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
                "vue",
                "css",
                "scss",
                "less",
                "html",
                "json",
                "jsonc",
                "markdown",
                "mdx",
                "yaml",
                "xml",
                "toml",
            },
        }),
        -- Svelte (prettier handles this too)
        null_ls.builtins.formatting.prettierd.with({
            filetypes = { "svelte" },
        }),
    },
    on_attach = function(client, bufnr)
        local filetype = vim.bo[bufnr].filetype

        local disabled_filetypes = { "sql", "tsx", "markdown", "marksman" }

        local is_disabled_filetype = vim.tbl_contains(disabled_filetypes, filetype)

        local line_count = vim.api.nvim_buf_line_count(bufnr)
        local block_large_file_format = vim.g.customBigFileOpt and line_count > 3500

        local no_format_needed = not client:supports_method("textDocument/formatting")
            or block_large_file_format
            or is_disabled_filetype
            or vim.g.disableFormat

        if no_format_needed then
            return
        end

        local augroup = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })

        vim.api.nvim_clear_autocmds({
            group = augroup,
            buffer = bufnr,
        })

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, async = false })
            end,
        })
    end,
}
return opts
