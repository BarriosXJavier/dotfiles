local M = {}

M.setup = function()
  require("lspsaga").setup({
    ui = {
      border = "none",
      beacon = { enable = false },
      lightbulb = { enable = false },
      winblend = 0,
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
      max_width = 0.7,
    },
  })
end

return M
