-- Neovim 0.11+ LSP Configuration using vim.lsp.config() and vim.lsp.enable()

-- Disable LSP semantic tokens (they override treesitter but have no colors defined)
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local servers = {
			"gopls",
			"basedpyright",
			"pyright",
			"ruff",
			"rust_analyzer",
			-- "ts_ls",
			"vtsls",
			"cssls",
			"tailwindcss",
			"svelte",
			"sqls",
			"yamlls",
			"jsonls",
			"bashls",
			"dockerls",
			"marksman",
		}
		if client and not vim.tbl_contains(servers, client.name) then
			client.server_capabilities.semanticTokensProvider = nil
		end
	end,
})

-- Set global defaults for ALL LSP servers
vim.lsp.config("*", {
	root_markers = { ".git" },
})

-- Auto-setup for all Mason-installed servers
require("mason-lspconfig").setup({
	automatic_installation = true,
	handlers = {
		function(server_name)
			-- Temporarily skip css_variables for debugging
			if server_name == "css_variables" then
				return
			end
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
-- vim.lsp.config("ts_ls", {
-- 	root_markers = { "package.json", "tsconfig.json", ".git" },
-- 	settings = {
-- 		completions = {
-- 			completeFunctionCalls = false,
-- 		},
-- 		typescript = {
-- 			inlayHints = {
-- 				includeInlayParameterNameHints = "all",
-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
-- 				includeInlayFunctionParameterTypeHints = true,
-- 				includeInlayVariableTypeHints = true,
-- 				includeInlayPropertyDeclarationTypeHints = true,
-- 				includeInlayFunctionLikeReturnTypeHints = true,
-- 				includeInlayEnumMemberValueHints = true,
-- 			},
-- 		},
-- 		javascript = {
-- 			inlayHints = {
-- 				includeInlayParameterNameHints = "all",
-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
-- 				includeInlayFunctionParameterTypeHints = true,
-- 				includeInlayVariableTypeHints = true,
-- 				includeInlayPropertyDeclarationTypeHints = true,
-- 				includeInlayFunctionLikeReturnTypeHints = true,
-- 				includeInlayEnumMemberValueHints = true,
-- 			},
-- 		},
-- 	},
-- })

vim.lsp.config("vtsls", {
	root_markers = { "package.json", "tsconfig.json", ".git" },
	settings = {
		typescript = {
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
		javascript = {
			inlayHints = {
				parameterNames = { enabled = "all" },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				enumMemberValues = { enabled = true },
			},
		},
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				completion = {
					enableServerSideFuzzyMatch = true,
					entriesLimit = 50,
				},
			},
		},
	},
})
vim.lsp.enable("vtsls")


-- Custom configuration for sqls (SQL language server)
vim.lsp.config("sqls", {
	root_markers = { ".git" },
	filetypes = { "sql", "mysql", "plsql" },
})

-- Make bashls work for .zshrc/.zsh files too
vim.lsp.config("bashls", {
	filetypes = { "bash", "sh", "zsh" },
	settings = {
		bashIde = {
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command|.zsh|.zshrc)",
		},
	},
})

-- Explicit configuration for gopls to enable semantic tokens
vim.lsp.config("gopls", {
	settings = {
		gopls = {
			["ui.semanticTokens"] = true,
		},
	},
})

-- Enable gopls manually if not handled by Mason (mason-lspconfig handles it, but this won't hurt)
vim.lsp.enable("gopls")
