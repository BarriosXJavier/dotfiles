local M = {}
function M.setup()
  require("noice").setup {
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "virtualtext",
    },
    cmdline = { enabled = true },
    popupmenu = { enabled = true },
    notify = {
      enabled = true,
    },
    lsp = {
      progress = {
        enabled = false,
        hover = { enabled = false },
        signature = { enabled = false },
        message = { enabled = false },
      },
    },
    views = {
      messages = { view = "cmdline" },
      notify = {
        backend = "notify",
        replace = false,
      },
    },

    routes = {
      {
        filter = {
          event = "msg_show",
        },
        opts = { skip = false },
      },
    },

    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
  }
end

return M
