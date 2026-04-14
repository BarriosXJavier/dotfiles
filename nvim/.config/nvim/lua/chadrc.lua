-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

-- This table is used to override the default NvChad configuration.
local M = {
	base46 = {
		theme = "github_dark", -- default NvChad theme if none saved
		hl_add = {},

		hl_override = {
			WinSeparator = { fg = "#565f89", bg = "none" },
			-- NvimTreeWinSeparator = { fg = "#565f89", bg = "none" }, -- gruber-darker handles this
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

			-- NvimTree -- gruber-darker handles these
			-- NvimTreeNormal = { bg = "none" },
			-- NvimTreeNormalNC = { bg = "none" },
			-- NvimTreeEndOfBuffer = { bg = "none" },

			-- Diagnostics: use underline instead of undercurl (squiggly)
			DiagnosticUnderlineError = { underline = true, sp = "red" },
			DiagnosticUnderlineWarn = { underline = false, sp = "yellow" },
			DiagnosticUnderlineInfo = { underline = false, sp = "cyan" },
			DiagnosticUnderlineHint = { underline = false, sp = "blue" },

			-- improved popup visibility with stronger contrast
			PmenuSel = { bg = "one_bg2", fg = "blue", bold = true },
			TelescopeSelection = { bg = "one_bg2", fg = "blue", bold = true },
			TelescopeSelectionCaret = { fg = "yellow", bg = "one_bg2", bold = true },

			-- NvimTree highlights -- gruber-darker handles these
			-- NvimTreeCursorLine = { bg = "one_bg2", bold = true },
			-- NvimTreeOpenedFile = { fg = "green", bold = true, underline = true, italic = true },
			-- NvimTreeSpecialFile = { fg = "yellow", underline = true, bold = true, italic = true },

			-- Emacs-like minimal syntax styling: restrained emphasis, mostly carried by color only.
			Keyword = { fg = "#c678dd", bold = false, italic = false },
			Conditional = { fg = "#c678dd", bold = false, italic = false },
			Repeat = { fg = "#c678dd", bold = false, italic = false },
			Statement = { fg = "#c678dd", bold = false, italic = false },
			Exception = { fg = "#c678dd", bold = false, italic = false },
			Include = { fg = "#c678dd", bold = false, italic = false },
			Function = { fg = "#61afef", bold = false, italic = false },
			Type = { fg = "#e5c07b", bold = false, italic = false },
			Constant = { fg = "#d19a66", bold = false, italic = false },
			String = { fg = "#98c379", bold = false, italic = false },
			Comment = { fg = "#7f848e", italic = true },

			["@keyword"] = { fg = "#c678dd", bold = false, italic = false },
			["@keyword.function"] = { fg = "#c678dd", bold = false, italic = false },
			["@keyword.return"] = { fg = "#c678dd", bold = false, italic = false },
			["@keyword.operator"] = { fg = "#c678dd", bold = false, italic = false },
			["@keyword.conditional"] = { fg = "#c678dd", bold = false, italic = false },
			["@keyword.repeat"] = { fg = "#c678dd", bold = false, italic = false },

			["@function"] = { fg = "#61afef", bold = false, italic = false },
			["@function.builtin"] = { fg = "#61afef", bold = false, italic = false },
			["@method"] = { fg = "#61afef", bold = false, italic = false },

			["@type"] = { fg = "#e5c07b", bold = false, italic = false },
			["@type.builtin"] = { fg = "#e5c07b", bold = false, italic = false },

			["@constant"] = { fg = "#d19a66", bold = false, italic = false },
			["@constant.builtin"] = { fg = "#d19a66", bold = false, italic = false },
			["@variable.builtin"] = { fg = "#d19a66", bold = false, italic = false },

			["@string"] = { fg = "#98c379", bold = false, italic = false },
			["@string.escape"] = { fg = "#98c379", bold = false, italic = false },

			["@comment"] = { fg = "#7f848e", italic = true },
			["@comment.documentation"] = { fg = "#7f848e", italic = true },
			["@include"] = { fg = "#c678dd", bold = false, italic = false },
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
			separator_style = "block",
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
