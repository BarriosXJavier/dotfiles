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

