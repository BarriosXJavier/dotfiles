return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre", -- uncomment for format on save
		opts = require("configs.conform"),
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("configs.lspconfig")
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
			},
		},
	},

	{
		"folke/tokyonight.nvim",
		style = "storm",
		lazy = false,
		priority = 1000,
		opts = {},
	},

	{ "chentoast/marks.nvim", event = "VeryLazy", opts = {} },

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
		lazy = false,
		config = function()
			require("blame").setup({})
		end,
	},

	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = { focus = true },
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions/References",
			},
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
		},

		focus = true,
	},

	{ "wakatime/vim-wakatime", lazy = false },

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
		keys = {
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "undotree" },
		},
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

	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
			{ "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
			"windwp/nvim-autopairs",
		},
		config = require("configs.nvim-cmp").setup,
		opts = require("configs.nvim-cmp").opts,
	},

	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lspsaga").setup({
				ui = {
					border = "rounded",
					title = true,
					winblend = 10,
					devicon = true,
				},
				lightbulb = { enable = false },
			})
			vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { noremap = true, silent = true })
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		event = { "VimEnter", "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require("configs.lualine").setup,
	},
}
