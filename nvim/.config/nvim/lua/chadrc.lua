-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

local options = {
	base46 = {
		theme = "tokyonight", -- default theme
		hl_add = {
			LineNr = { fg = "#4b5370" },
			CursorLineNr = { fg = "#7aa2f7", bold = true },
		},
		hl_override = {
			Comment = { fg = "#bcc0cc", italic = true },
			["@comment"] = { italic = true },
		},
		transparency = true,
		theme_toggle = { "tokyonight", "gruvbox" },
	},

	ui = {
		cmp = {
			icons_left = true, -- only for non-atom styles!
			lspkind_text = true,
			style = "flat_dark", -- default/flat_light/flat_dark/atom/atom_colored
			format_colors = {
				tailwind = true, -- will work for css lsp too
				icon = "󱓻",
			},
		},

		telescope = { style = "bordered" }, -- borderless / bordered

		statusline = {
			enabled = false,
			theme = "default",
			separator_style = "arrow",
			order = nil,
			modules = nil,
		},

		-- lazyload it when there are 1+ buffers
		tabufline = {
			enabled = true,
			lazyload = false,
			order = { "treeOffset", "buffers", "tabs", "btns" },
			modules = nil,
		},
	},

	term = {
		winopts = { number = false, relativenumber = false },
		transparency = true,
		sizes = {
			sp = 0.35,
			vsp = 0.35,
			["bo sp"] = 0.3,
			["bo vsp"] = 0.5,
		},

		float = {
			relative = "editor",
			row = 0.5 - (0.7 / 2), -- Centers vertically
			col = 0.5 - (0.95 / 2), -- Centers horizontally
			width = 0.95,
			height = 0.9,
			border = "single",
		},
	},

	lsp = { signature = true },

	cheatsheet = {
		theme = "grid", -- simple/grid
		excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
	},

	mason = { pkgs = {} },

	colorify = {
		enabled = true,
		mode = "virtual", -- fg, bg, virtual
		virt_text = "󱓻 ",
		highlight = { hex = true, lspvars = true },
	},

	nvdash = {
		load_on_startup = true,
	},
}

local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})
