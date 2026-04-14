-- Load NvChad defaults first
require("nvchad.autocmds")

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    vim.cmd.colorscheme("gruber-darker")
  end,
})
