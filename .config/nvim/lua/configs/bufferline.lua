local M = {}

function M.setup()
  require("bufferline").setup {
    options = {
      offsets = {
        {
          filetype = "NvimTree",
          text = "Nvim Tree",
          highlight = "Directory",
          separator = true,
        },
      },
      highlights = {
        buffer_selected = {
          bold = true,
          italic = true,
        },
      },
      always_show_bufferline = true,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level, _, _)
        local icon = level:match "error" and " "
            or level:match "warn" and " "
            or level:match "info" and " "
            or ""
        return " " .. icon .. count
      end,
      separator_style = "thick",
      modified_icon = "●",
      show_close_icon = false,
      show_buffer_close_icons = true,
    },
  }
end

return M
