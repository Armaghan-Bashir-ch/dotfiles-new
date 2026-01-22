local null_ls = require("null-ls")

local opts = {
	sources = {
		null_ls.builtins.formatting.gofumpt.with({ temp_dir = "/tmp" }),
		null_ls.builtins.formatting.goimports_reviser.with({ temp_dir = "/tmp" }),
		null_ls.builtins.formatting.golines.with({ temp_dir = "/tmp" }),
		null_ls.builtins.formatting.gofmt,

		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.diagnostics.mypy,

		null_ls.builtins.formatting.clang_format,

		null_ls.builtins.formatting.stylua,

		null_ls.builtins.formatting.sqlfmt,

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

		null_ls.builtins.formatting.prettierd.with({
			filetypes = { "svelte" },
		}),

		null_ls.builtins.formatting.shfmt,
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
