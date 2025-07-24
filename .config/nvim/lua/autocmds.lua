vim.api.nvim_set_hl(0, "NvimTreeOpenedFile", { bold = true, italic = true })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local success, conform = pcall(require, "conform")
    if success then
      vim.notify "Conform is available. You can now attach format-on-save manually if needed."
    end
  end,
})
