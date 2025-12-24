-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

-- This table is used to override the default NvChad configuration.
local M = {
	base46 = {
		theme = "catppuccin", -- default NvChad theme if none saved

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

			-- improved popup visibility with stronger contrast
			PmenuSel = { bg = "one_bg2", fg = "blue", bold = true },
			TelescopeSelection = { bg = "one_bg2", fg = "blue", bold = true },
			TelescopeSelectionCaret = { fg = "yellow", bg = "one_bg2", bold = true },

			-- NvimTree highlights
			NvimTreeCursorLine = { bg = "one_bg2", bold = true },
			NvimTreeOpenedFile = { fg = "green", bold = true, underline = true, italic = true },
			NvimTreeSpecialFile = { fg = "yellow", underline = true, bold = true, italic = true },

			-- Other common list highlights
			FloatBorder = { fg = "blue" },
			-- Keywords and language constructs
			Keyword = { bold = true },
			["@keyword"] = { bold = true },
			["@keyword.function"] = { bold = true },
			["@keyword.return"] = { bold = true },
			["@keyword.operator"] = { bold = true },

			-- Conditionals and loops
			Conditional = { bold = true },
			Repeat = { bold = true },
			["@keyword.conditional"] = { bold = true },
			["@keyword.repeat"] = { bold = true },

			-- Functions and methods
			Function = { bold = true },
			["@function"] = { bold = true },
			["@function.builtin"] = { bold = true },
			["@method"] = { bold = true },

			-- Types and classes
			Type = { bold = true },
			["@type"] = { bold = true },
			["@type.builtin"] = { bold = true },
			["@class"] = { bold = true },

			-- Constants and variables
			Constant = {},
			["@constant"] = {},
			["@constant.builtin"] = {},
			["@variable.builtin"] = {},

			-- Strings and special chars
			String = {},
			["@string"] = {},
			["@string.escape"] = {},

			-- Other
			Statement = { bold = true },
			Exception = { bold = true },
			Include = { bold = true },
			["@include"] = { bold = true },
		},

		theme_toggle = { "catppuccin", "tokyonight" },
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
			hl_override = {},
			hl_add = {},
			border = "rounded",
			theme = "catppuccin",
		},

		telescope = { style = "bordered" }, -- borderless / bordered

		statusline = {
			enabled = true,
			separator_style = "arrow",
			order = nil,
			modules = {
				lsp = function()
					local clients = vim.lsp.get_clients({ bufnr = 0 })
					if #clients == 0 then
						return ""
					end

					local client_names = {}
					for _, client in ipairs(clients) do
						local name = client.name
						if #name > 4 then
							name = name:sub(1, 4)
						end
						table.insert(client_names, "[" .. name .. "]")
					end

					return "%#St_LspStatus#" .. "  LSPs: " .. table.concat(client_names, " ") .. " "
				end,
			},
		},

		-- lazyload it when there are 1+ buffers
		tabufline = {
			enabled = true,
			lazyload = false,
			order = { "treeOffset", "buffers", "tabs", "btns" },
			modules = nil,
		},
		theme = "catppuccin",
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

return M
