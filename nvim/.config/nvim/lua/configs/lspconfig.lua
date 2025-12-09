-- Neovim 0.11+ LSP Configuration using vim.lsp.config() and vim.lsp.enable()

-- Set global defaults for ALL LSP servers
vim.lsp.config("*", {
	root_markers = { ".git" },
})

-- Auto-setup for all Mason-installed servers
require("mason-lspconfig").setup({
	automatic_installation = true,
	handlers = {
		function(server_name)
			-- Enable each server installed by Mason
			vim.lsp.enable(server_name)
		end,
	},
})

-- Custom configuration for emmet_language_server
vim.lsp.config("emmet_language_server", {
	cmd = { "emmet-language-server", "--stdio" },
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
	root_markers = { ".git" },
	settings = {
		includeLanguages = {},
		excludeLanguages = {},
		extensionsPath = {},
		preferences = {},
		showAbbreviationSuggestions = true,
		showExpandedAbbreviation = "always",
		showSuggestionsAsSnippets = true,
		syntaxProfiles = {},
		variables = {},
	},
})

-- Enable emmet_language_server manually
vim.lsp.enable("emmet_language_server")

-- Custom configuration for TypeScript servers
vim.lsp.config("ts_ls", {
	root_markers = { "package.json", "tsconfig.json", ".git" },
	settings = {
		completions = {
			completeFunctionCalls = true,
		},
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		},
	},
})

-- Custom configuration for sqls (SQL language server)
vim.lsp.config("sqls", {
	root_markers = { ".git" },
	filetypes = { "sql", "mysql", "plsql" },
})
