local on_attach = require("plugins.configs.lspconfig").on_attach
local preDefinedCapabilities = require("plugins.configs.lspconfig").capabilities
local capabilities = require("blink.cmp").get_lsp_capabilities(preDefinedCapabilities)

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}


local util = require "lspconfig/util"

-- Disable formatting for tailwindcss and cssls
local function disable_formatting(client)
  if client.name == "tailwindcss" or client.name == "cssls" then
    client.server_capabilities.documentFormattingProvider = false
  end
end

vim.lsp.config('gopls', {
  on_attach = function(client, bufnr)
    disable_formatting(client) -- Disable formatting for specific servers
    on_attach(client, bufnr)
  end,
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
      },
    },
  },
})
vim.lsp.enable('gopls')

vim.lsp.config('marksman', {
  on_attach = function(client, bufnr)
    disable_formatting(client) -- Disable formatting for specific servers
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  filetypes = { "markdown" },
})
vim.lsp.enable('marksman')

vim.lsp.config('bashls', {
  on_attach = function(client, bufnr)
    disable_formatting(client) -- Disable formatting for specific servers
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  filetypes = { "sh", "bash", ".zshrc", ".bashrc" },
})
vim.lsp.enable('bashls')

vim.lsp.config('pyright', {
  on_attach = function(client, bufnr)
    disable_formatting(client) -- Disable formatting for specific servers
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  filetypes = { "python" },
})
vim.lsp.enable('pyright')

vim.lsp.config('emmet_language_server', {
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
vim.lsp.enable('emmet_language_server')

vim.lsp.config('clangd', {
  on_attach = function(client, bufnr)
    client.server_capabilities_signatureHelpProvider = false
    disable_formatting(client) -- Disable formatting for specific servers
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
})
vim.lsp.enable('clangd')

vim.lsp.config('jsonls', {
  on_attach = function(client, bufnr)
    disable_formatting(client) -- Disable formatting for specific servers
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  -- on_new_config = function(new_config)
  --   new_config.settings.json.schemas = new_config.settings.json.schemas or {}
  --   vim.list_extend(new_config.settings.json.schemas, schemastore.json.schemas())
  -- end,
  settings = {
    json = {
      format = {
        enable = true, -- Enable JSON formatting
      },
      validate = {
        enable = true, -- Enable JSON validation
      },
    },
  },
})
vim.lsp.enable('jsonls')

vim.lsp.config('sqls', {
  on_attach = function(client, bufnr)
    disable_formatting(client)
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  cmd = { "sqls" },
  filetypes = { "sql", "mysql", "plsql" },
  settings = {
    sqls = {},
  },
})
vim.lsp.enable('sqls')

vim.lsp.config('svelte', {
  cmd = { "svelteserver", "--stdio" },
  filetypes = { "svelte" },
  root_dir = util.root_pattern("package.json", ".git"),
})
vim.lsp.enable('svelte')

-- lspconfig.denols.setup {
--   on_attach = on_attach,
--   root_dir = util.root_pattern("deno.json", "deno.jsonc"),
-- }

vim.lsp.config('cssls', {
  filetypes = { "css", "html", "less", "sass", "scss", "pug" },
  on_attach = function(client, bufnr)
    disable_formatting(client) -- Disable formatting for specific servers
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
})
vim.lsp.enable('cssls')

vim.lsp.config('tailwindcss', {
  -- filetypes = { "css", "html", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact", "svelte" },
  filetypes = { "css", "html", "javascriptreact", "less", "sass", "scss", "pug", "svelte" },
  on_attach = function(client, bufnr)
    disable_formatting(client)
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
})
vim.lsp.enable('tailwindcss')

vim.lsp.config('asm_lsp', {
  on_attach = function(client, bufnr)
    disable_formatting(client) -- Disable formatting if desired
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  filetypes = { "asm", "s", "S" }, -- Common assembly file extensions
})
vim.lsp.enable('asm_lsp')
