local M = {}

function M.setup()
  local cmp_ok, cmp = pcall(require, "cmp")
  local lspkind_ok, lspkind = pcall(require, "lspkind")
  local autopairs_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
  if not (cmp_ok and lspkind_ok and autopairs_ok) then
    vim.notify("nvim-cmp setup skipped due to missing deps", vim.log.levels.WARN)
    return
  end

  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

  cmp.setup {
    mapping = cmp.mapping.preset.insert {
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<Tab>"] = cmp.mapping.select_next_item(),
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    formatting = {
      format = lspkind.cmp_format {
        mode = "symbol_text",
        maxwidth = 50,
        ellipsis_char = "...",
        symbol_map = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "",
          Field = "󰜢",
          Variable = "󰀫",
          Class = "󰠱",
          Interface = "",
          Module = "",
          Property = "󰜢",
          Unit = "󰑭",
          Value = "󰎠",
          Enum = "",
          Keyword = "󰌋",
          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          EnumMember = "",
          Constant = "󰏿",
          Struct = "󰙅",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "",
        },
      },
    },
    sources = cmp.config.sources {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "friendly-snippets" },
      { name = "buffer" },
      { name = "path" },
    },
  }

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
  })
end

M.opts = function(_, opts)
  table.insert(opts.sources, 1, {
    name = "copilot",
    group_index = 1,
    priority = 100,
    trigger_characters = { "-" },
  })
end

return M
