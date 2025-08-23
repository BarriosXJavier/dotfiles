local M = {}

-- Setup TokyoNight colorscheme
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

  -- Apply the selected colorscheme variant
  vim.cmd.colorscheme("tokyonight-" .. style)

  -- Configure indent-blankline.nvim (thin and subtle)
  local ok, ibl = pcall(require, "ibl")
  if ok then
    ibl.setup({
      indent = {
        char = "│",          -- thin vertical bar
        tab_char = "│",
        smart_indent_cap = true,
      },
      scope = {
        enabled = false,      -- optional: turn off scope highlight
      },
      exclude = {
        filetypes = { "help", "terminal", "lazy", "NvimTree" },
      },
    })

    -- match IblChar to TokyoNight side color
    vim.cmd([[highlight IblChar guifg=#3b4261 gui=nocombine]])
  end
end

-- Variant picker using Telescope
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

-- Refresh plugin highlights on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- NvimTree
    local ok2, nvim_tree = pcall(require, "nvim-tree")
    if ok2 then nvim_tree.setup({}) end

    -- bufferline
    local ok3, bufferline = pcall(require, "bufferline")
    if ok3 then bufferline.setup({}) end

    -- lualine
    local ok4, lualine = pcall(require, "lualine")
    if ok4 then lualine.refresh() end

    -- reapply ibl after any colorscheme change
    local ok5, ibl = pcall(require, "ibl")
    if ok5 then
      ibl.setup({
        indent = { char = "│", tab_char = "│", smart_indent_cap = true },
        scope = { enabled = false },
        exclude = { filetypes = { "help", "terminal", "lazy", "NvimTree" } },
      })
      vim.cmd([[highlight IblChar guifg=#3b4261 gui=nocombine]])
    end
  end,
})

return M

