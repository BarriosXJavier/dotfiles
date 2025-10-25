-- Load NvChad defaults first
require("nvchad.autocmds")

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "BufLeave", "TextChanged" }, {
	pattern = "*",
	callback = function()
		if vim.bo.modified and vim.fn.getbufvar(vim.fn.bufnr(), "&buftype") == "" then
			vim.cmd("silent! write")
		end
	end,
	desc = "Auto-save files when focus is lost or text changes",
})
