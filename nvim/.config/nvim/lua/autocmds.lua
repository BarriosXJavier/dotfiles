-- Load NvChad defaults first
require("nvchad.autocmds")

-- 🔹 ibl safe setup
local ok, ibl = pcall(require, "ibl")
if ok then
	ibl.setup({
		indent = { char = "│" },
	})
end

-- 🔹 universal refresh chain (fires on ANY :colorscheme)
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local ok_ibl, ibl = pcall(require, "ibl")
		if ok_ibl then
			pcall(ibl.refresh)
		end

		local ok_ll, lualine = pcall(require, "lualine")
		if ok_ll then
			pcall(lualine.setup, { options = { theme = vim.g.colors_name } })
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

		local ok_tr, transparent = pcall(require, "transparent")
		if ok_tr then
			pcall(transparent.enable)
		end

		vim.notify("Colorscheme applied: " .. vim.g.colors_name, vim.log.levels.INFO, { title = "Theme" })
	end,
})

-- 🔹 force theme once UI is ready
vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
		vim.defer_fn(function()
			vim.cmd.colorscheme("tokyonight-moon")
			vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "*" })
			vim.notify("Forced tokyonight-moon applied", vim.log.levels.INFO, { title = "Theme" })
		end, 300)
	end,
})

-- 🔹 extra safety: reapply theme once more (async)
vim.schedule(function()
	vim.cmd.colorscheme("tokyonight-moon")
	vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "*" })
end)

local function cleanup_dead_buffers()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if not vim.api.nvim_buf_is_loaded(bufnr) or not vim.api.nvim_buf_is_valid(bufnr) then
			pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
		end
	end
end

vim.api.nvim_create_autocmd({ "BufWinLeave", "BufHidden" }, {
	callback = function()
		vim.defer_fn(cleanup_dead_buffers, 500)
	end,
})
