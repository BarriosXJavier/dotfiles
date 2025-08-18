-- configs/tokyonight.lua
local M = {}

local save_file = vim.fn.stdpath("data") .. "/tokyonight_variant.txt"

local function read_last_variant()
  local f = io.open(save_file, "r")
  if f then
    local style = f:read("*l")
    f:close()
    return style
  end
end

local function save_variant(style)
  local f = io.open(save_file, "w")
  if f then
    f:write(style)
    f:close()
  end
end

M.setup = function(style)
  style = style or read_last_variant() or "night"
  save_variant(style)

  local is_dark = style ~= "day"

  require("tokyonight").setup({
    style = style,
    transparent = is_dark, -- wallpapers only in dark variants
    styles = {
      sidebars = is_dark and "transparent" or "dark",
      floats   = is_dark and "transparent" or "dark",
    },
  })

  -- hard reset highlights to avoid bleed
  vim.cmd("highlight clear")
  vim.cmd("syntax reset")
  vim.o.background = is_dark and "dark" or "light"

  -- load scheme cleanly
  vim.cmd.colorscheme("tokyonight")

  -- refresh indent-blankline highlights
  local ok, ibl = pcall(require, "ibl")
  if ok then ibl.setup() end
end

M.pick_variant = function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values

  local variants = { "night", "storm", "moon", "day" }

  pickers.new({}, {
    prompt_title = "TokyoNight Variant",
    finder = finders.new_table({
      results = variants,
    }),
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

return M

