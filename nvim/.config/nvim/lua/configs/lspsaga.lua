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
			max_width = 0.9,
		},
	})
end

return M
