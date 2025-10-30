return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre", -- uncomment for format on save
		opts = require("configs.conform"),
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufWritePre", "BufNewFile" },
		config = function()
			require("configs.lspconfig")
		end,
	},

	{
		import = "nvchad.blink.lazyspec",
		cmdline = {
			enabled = true,
			sources = { "cmdline", "path", "buffer" },
		},

		completion = {
			enable_in_comment = false,
			enable_in_string = false,
			trigger_chars = { ".", ":", "->", "{", "(" },
		},

		menu = {
			auto_show = true,
			draw = {
				columns = {
					{ "kind_icon", "label", "label_description", gap = 1 },
					{ "source_name" },
				},
				separator = " • ",
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 300,
				window = {
					max_width = 80,
					border = "rounded",
				},
			},
		},
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
			},
		},
		snippets = {
			preset = "luasnip",
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		signature = {
			enabled = true,
			trigger = { enabled = true, trigger_chars = { "(", "," } },
			window = {
				border = "rounded",
			},
		},
	},

	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup()
			vim.diagnostic.config({ virtual_text = false, underline = true }) -- Disable Neovim's default virtual text diagnostics
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local theme_file = vim.fn.stdpath("data") .. "/last_colorscheme.txt"
			local saved_variant = "moon"

			local file = io.open(theme_file, "r")
			if file then
				local saved = file:read("*l")
				file:close()
				if saved and saved:match("^tokyonight%-") then
					saved_variant = saved:match("^tokyonight%-(.+)$") or "moon"
				end
			end

			require("tokyonight").setup({
				style = saved_variant,
				transparent = false,
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("configs.bufferline")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
				"python",
				"typescript",
				"javascript",
				"json",
				"markdown",
				"markdown_inline",
				"bash",
				"c",
				"cpp",
				"rust",
				"go",
				"yaml",
				"toml",
			},
		},
	},

	{ "chentoast/marks.nvim", event = "VeryLazy", opts = {} },

	{
		"rachartier/tiny-glimmer.nvim",
		event = "VeryLazy",
		priority = 10,
		opts = {},
	},

	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},

	{
		"FabijanZulj/blame.nvim",
		lazy = true,
		config = function()
			require("blame").setup({})
		end,
	},

	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {
			focus = true,
			modes = {
				diagnostics = {
					decorators = {
						line = true,
						indent = true,
					},
				},
			},
		},
		focus = true,
	},

	{ "wakatime/vim-wakatime", lazy = "VeryLazy" },

	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},

	{ "tpope/vim-dadbod" },

	{ "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },

	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
	},

	-- debugger
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			require("configs.dap")
		end,
	},

	{
		"nanotee/sqls.nvim",
		vim.lsp.enable("sqls"),
	},

	-- Copilot core (auth + backend)
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {},
				},
				panel = { enabled = true },
			})
		end,
	},

	-- Copilot Chat
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		build = "make tiktoken",
		opts = {},
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			completions = { lsp = { enabled = true } },
		},
		event = "VeryLazy",
	},
}
