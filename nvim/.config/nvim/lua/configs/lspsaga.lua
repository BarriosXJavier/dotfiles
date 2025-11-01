local M = {}

M.setup = function()
	require("lspsaga").setup({
		ui = {
			border = "single",
			beacon = { enable = false },
			lightbulb = { enable = false },
		},
		lightbulb = {
			enable = false,
			sign = false,
		},
		symbol_in_winbar = {
			enable = true,
			separator = " › ",
			show_file = true,
		},
		code_action = {
			extend_gitsigns = true,
			keys = {
				quit = { "q", "<ESC>" },
				exec = "<CR>",
			},
		},
		definition = {
			keys = {
				quit = "q",
			},
		},
		hover = {
			max_width = 0.8,
		},
	})
end

M.keymaps = function()
	vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
	vim.keymap.set("n", "gD", "<cmd>Lspsaga goto_definition<CR>")
	vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")
end

return M
