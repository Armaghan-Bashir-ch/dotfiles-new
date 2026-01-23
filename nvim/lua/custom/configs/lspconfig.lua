local on_attach = require("plugins.configs.lspconfig").on_attach
local preDefinedCapabilities = require("plugins.configs.lspconfig").capabilities
local capabilities = require("blink.cmp").get_lsp_capabilities(preDefinedCapabilities)

capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

capabilities.textDocument.completion.completionItem = {
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

local util = require("lspconfig/util")

local function disable_formatting(client)
	if client.name == "tailwindcss" or client.name == "cssls" or client.name == "emmet_language_server" then
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end
end

local function enhance_on_attach(client, bufnr)
	disable_formatting(client)
	on_attach(client, bufnr)

	vim.keymap.set("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, { buffer = bufnr, desc = "Code actions" })

	vim.keymap.set("n", "<leader>dl", function()
		vim.diagnostic.open_float({ border = "rounded", scope = "line" })
	end, { buffer = bufnr, desc = "Line diagnostics" })

	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next({ float = { border = "rounded" } })
	end, { buffer = bufnr, desc = "Next diagnostic" })

	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev({ float = { border = "rounded" } })
	end, { buffer = bufnr, desc = "Previous diagnostic" })

	vim.keymap.set("n", "<leader>dd", function()
		require("telescope.builtin").diagnostics({ bufnr = 0 })
	end, { buffer = bufnr, desc = "Document diagnostics" })

	vim.keymap.set("n", "<leader>dD", function()
		require("telescope.builtin").diagnostics()
	end, { buffer = bufnr, desc = "Workspace diagnostics" })
end

vim.lsp.config("gopls", {
	on_attach = enhance_on_attach,
	capabilities = capabilities,
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
				nilness = true,
				unusedvariable = true,
			},
			gofumpt = true,
			codelenses = {
				generate = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
			},
		},
	},
})
vim.lsp.enable("gopls")

vim.lsp.config("markdown_oxide", {
	on_attach = enhance_on_attach,
	capabilities = capabilities,
	cmd = { "markdown-oxide" },
})
vim.lsp.enable("markdown_oxide")

vim.lsp.config("bashls", {
	on_attach = enhance_on_attach,
	capabilities = capabilities,
	filetypes = { "sh", "bash", ".zshrc", ".bashrc" },
	settings = {
		bashIde = {
			globPattern = "*@(.sh|.bash|.zsh|.bashrc|.zshrc)",
		},
	},
})
vim.lsp.enable("bashls")

vim.lsp.config("pyright", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "python" },
})
vim.lsp.enable("pyright")

vim.lsp.config("emmet_language_server", {
	filetypes = { "css", "html", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact", "svelte" },
	init_options = {
		includeLanguages = {},
		excludeLanguages = {},
		extensionsPath = {},
		preferences = {},
		showAbbreviationSuggestions = true,
		showExpandedAbbreviation = "always",
		showSuggestionsAsSnippets = false,
		syntaxProfiles = {},
		variables = {},
	},
})
vim.lsp.enable("emmet_language_server")

vim.lsp.config("clangd", {
	on_attach = function(client, bufnr)
		client.server_capabilities.signatureHelpProvider = false
		enhance_on_attach(client, bufnr)
	end,
	capabilities = capabilities,
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
	root_dir = util.root_pattern("compile_commands.json", "CMakeLists.txt", ".git"),
	settings = {
		clangd = {
			arguments = {
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
			},
		},
	},
})
vim.lsp.enable("clangd")

vim.lsp.config("jsonls", {
	on_attach = enhance_on_attach,
	capabilities = capabilities,
	settings = {
		json = {
			format = { enable = true },
			validate = { enable = true },
		},
	},
})
vim.lsp.enable("jsonls")

vim.lsp.config("sqls", {
	on_attach = enhance_on_attach,
	capabilities = capabilities,
	cmd = { "sqls" },
	filetypes = { "sql", "mysql", "plsql" },
	settings = {
		sqls = {
			databases = {
				{
					driver = "postgresql",
					dataSourceName = "host=localhost port=5432 user=postgres password= dbname=postgres sslmode=disable",
				},
			},
			diagFlow = true,
		},
	},
})
vim.lsp.enable("sqls")

vim.lsp.config("svelte", {
	cmd = { "svelteserver", "--stdio" },
	filetypes = { "svelte" },
	root_dir = util.root_pattern("package.json", ".git"),
	on_attach = enhance_on_attach,
	capabilities = capabilities,
	settings = {
		svelte = {
			language = {
				typescript = {
					enable = true,
				},
			},
			completions = {
				emmet = true,
			},
			hover = true,
			formatting = {
				enable = false,
			},
		},
	},
})
vim.lsp.enable("svelte")

vim.lsp.config("cssls", {
	filetypes = { "css", "html", "less", "sass", "scss", "pug" },
	on_attach = enhance_on_attach,
	capabilities = capabilities,
	settings = {
		css = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
		scss = {
			validate = true,
		},
		less = {
			validate = true,
		},
	},
})
vim.lsp.enable("cssls")

vim.lsp.config("tailwindcss", {
	filetypes = { "css", "html", "javascriptreact", "less", "sass", "scss", "pug", "svelte", "typescriptreact", "vue" },
	on_attach = enhance_on_attach,
	capabilities = capabilities,
	settings = {
		tailwindCSS = {
			validate = true,
			experimental = {
				classRegex = {
					{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
					{ "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
				},
			},
			hints = true,
		},
	},
})
vim.lsp.enable("tailwindcss")

vim.lsp.config("asm_lsp", {
	on_attach = enhance_on_attach,
	capabilities = capabilities,
	filetypes = { "asm", "s", "S" },
})
vim.lsp.enable("asm_lsp")

vim.lsp.config("html", {
	on_attach = enhance_on_attach,
	capabilities = capabilities,
	filetypes = { "html", "htmldjango" },
	root_dir = util.root_pattern(".git", "package.json"),
	settings = {
		html = {
			autoClosingTags = true,
			autoCreateQuotes = true,
			suggest = {
				autoClosingTags = true,
			},
		},
	},
})
vim.lsp.enable("html")

vim.lsp.config("lemminx", {
	on_attach = enhance_on_attach,
	capabilities = capabilities,
	cmd = { "lemminx" },
	filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
	root_dir = util.root_pattern(".git", "pom.xml", "build.xml"),
	settings = {
		xml = {
			format = {
				enabled = true,
			},
			validation = {
				schema = true,
			},
		},
	},
})
vim.lsp.enable("lemminx")

-- ts_ls disabled due to conflict with typescript-tools plugin
-- vim.lsp.config("ts_ls", {
-- 	on_attach = enhance_on_attach,
-- 	capabilities = capabilities,
-- 	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
-- 	root_dir = util.root_pattern("package.json", "tsconfig.json", ".git"),
-- 	settings = {
-- 		typescript = {
-- 			inlayHints = {
-- 				includeInlayParameterNameHints = "all",
-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
-- 				includeInlayFunctionParameterTypeHints = true,
-- 				includeInlayVariableTypeHints = true,
-- 				includeInlayPropertyDeclarationTypeHints = true,
-- 				includeInlayEnumMemberValueHints = true,
-- 			},
-- 			format = { enable = true },
-- 			suggest = {
-- 				autoImports = true,
-- 				includeCompletionsForModuleExports = true,
-- 			},
-- 		},
-- 		javascript = {
-- 			inlayHints = {
-- 				includeInlayParameterNameHints = "all",
-- 				includeInlayFunctionParameterTypeHints = true,
-- 				includeInlayVariableTypeHints = true,
-- 				includeInlayPropertyDeclarationTypeHints = true,
-- 			},
-- 		},
-- 	},
-- })
-- vim.lsp.enable("ts_ls")

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
		source = "if_many",
		format = function(diagnostic)
			if diagnostic.code then
				return diagnostic.message .. " [" .. tostring(diagnostic.code) .. "]"
			end
			return diagnostic.message
		end,
	},
	signs = {
		priority = 20,
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})
