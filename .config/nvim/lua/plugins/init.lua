return {
  -- Core
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  { "williamboman/mason-lspconfig.nvim" },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufNewFile", "LspAttach", "BufReadPost" },
    opts = function()
      local config = require "configs.conform"
      config.format_on_save = { timeout_ms = 2500, lsp_fallback = true, async = true }
      return config
    end,
  },

  -- UI
  {
    "NvChad/ui",
    config = function()
      require "nvchad"
    end,
  },
  {
    "nvchad/base46",
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  {
    "zbirenbaum/neodim",
    event = "LspAttach",
    config = function()
      require("neodim").setup()
    end,
  },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    lazy = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "vim", "lua", "vimdoc", "html", "css" },
    },
  },

  -- Editing
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  {
    "Pocco81/auto-save.nvim",
    lazy = false,
    config = function()
      require("auto-save").setup()
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = true,
    config = function()
      require("nvim-surround").setup {}
    end,
  },
  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
    end,
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {},
  },

  -- { import = "nvchad.blink.lazyspec" },

  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10, -- Needs to be a really low priority, to catch others plugins keybindings.
    opts = {
      -- your configuration
    },
  },

  -- Multicursor
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    config = function()
      vim.keymap.set(
        "v",
        "<leader>m",
        "<cmd>MCstart<cr>",
        { desc = "Create a selection for selected text or word under the cursor" }
      )
    end,
  },

  -- LSP Extras
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lspsaga").setup { lightbulb = { enable = false } }
      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "jinzhongjia/LspUI.nvim",
    branch = "main",
    config = function()
      require("LspUI").setup()
    end,
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    event = "LspAttach",
    config = function()
      require("tiny-code-action").setup {}
    end,

    vim.keymap.set("n", "<leader>ca", function()
      require("tiny-code-action").code_action()
    end, { desc = "Code actions", noremap = true, silent = true }),
  },

  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    opts = function(_, opts)
      local trigger_text = ";"

      opts.enabled = function()
        local ft = vim.bo[0].filetype
        return not vim.tbl_contains({ "TelescopePrompt", "minifiles", "snacks_picker_input" }, ft)
      end

      opts.snippets = {
        preset = "luasnip",
      }

      opts.sources = {
        default = { "lsp", "snippets", "buffer", "path" },
        providers = {
          lsp = {
            module = "blink.cmp.sources.lsp",
            name = "LSP",
            score_offset = 90,
            min_keyword_length = 2,
          },
          path = {
            module = "blink.cmp.sources.path",
            name = "Path",
            score_offset = 25,
            fallbacks = { "snippets", "buffer" },
            opts = {
              label_trailing_slash = true,
              get_cwd = function(ctx)
                return vim.fn.expand(("#%d:p:h"):format(ctx.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },
          buffer = {
            module = "blink.cmp.sources.buffer",
            name = "Buffer",
            max_items = 3,
            min_keyword_length = 2,
            score_offset = 15,
          },
          snippets = {
            module = "blink.cmp.sources.snippets",
            name = "Snippets",
            max_items = 15,
            min_keyword_length = 2,
            score_offset = 85,
            should_show_items = function()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before = vim.api.nvim_get_current_line():sub(1, col)
              return before:match(trigger_text .. "%w*$") ~= nil
            end,
            transform_items = function(_, items)
              local line = vim.api.nvim_get_current_line()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before = line:sub(1, col)
              local start_pos, end_pos = before:find(trigger_text .. "[^" .. trigger_text .. "]*$")
              if start_pos then
                for _, item in ipairs(items) do
                  if not item.trigger_text_modified then
                    item.trigger_text_modified = true
                    item.textEdit = {
                      newText = item.insertText or item.label,
                      range = {
                        start = { line = vim.fn.line "." - 1, character = start_pos - 1 },
                        ["end"] = { line = vim.fn.line "." - 1, character = end_pos },
                      },
                    }
                  end
                end
              end
              return items
            end,
          },
        },
      }

      opts.formatting = {
        format_item = function(item)
          local icons = {
            Text = "",
            Method = "",
            Function = "",
            Constructor = "",
            Field = "",
            Variable = "",
            Class = "",
            Interface = "",
            Module = "",
            Property = "",
            Unit = "",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "",
            Event = "",
            Operator = "",
            TypeParameter = "",
          }
          item.label = (icons[item.kind] or "") .. " " .. item.label
          return item
        end,
      }

      opts.cmdline = {
        enabled = true,
        sources = {
          [":"] = { "path", "cmdline" },
          ["/"] = { "buffer" },
        },
      }

      opts.completion = {
        menu = { border = "single" },
        documentation = {
          auto_show = true,
          window = { border = "single" },
        },
      }

      opts.keymap = {
        preset = "none",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      }
      return opts
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- Misc
  { "wakatime/vim-wakatime", lazy = false },
  { "ellisonleao/carbon-now.nvim", lazy = true, cmd = "CarbonNow", opts = {} },

  -- Trouble Diagnostics
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },
}
