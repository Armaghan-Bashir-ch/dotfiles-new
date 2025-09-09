local null_ls = require "null-ls"

local opts = {
  sources = {
    null_ls.builtins.formatting.gofumpt.with { temp_dir = "/tmp" },
    null_ls.builtins.formatting.goimports_reviser.with { temp_dir = "/tmp" },
    null_ls.builtins.formatting.golines.with { temp_dir = "/tmp" },
    null_ls.builtins.formatting.black.with {
      filetypes = { "python" },
    },
    null_ls.builtins.diagnostics.mypy.with {
      filetypes = { "python" },
    },
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.sqlfmt,
    -- WARNING: these donot work for some reason
    -- null_ls.builtins.diagnostics.marksman,
    -- null_ls.builtins.diagnostics.checkmake,
    -- null_ls.builtins.diagnostics.ruff,
    -- null_ls.builtins.formatting.beautysh,
    -- null_ls.builtins.diagnostics.eslint,
  },
  on_attach = function(client, bufnr)
    local filetype = vim.bo[bufnr].filetype

    local disabled_filetypes = { "sql", "tsx" }

    local is_disabled_filetype = vim.tbl_contains(disabled_filetypes, filetype)

    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local block_large_file_format = vim.g.customBigFileOpt and line_count > 3500

    local no_format_needed = not client.supports_method "textDocument/formatting"
        or block_large_file_format
        or is_disabled_filetype
        or vim.g.disableFormat

    if no_format_needed then
      return
    end

    vim.api.nvim_clear_autocmds {
      group = augroup,
      buffer = bufnr,
    }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { bufnr = bufnr }
      end,
    })
  end,
}
return opts
