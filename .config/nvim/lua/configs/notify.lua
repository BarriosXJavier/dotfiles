local M = {}

function M.setup()
  require("notify").setup {
    render = "wrapped-compact",
    background_colour = "#1e1e2e",
    max_width = function()
      return math.floor(vim.o.columns * 0.5)
    end,
    stages = "slide",
    timeout = 2500,
    top_down = false,
  }
end

return M
