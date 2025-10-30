-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

-- Load persisted theme preference
local function load_last_nvchad_theme()
	local nvchad_theme_file = vim.fn.stdpath("data") .. "/last_nvchad_theme.txt"
	local file = io.open(nvchad_theme_file, "r")
	if file then
		local theme = file:read("*l")
		file:close()
		-- Only return if it's not empty (empty means external colorscheme is in use)
		if theme and theme ~= "" then
			return theme
		end
	end
	return "gruvbox" -- default fallback
end

local saved_theme = load_last_nvchad_theme()

-- This table is used to override the default NvChad configuration.
local M = {
	base46 = {
		theme = saved_theme,

		hl_add = {
			WinSeparator = { fg = "#565f89", bg = "none" },
			NvimTreeWinSeparator = { fg = "#565f89", bg = "none" },
			CursorLineNr = { fg = "#7aa2f7", bold = true },
		},

		hl_override = {
			Comment = { fg = "#bcc0cc", italic = true },
			["@comment"] = { italic = true },

			-- Diagnostics: use underline instead of undercurl (squiggly)
			DiagnosticUnderlineError = { underline = true, sp = "red" },
			DiagnosticUnderlineWarn = { underline = false, sp = "yellow" },
			DiagnosticUnderlineInfo = { underline = false, sp = "cyan" },
			DiagnosticUnderlineHint = { underline = false, sp = "blue" },

			-- Ensure cursor line is always visible
			CursorLine = { bg = "black2" },
			Visual = { bg = "one_bg3" },

			-- improved popup visibility with stronger contrast
			PmenuSel = { bg = "grey", fg = "blue", bold = true },
			TelescopeSelection = { bg = "grey", fg = "blue", bold = true },
			TelescopeSelectionCaret = { fg = "yellow", bg = "grey", bold = true },

			-- NvimTree highlights
			NvimTreeCursorLine = { bg = "grey", bold = true },
			NvimTreeOpenedFile = { fg = "green", bold = true, underline = true, italic = true },
			NvimTreeSpecialFile = { fg = "yellow", underline = true, bold = true, italic = true },

			-- Other common list highlights
			FloatBorder = { fg = "blue" },
			-- Keywords and language constructs
			Keyword = { italic = true },
			["@keyword"] = { italic = true },
			["@keyword.function"] = { italic = true },
			["@keyword.return"] = { italic = true },
			["@keyword.operator"] = {},

			-- Conditionals and loops
			Conditional = { italic = true },
			Repeat = { italic = true },
			["@keyword.conditional"] = { italic = true },
			["@keyword.repeat"] = { italic = true },

			-- Functions and methods
			Function = {},
			["@function"] = {},
			["@function.builtin"] = {},
			["@method"] = {},

			-- Types and classes
			Type = {},
			["@type"] = {},
			["@type.builtin"] = {},
			["@class"] = {},

			-- Constants and variables
			Constant = {},
			["@constant"] = {},
			["@constant.builtin"] = {},
			["@variable.builtin"] = {},

			-- Strings and special chars
			String = {},
			["@string"] = {},
			["@string.escape"] = {},

			-- Other useful highlights
			Statement = {},
			Exception = {},
			Include = { italic = true },
			["@include"] = { italic = true },
		},

		theme_toggle = { "gruvbox", saved_theme },
	},

	ui = {
		theme = saved_theme,
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
			width = 0.98,
			height = 0.90,
			border = "single",
		},
	},

	lsp = { signature = true, theme = saved_theme },

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
		load_on_startup = false,
	},
}

return M
