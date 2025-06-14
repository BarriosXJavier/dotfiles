local options = {
  formatters_by_ft = {
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    json = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    toml = { "prettier" },

    lua = { "stylua" },
    rust = { "rustfmt" },
    python = { "autopep8" },
    go = { "gofmt" },
    c = { "clang-format" },
    cpp = { "clang-format" },
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}

return options
