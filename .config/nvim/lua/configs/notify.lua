local M = {}

function M.setup()
  require("notify").setup {
    render = "compact",
    background_colour = "#1e1e2e",
    max_width = 35,
    stages = "slide",
    timeout = 2500,
    top_down = false,
  }
end

return M
