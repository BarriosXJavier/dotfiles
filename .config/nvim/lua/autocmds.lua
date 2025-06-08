require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local autosave_group = augroup("autosave", { clear = true })

autocmd({ "BufLeave", "InsertLeave", "FocusLost", "TextChanged", "VimLeavePre" }, {
  group = autosave_group,
  callback = function(event)
    if vim.bo[event.buf].modified then
      vim.schedule(function()
        vim.api.nvim_buf_call(event.buf, function()
          vim.lsp.buf.format { bufnr = event.buf }
          vim.cmd "silent! write"
          local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(event.buf), ":t")
          vim.notify("Saved " .. fname .. " at " .. os.date "%H:%M:%S", vim.log.levels.INFO, {
            title = "AutoSave",
            timeout = 2000,
          })
        end)
      end)
    end
  end,
})
