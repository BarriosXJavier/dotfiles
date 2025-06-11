local M = {}

M.override_options = {
  git = {
    enable = true,
    ignore = false,
  },
  renderer = {
    highlight_git = true,
    highlight_opened_files = "name",
    indent_width = 2,
    icons = {
      show = {
        git = true,
      },
    },
  },
  view = {
    side = "left",
    width = 30,
    adaptive_size = true,
  },
}

return M
