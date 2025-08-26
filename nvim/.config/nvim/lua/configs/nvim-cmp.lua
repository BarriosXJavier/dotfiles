local M = {}

function M.setup(_, opts)
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
      format = function(entry, vim_item)
        local source_labels = {
          luasnip = "[Snip]",
          friendly_snippets = "[FSnip]",
          buffer = "[Buffer]",
          path = "[Path]",
          copilot = "[AI]",
          cmdline = "[Cmd]",
        }

        if entry.source.name == "nvim_lsp" then
          local client = entry.source.source.client
          vim_item.menu = client and ("[" .. client.name .. "]") or "[LSP]"
        else
          vim_item.menu = source_labels[entry.source.name] or ("[" .. entry.source.name .. "]")
        end

        return require("lspkind").cmp_format {
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
        }(entry, vim_item)
      end,
    },
    sources = opts.sources,
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.priority,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
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

M.opts = function()
  return {
    sources = {
      { name = "nvim_lsp", priority = 10 },
      { name = "luasnip", priority = 8 },
      { name = "friendly-snippets", priority = 8 },
      { name = "buffer", priority = 5 },
      { name = "path", priority = 4 },
      {
        name = "copilot",
        group_index = 1,
        priority = 100,
        trigger_characters = { "-" },
      },
    },
  }
end

return M
