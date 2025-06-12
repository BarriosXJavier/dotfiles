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
        message = { enabled = false },
      },
      hover = { enabled = false },
      signature = { enabled = false },
    },
    views = {
      messages = { view = "cmdline" },
      notify = {
        backend = "notify",
        replace = false,
      },
      mini = {
        backend = "mini",
        relative = "editor",
        align = "message-right",
        timeout = 2500,
        reverse = true,
      },
    },

    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "recording @" },
            { find = "search hit" },
            { find = "Pattern not found" },
            { find = "%d+ change" },
            { find = "%d+ line" },
            { find = "Already at" },
          },
        },
        view = "mini",
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
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
