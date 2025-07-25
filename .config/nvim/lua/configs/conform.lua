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
    python = { "black" },
    go = { "gofmt" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    sql = { "sleek" },
    mysql = { "sleek" },
    pgsql = { "sleek" },
    plsql = { "sleek" },
  },

  formatters = {
    sleek = {
      command = "sleek",
      args = {
        "--uppercase=true",
        "--indent-spaces=4",
        "--lines-between-queries=2",
        "--trailing-newline=true",
      },
      stdin = true,
    },
  },

  -- format_on_save = {
  --   timeout_ms = 1000,
  --   lsp_fallback = true,
  -- },
}

return options
