-- Load NvChad defaults first
require("nvchad.autocmds")

-- ibl safe setup
local ok, ibl = pcall(require, "ibl")
if ok then
	ibl.setup({
		indent = { char = "│" },
	})
end

-- persistent theme management
local theme_file = vim.fn.stdpath("data") .. "/last_colorscheme.txt"
local nvchad_theme_file = vim.fn.stdpath("data") .. "/last_nvchad_theme.txt"

local function save_theme(theme)
	local file = io.open(theme_file, "w")
	if file then
		file:write(theme)
		file:close()
	end
end

local function save_nvchad_theme(theme)
	local file = io.open(nvchad_theme_file, "w")
	if file then
		file:write(theme)
		file:close()
	end
end

local function load_last_theme()
	local file = io.open(theme_file, "r")
	if file then
		local theme = file:read("*l")
		file:close()
		return theme
	end
	return "tokyonight-moon" -- default fallback
end

local function load_last_nvchad_theme()
	local file = io.open(nvchad_theme_file, "r")
	if file then
		local theme = file:read("*l")
		file:close()
		if theme and theme ~= "" then
			return theme
		end
	end
	return nil
end

-- hook into NvChad's theme reload to save preference
local original_reload_theme
local nvchad_themes_utils_ok, nvchad_themes_utils = pcall(require, "nvchad.themes.utils")
if nvchad_themes_utils_ok then
	original_reload_theme = nvchad_themes_utils.reload_theme
	nvchad_themes_utils.reload_theme = function(name)
		save_nvchad_theme(name)
		return original_reload_theme(name)
	end
end

-- Function to apply custom highlight overrides
local function apply_custom_highlights()
	-- Get current theme colors from base46 if available
	local ok, base46 = pcall(require, "base46")
	if ok then
		local colors = require("base46").get_theme_tb("base_30")

		-- Apply selection highlights with current theme colors
		vim.api.nvim_set_hl(0, "PmenuSel", { bg = colors.grey, fg = colors.blue, bold = true })
		vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = colors.grey, fg = colors.blue, bold = true })
		vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = colors.yellow, bg = colors.grey, bold = true })
		vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.black2 })
		vim.api.nvim_set_hl(0, "Visual", { bg = colors.one_bg3 })
		vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = colors.grey, bold = true })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.blue, bold = true })

		-- Blink.cmp specific highlights
		vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = colors.black2 })
		vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = colors.grey, fg = colors.blue, bold = true })
		vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = colors.blue })
		vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = colors.black2 })
		vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = colors.blue })

		-- LSP signature help
		vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bg = colors.grey, fg = colors.blue, bold = true })

		-- Command line completion
		vim.api.nvim_set_hl(0, "BlinkCmpMenuCmdline", { bg = colors.black2 })
		vim.api.nvim_set_hl(0, "BlinkCmpMenuSelectionCmdline", { bg = colors.grey, fg = colors.blue, bold = true })

		-- Apply other custom highlights
		vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.one_bg2 or "#565f89", bg = "NONE" })
		vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = colors.one_bg2 or "#565f89", bg = "NONE" })
		vim.api.nvim_set_hl(
			0,
			"NvimTreeOpenedFile",
			{ fg = colors.green, bold = true, underline = true, italic = true }
		)
		vim.api.nvim_set_hl(
			0,
			"NvimTreeSpecialFile",
			{ fg = colors.yellow, underline = true, bold = true, italic = true }
		)
		vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.blue })
	else
		-- Fallback for non-base46 themes (like tokyonight)
		-- Use hardcoded colors that work well with most themes
		vim.cmd("hi PmenuSel guibg=#3b4261 guifg=#7aa2f7 gui=bold")
		vim.cmd("hi TelescopeSelection guibg=#3b4261 guifg=#7aa2f7 gui=bold")
		vim.cmd("hi TelescopeSelectionCaret guifg=#e0af68 guibg=#3b4261 gui=bold")
		vim.cmd("hi CursorLine guibg=#292e42")
		vim.cmd("hi Visual guibg=#364a82")
		vim.cmd("hi WinSeparator guifg=#565f89 guibg=NONE")

		-- Blink.cmp for external themes
		vim.cmd("hi BlinkCmpMenu guibg=#1a1b26")
		vim.cmd("hi BlinkCmpMenuSelection guibg=#3b4261 guifg=#7aa2f7 gui=bold")
		vim.cmd("hi BlinkCmpMenuBorder guifg=#7aa2f7")
		vim.cmd("hi BlinkCmpDoc guibg=#1a1b26")
		vim.cmd("hi BlinkCmpDocBorder guifg=#7aa2f7")
		vim.cmd("hi LspSignatureActiveParameter guibg=#3b4261 guifg=#7aa2f7 gui=bold")
		vim.cmd("hi BlinkCmpMenuCmdline guibg=#1a1b26")
		vim.cmd("hi BlinkCmpMenuSelectionCmdline guibg=#3b4261 guifg=#7aa2f7 gui=bold")
	end
end

-- save theme whenever it changes via :colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local current_theme = vim.g.colors_name
		if current_theme then
			-- Check if this is a NvChad base46 theme
			local is_nvchad_theme = false
			local ok_utils, utils = pcall(require, "nvchad.utils")
			if ok_utils then
				local nvchad_themes = utils.list_themes()
				is_nvchad_theme = vim.tbl_contains(nvchad_themes, current_theme)
			end

			if not is_nvchad_theme then
				-- External theme (tokyonight, etc) - clear NvChad preference
				local file = io.open(nvchad_theme_file, "w")
				if file then
					file:write("")
					file:close()
				end

				-- If it's a tokyonight variant, also update the plugin style
				if current_theme:match("^tokyonight%-") then
					local variant = current_theme:match("^tokyonight%-(.+)$")
					if variant then
						local ok, tokyonight = pcall(require, "tokyonight")
						if ok then
							tokyonight.setup({ style = variant, transparent = false })
						end
					end
				end
			end

			save_theme(current_theme)
		end

		-- Reload NvChad statusline highlights when colorscheme changes
		vim.schedule(function()
			if vim.g.base46_cache then
				pcall(dofile, vim.g.base46_cache .. "statusline")
				pcall(dofile, vim.g.base46_cache .. "tbline")
			end

			-- Apply custom highlights after theme loads
			apply_custom_highlights()
		end)

		local ok_ibl, ibl = pcall(require, "ibl")
		if ok_ibl then
			pcall(ibl.refresh)
		end

		local ok_nt, nt = pcall(require, "nvim-tree")
		if ok_nt then
			vim.schedule(function()
				pcall(nt.refresh)
			end)
		end

		local ok_wk, wk = pcall(require, "which-key")
		if ok_wk then
			vim.schedule(function()
				pcall(wk.setup, {})
			end)
		end

		local ok_ts, _ = pcall(require, "telescope")
		if ok_ts then
			vim.schedule(function()
				vim.cmd("hi! link TelescopeBorder FloatBorder")
				vim.cmd("hi! link TelescopePromptBorder TelescopeBorder")
			end)
		end
	end,
})

-- load last used theme on startup
vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
		vim.defer_fn(function()
			-- Check if NvChad theme was last used
			local last_nvchad = load_last_nvchad_theme()
			if last_nvchad then
				-- Use NvChad's theme system
				local ok, base46 = pcall(require, "base46")
				if ok then
					require("nvconfig").base46.theme = last_nvchad
					base46.load_all_highlights()
					-- Load base46 cache after setting theme
					dofile(vim.g.base46_cache .. "defaults")
					dofile(vim.g.base46_cache .. "statusline")
				end
			else
				-- Use direct colorscheme (for tokyonight variants)
				local last_theme = load_last_theme()
				vim.cmd.colorscheme(last_theme)
				-- Still load statusline for external themes to maintain UI consistency
				vim.schedule(function()
					pcall(dofile, vim.g.base46_cache .. "statusline")
					pcall(dofile, vim.g.base46_cache .. "tbline")
				end)
			end
			vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "*" })

			-- Apply custom highlights after initial load
			vim.schedule(function()
				apply_custom_highlights()
			end)
		end, 25)
	end,
})

-- extra safety: reapply theme once more (async)
vim.schedule(function()
	vim.defer_fn(function()
		local last_nvchad = load_last_nvchad_theme()
		if last_nvchad then
			local ok, base46 = pcall(require, "base46")
			if ok then
				require("nvconfig").base46.theme = last_nvchad
				base46.load_all_highlights()
				pcall(dofile, vim.g.base46_cache .. "defaults")
				pcall(dofile, vim.g.base46_cache .. "statusline")
			end
		else
			local last_theme = load_last_theme()
			vim.cmd.colorscheme(last_theme)
			-- Load UI highlights for consistency
			vim.schedule(function()
				pcall(dofile, vim.g.base46_cache .. "statusline")
				pcall(dofile, vim.g.base46_cache .. "tbline")
			end)
		end
		vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "*" })

		-- Final application of custom highlights
		vim.defer_fn(function()
			apply_custom_highlights()
		end, 100)
	end, 50)
end)

