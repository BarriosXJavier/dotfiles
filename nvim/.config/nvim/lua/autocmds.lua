-- Load NvChad defaults first
require("nvchad.autocmds")

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    vim.cmd.colorscheme("gruber-darker")
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local hl = vim.api.nvim_set_hl
    local nb = "#c0cfe8"
    local lang = vim.bo[args.buf].filetype
    hl(0, "GruberDarkerDarkNiagara", { fg = nb })
    hl(0, "@lsp.type.property." .. lang, { fg = nb })
    hl(0, "@lsp.typemod.property.declaration." .. lang, { fg = nb })
  end,
})
