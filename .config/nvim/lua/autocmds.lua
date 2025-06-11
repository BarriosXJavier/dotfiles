local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local autosave_group = augroup("autosave", { clear = true })

local function is_saveable(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  local ft = vim.bo[bufnr].filetype
  local mod = vim.bo[bufnr].modified
  local listed = vim.bo[bufnr].buflisted
  local name = vim.api.nvim_buf_get_name(bufnr)
  if not mod or not listed then
    return false
  end
  if name == "" then
    return false
  end
  if ft == "help" or ft == "terminal" or ft == "nofile" then
    return false
  end
  return true
end

autocmd({ "BufLeave", "InsertLeave", "TextChanged", "VimLeavePre" }, {
  group = autosave_group,
  callback = function(event)
    if is_saveable(event.buf) then
      vim.schedule(function()
        if is_saveable(event.buf) then
          vim.api.nvim_buf_call(event.buf, function()
            vim.lsp.buf.format { bufnr = event.buf }
            vim.cmd "silent! write"
            local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(event.buf), ":t")
            vim.notify(("Saved %s at %s"):format(fname, os.date "%H:%M:%S"), vim.log.levels.INFO, {
              title = "AutoSave",
              timeout = 2500,
            })
          end)
        end
      end)
    end
  end,
})
vim.api.nvim_set_hl(0, "NvimTreeOpenedFile", { bold = true, italic = true })
