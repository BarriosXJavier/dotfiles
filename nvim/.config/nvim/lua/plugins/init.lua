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
					{ "kind_icon", "label", "label_description", gap = 1 },
					{ "source_name" }, -- this shows [lsp], [snip], [buf], etc.
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

		experimental = {
			ghost_text = false,
		},
	},

	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup()
			vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
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

	-- Gitsigns for git integration in sign column
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true,
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 1000,
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Next git hunk" })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Previous git hunk" })

				-- Actions
				map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage hunk" })
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset hunk" })
				map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
				map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
				map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
				map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, { desc = "Blame line" })
				map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
				map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, { desc = "Diff this ~" })
				map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })
			end,
		},
	},

	-- None-ls for linting
	{
		"nvimtools/none-ls.nvim",
		event = "BufReadPre",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local diagnostics = null_ls.builtins.diagnostics

			null_ls.setup({
				sources = {
					-- Linters from none-ls-extras
					require("none-ls.diagnostics.eslint_d"),
					diagnostics.pylint,
					diagnostics.shellcheck,
					diagnostics.markdownlint,
					diagnostics.yamllint,

					-- Code actions from none-ls-extras
					require("none-ls.code_actions.eslint_d"),
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
		end,
	},
}
