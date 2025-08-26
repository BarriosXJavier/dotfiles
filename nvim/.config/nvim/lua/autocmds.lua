require("nvchad.autocmds")

-- 🔹 ibl safe setup
local ok, ibl = pcall(require, "ibl")
if ok then
	ibl.setup({
		indent = { char = "│" },
	})
end

-- 🔹 refresh ibl safely on theme switch
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local ok, ibl = pcall(require, "ibl")
		if ok then
			pcall(ibl.refresh)
		end
	end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        vim.cmd("colorscheme tokyonight-night")
    end,
})


