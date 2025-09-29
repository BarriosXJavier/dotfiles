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
		-- refresh indent guides
		local ok_ibl, ibl = pcall(require, "ibl")
		if ok_ibl then
			pcall(ibl.refresh)
		end

		-- refresh lualine
		local ok_ll, lualine = pcall(require, "lualine")
		if ok_ll then
			pcall(lualine.setup, { options = { theme = vim.g.colors_name } })
		end

		-- refresh nvim-tree
		local ok_nt, nt = pcall(require, "nvim-tree")
		if ok_nt then
			vim.schedule(function()
				pcall(nt.refresh)
			end)
		end

		-- refresh which-key
		local ok_wk, wk = pcall(require, "which-key")
		if ok_wk then
			vim.schedule(function()
				pcall(wk.setup, {})
			end)
		end

		-- refresh telescope
		local ok_ts, _ = pcall(require, "telescope")
		if ok_ts then
			vim.schedule(function()
				vim.cmd("hi! link TelescopeBorder FloatBorder")
				vim.cmd("hi! link TelescopePromptBorder TelescopeBorder")
			end)
		end

		-- 🔹 re-apply transparency
		local ok_tr, transparent = pcall(require, "transparent")
		if ok_tr then
			pcall(transparent.enable)
		end

		-- theme load notification
		vim.notify("Colorscheme applied: " .. vim.g.colors_name, vim.log.levels.INFO, { title = "Theme" })
	end,
})

-- 🔹 force reapply theme AFTER lazy + base46
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	once = true,
	callback = function()
		vim.schedule(function()
			vim.cmd("colorscheme tokyonight-storm")
		end)
	end,
})
