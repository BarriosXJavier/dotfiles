require("auto-save").setup({
  cmd = "ASToggle",
  event = { "InsertLeave", "TextChanged" },
})

local group = vim.api.nvim_create_augroup("autosave", {})

vim.api.nvim_create_autocmd("User", {
  pattern = "AutoSaveWritePost",
  group = group,
  callback = function(opts)
    local buf = opts.data.saved_buffer
    if buf then
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
      local time = os.date("%H:%M:%S")
      vim.notify(("Auto-saved %s at %s"):format(filename, time), vim.log.levels.INFO, {
        title = "AutoSave",
        timeout = 2000,
      })
    end
  end,
})

