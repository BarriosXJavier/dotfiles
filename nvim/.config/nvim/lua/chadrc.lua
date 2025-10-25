-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

-- This table is used to override the default NvChad configuration.
local M = {
	transparency = true,

	base46 = {
		theme = "gruvbox",

		hl_add = {
			WinSeparator = { fg = "#1e1e2e", bg = "none" },
			CursorLineNr = { fg = "#7aa2f7", bold = true },
		},

		hl_override = {
			Comment = { fg = "#bcc0cc", italic = true },
			["@comment"] = { italic = true },

			-- improved popup visibility
			PmenuSel = { bg = "one_bg2", fg = "white", bold = true },
			TelescopeSelection = { bg = "one_bg2", fg = "white", bold = true },
			TelescopeSelectionCaret = { fg = "yellow", bold = true },
		},

		theme_toggle = { "gruvbox", "gruvbox" },
	},

	ui = {
		theme = "gruvbox",
		cmp = {
			icons_left = true, -- only for non-atom styles!
			lspkind_text = true,
			style = "flat_dark", -- default/flat_light/flat_dark/atom/atom_colored
			format_colors = {
				tailwind = true, -- will work for css lsp too
				icon = "󱓻",
			},
			hl_override = {},
			hl_add = {},
		},

		telescope = { style = "bordered" }, -- borderless / bordered

		statusline = {
			enabled = true,
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
			width = 0.96,
			height = 0.90,
			border = "single",
		},
	},

	lsp = { signature = true, theme = "github_dark" },

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

return M
