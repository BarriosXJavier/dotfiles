-- Auto-setup for all Mason-installed servers
require("mason-lspconfig").setup({
	automatic_installation = true,
	handlers = {
		function(server_name)
			vim.lsp.enable(server_name)
		end,
	},
})

-- Custom configurations for specific servers
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
		triggerCharacters = { ">", ".", "#", "*", "(", "[", "{" },
	},
})

vim.lsp.enable("emmet_language_server")
