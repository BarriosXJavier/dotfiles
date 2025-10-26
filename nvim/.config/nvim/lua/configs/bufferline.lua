local ok, bufferline = pcall(require, "bufferline")

if not ok then
	return
end

bufferline.setup({
	options = {
		mode = "buffers",
		indicator = { style = "none" },
		show_buffer_close_icons = true,
		show_close_icon = true,
		always_show_bufferline = true,
		separator_style = "slant",

		-- LSP diagnostics
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or level:match("warning") and " " or " "
			return " " .. icon .. count
		end,

		-- NvimTree offset
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer",
				text_align = "center",
				highlight = "Directory",
				separator = true,
			},
		},
	},
})
