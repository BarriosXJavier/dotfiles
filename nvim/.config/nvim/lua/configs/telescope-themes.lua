-- Custom telescope picker for all colorschemes (NvChad + plugins)
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

-- Get all available colorschemes (NvChad + plugins)
local function get_all_colorschemes()
	local nvchad_themes = {}
	local external_themes = {}

	-- Get NvChad base46 themes
	local ok, utils = pcall(require, "nvchad.utils")
	if ok then
		nvchad_themes = utils.list_themes() or {}
	end

	-- Get all available colorschemes
	local all_colorschemes = vim.fn.getcompletion("", "color")

	for _, theme in ipairs(all_colorschemes) do
		-- Check if it's a NvChad theme
		local is_nvchad = vim.tbl_contains(nvchad_themes, theme)

		-- Special case: 'nvchad' base colorscheme
		if theme == "nvchad" then
			is_nvchad = true
		end

		if not is_nvchad then
			table.insert(external_themes, theme)
		end
	end

	return nvchad_themes, external_themes
end

-- Apply theme based on type
local function apply_theme(theme, is_nvchad)
	if is_nvchad then
		-- Use NvChad's theme system
		local ok, base46 = pcall(require, "base46")
		if ok then
			require("nvconfig").base46.theme = theme
			base46.load_all_highlights()
		end
	else
		-- Use direct colorscheme command
		pcall(vim.cmd.colorscheme, theme)
	end
end

M.pick_colorscheme = function(opts)
	opts = opts or {}

	local nvchad_themes, external_themes = get_all_colorschemes()

	-- Combine and format entries
	local entries = {}
	
	-- Add NvChad themes first
	for _, theme in ipairs(nvchad_themes) do
		table.insert(entries, { display = "󰏘 " .. theme, value = theme, is_nvchad = true })
	end
	
	-- Then external themes
	for _, theme in ipairs(external_themes) do
		table.insert(entries, { display = " " .. theme, value = theme, is_nvchad = false })
	end

	-- Store original theme to restore on cancel
	local original_theme = vim.g.colors_name
	local original_is_nvchad = false
	local ok, utils = pcall(require, "nvchad.utils")
	if ok then
		local nvchad_themes_list = utils.list_themes() or {}
		original_is_nvchad = vim.tbl_contains(nvchad_themes_list, original_theme or "")
	end

	pickers
		.new(opts, {
			prompt_title = "🎨 Colorschemes (Live Preview - j/k to navigate, Enter to apply, Esc to cancel)",
			finder = finders.new_table({
				results = entries,
				entry_maker = function(entry)
					return {
						value = entry.value,
						display = entry.display,
						ordinal = entry.display,
						is_nvchad = entry.is_nvchad,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			selection_caret = "  ",
			attach_mappings = function(prompt_bufnr, map)
				-- Live preview function
				local function preview_theme()
					local selection = action_state.get_selected_entry()
					if selection then
						vim.schedule(function()
							apply_theme(selection.value, selection.is_nvchad)
						end)
					end
				end

				-- Apply and close on Enter
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if selection then
						apply_theme(selection.value, selection.is_nvchad)
					end
				end)

				-- Restore original theme on cancel
				local function restore_and_close()
					actions.close(prompt_bufnr)
					if original_theme then
						vim.schedule(function()
							apply_theme(original_theme, original_is_nvchad)
						end)
					end
				end

				-- Cancel mappings
				map("i", "<Esc>", restore_and_close)
				map("n", "<Esc>", restore_and_close)
				map("n", "q", restore_and_close)
				map("i", "<C-c>", restore_and_close)

				-- Movement with live preview
				map("i", "<Down>", function()
					actions.move_selection_next(prompt_bufnr)
					preview_theme()
				end)
				
				map("i", "<Up>", function()
					actions.move_selection_previous(prompt_bufnr)
					preview_theme()
				end)
				
				map("i", "<C-n>", function()
					actions.move_selection_next(prompt_bufnr)
					preview_theme()
				end)
				
				map("i", "<C-p>", function()
					actions.move_selection_previous(prompt_bufnr)
					preview_theme()
				end)

				map("n", "j", function()
					actions.move_selection_next(prompt_bufnr)
					preview_theme()
				end)
				
				map("n", "k", function()
					actions.move_selection_previous(prompt_bufnr)
					preview_theme()
				end)
				
				map("n", "<Down>", function()
					actions.move_selection_next(prompt_bufnr)
					preview_theme()
				end)
				
				map("n", "<Up>", function()
					actions.move_selection_previous(prompt_bufnr)
					preview_theme()
				end)

				-- Preview initial selection after picker loads
				vim.defer_fn(function()
					if vim.api.nvim_buf_is_valid(prompt_bufnr) then
						preview_theme()
					end
				end, 50)

				return true
			end,
		})
		:find()
end

return M
