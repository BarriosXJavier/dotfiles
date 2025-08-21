local M = {}

M.setup = function(style)
  style = style or "storm"
  local is_dark = style ~= "day"

  require("tokyonight").setup({
    style = style,
    transparent = is_dark,
    styles = {
      sidebars = is_dark and "transparent" or "dark",
      floats   = is_dark and "transparent" or "dark",
    },
  })

  vim.o.background = is_dark and "dark" or "light"

  vim.cmd.colorscheme("tokyonight-storm")
end

-- picker for switching variants
M.pick_variant = function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values

  local variants = { "night", "storm", "moon", "day" }

  pickers.new({}, {
    prompt_title = "TokyoNight Variant",
    finder = finders.new_table({ results = variants }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      local apply = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        M.setup(selection[1])
      end

      map("i", "<CR>", apply)
      map("n", "<CR>", apply)
      return true
    end,
  }):find()
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()


    -- NvimTree
    local ok2, nvim_tree = pcall(require, "nvim-tree")
    if ok2 then nvim_tree.setup({}) end  -- or reapply your config table

    -- bufferline
    local ok3, bufferline = pcall(require, "bufferline")
    if ok3 then bufferline.setup({}) end

    -- lualine
    local ok4, lualine = pcall(require, "lualine")
    if ok4 then lualine.refresh() end

    -- any other plugin that depends on highlights can go here
  end,
})

return M

