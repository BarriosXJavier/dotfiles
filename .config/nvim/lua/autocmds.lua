vim.api.nvim_set_hl(0, "NvimTreeOpenedFile", { bold = true, italic = true })

local conform_notified = false
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    if conform_notified then
      return
    end

    local success, conform = pcall(require, "conform")
    if success then
      vim.notify "Conform attached."
      conform_notified = true
    end
  end,
})

vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})

