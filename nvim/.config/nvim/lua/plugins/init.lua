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
		},

		menu = {
			auto_show = true,

			draw = {
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind", "source_name" },
				},
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
		},

		experimental = {
			ghost_text = true,
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		lazy = false,
		priority = 1000,
		config = function()
			require("bufferline").setup({
				options = {
					offsets = {
						{
							filetype = "NvimTree",
							text = "NvimTree",
							text_align = "center",
							separator = true,
						},
					},
					separator_style = { "", "" },
					show_buffer_close_icons = true,
					show_close_icon = true,
					diagnostics = "nvim_lsp",
				},
			})
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

	{ "chentoast/marks.nvim", event = "VeryLazy", opts = {} },

	{
		"rachartier/tiny-glimmer.nvim",
		event = "VeryLazy",
		priority = 10, -- Needs to be a really low priority, to catch others plugins keybindings.
		opts = {
			-- your configuration
		},
	},

	{ "mbbill/undotree", event = "VeryLazy" },

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

	-- Copilot core (auth + backend)
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false }, -- disable inline if using cmp
				panel = { enabled = true },
			})
		end,
	},

	-- Bridge Copilot to nvim-cmp
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
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
		"okuuva/auto-save.nvim",
		version = "^1.0.0", -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
		cmd = "ASToggle", -- optional for lazy loading on command
		event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
		opts = {
			debounce_delay = 1000,
		},
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
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "moon", -- options: storm, night, moon, day
				transparent = true, -- or true if you like the terminal background showing
				terminal_colors = true, -- apply the same palette to terminals
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
				},
			})
			vim.cmd("colorscheme tokyonight-moon")
		end,
	},
	{
		"xiyaowong/transparent.nvim",
		lazy = false,
		config = function()
			require("transparent").setup({
				extra_groups = {
					"Normal",
					"NormalNC",
					"NormalFloat",
					"FloatBorder",
					"TelescopeNormal",
					"TelescopeBorder",
					"NvimTreeWinSeparator",
					"NvimTreeNormal",
					"NvimTreeNormalNC",
					"SignColumn",
					"StatusLine",
					"StatusLineNC",
					"VertSplit",
					"WinSeparator",
					"MsgArea",
					"Pmenu",
					"PmenuSbar",
					"PmenuThumb",
					"BlinkCmpMenu",
					"BlinkCmpMenuBorder",
					"BlinkCmpDoc",
					"BlinkCmpDocBorder",
					"WhichKey",
					"Bufferline"
				},
				exclude_groups = {
					-- keep solid highlight colors for better contrast
					"PmenuSel", -- menu selection
					"CursorLine", -- current line
					"CursorLineNr", -- line number highlight
					"Visual", -- visual mode selection
					"BlinkCmpMenuSelection", -- blink's active item
				},
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = { "VimEnter", "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require("configs.lualine").setup,
	},
}
