local M = {}

function M.setup()
  require("bufferline").setup {
    options = {
      offsets = {
        {
          filetype = "NvimTree",
          text = "Nvim Tree",
          highlight = "Directory",
          separator = false,
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
      modified_icon = "●",
      show_close_icon = false,
      show_buffer_close_icons = true,
      options = {
        custom_filter = function(buf, _)
          -- Directory buffers appears after restoring the session and
          -- they should be ignored.
          local buf_name = vim.api.nvim_buf_get_name(buf)
          local state = vim.uv.fs_stat(buf_name)
          if state and state.type == "directory" then
            return false
          end
          return true
        end,
      },
    },
  }
end

return M
