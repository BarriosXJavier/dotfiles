local M = {}

function M.pick_tokyonight_variant()
  local themes = {
    "tokyonight-day",
    "tokyonight-night",
    "tokyonight-storm",
    "tokyonight-moon",
  }

  require("telescope.pickers").new({}, {
    prompt_title = "TokyoNight Variants",
    finder = require("telescope.finders").new_table {
      results = themes,
    },
    sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<Down>", require("telescope.actions").move_selection_next)
      map("i", "<Up>", require("telescope.actions").move_selection_previous)
      require("telescope.actions").select_default:replace(function()
        local selection = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(prompt_bufnr)
        local variant = selection[1]
        vim.cmd("colorscheme " .. variant)
        local file = io.open(vim.fn.stdpath("data") .. "/.tokyonight_variant", "w")
        if file then
          file:write(variant)
          file:close()
        end
      end)
      return true
    end,
  }):find()
end

return M
