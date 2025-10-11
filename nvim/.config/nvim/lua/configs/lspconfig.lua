local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "clangd",
  "pyright",
  "rust_analyzer",
  "tailwindcss",
  "bashls",
  "gopls",
  "dockerls",
  "yamlls",
  "jsonls",
  "marksman",
  "lua_ls",
  "jdtls",
  "dartls",
  "zls",
  "sqls",
  "graphql",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.emmet_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "css",
    "eruby",
    "html",
    "javascriptreact",
    "less",
    "sass",
    "scss",
    "pug",
    "typescriptreact",
  },
  init_options = {
    includeLanguages = {},
    excludeLanguages = {},
    extensionsPath = {},
    preferences = {},
    showAbbreviationSuggestions = true,
    showExpandedAbbreviation = "always",
    showSuggestionsAsSnippets = true, -- important for Blink & luasnip
    syntaxProfiles = {},
    variables = {},
    triggerCharacters = { ">", ".", "#", "*", "(", "[", "{" },
  },
}

