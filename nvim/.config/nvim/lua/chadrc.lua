-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

-- This table is used to override the default NvChad configuration.
local M = {
	base46 = {
		theme = "github_dark", -- default NvChad theme if none saved
		hl_add = {},

		hl_override = {
			WinSeparator = { fg = "#565f89", bg = "none" },
			NvimTreeWinSeparator = { fg = "#565f89", bg = "none" },
			LineNr = { fg = "#565f89" },

			-- Core editor
			Normal = { bg = "none" },
			NormalFloat = { bg = "none" },
			SignColumn = { bg = "none" },
			EndOfBuffer = { bg = "none" },
			MsgArea = { bg = "none" },

			-- Completion menu (LSP / cmp)
			Pmenu = { bg = "none" },
			PmenuSbar = { bg = "none" },
			PmenuThumb = { bg = "none" },

			-- Floating docs / hover
			FloatBorder = { bg = "none" },

			-- NvimTree
			NvimTreeNormal = { bg = "none" },
			NvimTreeNormalNC = { bg = "none" },
			NvimTreeEndOfBuffer = { bg = "none" },

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

			Keyword = { bold = true },
			["@keyword"] = { bold = true },
			["@keyword.function"] = { bold = true },
			["@keyword.return"] = { bold = true },
			["@keyword.operator"] = { bold = true },

			Conditional = { bold = true },
			Repeat = { bold = true },
			["@keyword.conditional"] = { bold = true },
			["@keyword.repeat"] = { bold = true },

			Function = { bold = true },
			["@function.builtin"] = { bold = true },

			["@type.builtin"] = { bold = true },

			["@constant.builtin"] = { bold = true },
			["@variable.builtin"] = { bold = true },

			["@string.escape"] = { bold = true },

			Statement = { bold = true },
			Exception = { bold = true },
			Include = { bold = true },

			Comment = { fg = "#858585", italic = true },
			["@comment"] = { italic = true },
			["@comment.documentation"] = { italic = true },
			["@include"] = { bold = true },
		},

		theme_toggle = { "github_dark", "github_dark" },
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
			theme = "github_dark",
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
		theme = "github_dark",
	},

	term = {
		winopts = { number = false, relativenumber = false },
		sizes = {
			sp = 0.35,
			vsp = 0.35,
			["bo sp"] = 0.2,
			["bo vsp"] = 0.2,
		},

		float = {
			relative = "editor",
			row = 0.5 - (0.7 / 2), -- Centers vertically
			col = 0.5 - (0.95 / 2), -- Centers horizontally
			width = 0.98,
			height = 0.90,
			border = "rounded",
		},
	},

	lsp = { signature = true },

	cheatsheet = {
		theme = "grid", -- simple/grid
		excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
	},

	mason = {
		pkgs = {
			"pyright",
			"black",
			"debugpy",
		},
	},

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
