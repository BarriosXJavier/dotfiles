-- Load NvChad defaults first
require("nvchad.autocmds")

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "BufLeave" }, {
	pattern = "*",
	callback = function()
		if vim.bo.modified and vim.fn.getbufvar(vim.fn.bufnr(), "&buftype") == "" then
			vim.cmd("silent! write")
		end
	end,
	desc = "Auto-save files when focus is lost or text changes",
})

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
				end
			else
				-- Use direct colorscheme (for tokyonight variants)
				local last_theme = load_last_theme()
				vim.cmd.colorscheme(last_theme)
			end
			vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "*" })
		end, 300)
	end,
})

-- extra safety: reapply theme once more (async)
vim.schedule(function()
	local last_nvchad = load_last_nvchad_theme()
	if last_nvchad then
		local ok, base46 = pcall(require, "base46")
		if ok then
			require("nvconfig").base46.theme = last_nvchad
			base46.load_all_highlights()
		end
	else
		local last_theme = load_last_theme()
		vim.cmd.colorscheme(last_theme)
	end
	vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "*" })
end)
