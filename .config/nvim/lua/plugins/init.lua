return {
  -----------------------------------------------------------------------------
  -- Core / Utility Plugins
  -----------------------------------------------------------------------------
  { "nvim-lua/plenary.nvim" }, -- Common utilities for other plugins
  { "MunifTanjim/nui.nvim" }, -- UI components for other plugins
  { "rcarriga/nvim-notify" }, -- Notifications

  -----------------------------------------------------------------------------
  -- LSP & Completion
  -----------------------------------------------------------------------------
  { "williamboman/mason.nvim" }, -- Plugin manager for LSP servers and formatters
  { "williamboman/mason-lspconfig.nvim" }, -- Bridges Mason and nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  { "hinell/lsp-timeout.nvim", dependencies = { "neovim/nvim-lspconfig" } },
  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
      local null_ls = require "null-ls"
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      return {
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.formatting.isort,
        },
        on_attach = function(client, bufnr)
          if client.supports_method "textDocument/formatting" then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { bufnr = bufnr }
              end,
            })
          end
        end,
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
      { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
      "windwp/nvim-autopairs",
      {
        "zbirenbaum/copilot-cmp", -- CMP source for Copilot
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
    config = function()
      local cmp = require "cmp"
      local lspkind = require "lspkind"
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"

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
    end,

    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "copilot",
        group_index = 1,
        priority = 100,
      })
      opts.sources[1].trigger_characters = { "-" }
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {}
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {}, -- See Configuration section for options
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "jinzhongjia/LspUI.nvim",
    branch = "main",
    config = function()
      require("LspUI").setup {} -- config options go here
    end,
  },
  {
    "tiny-code-action.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    event = "LspAttach",
    config = function()
      require("tiny-code-action").setup {}
      vim.keymap.set("n", "<leader>ca", function()
        require("tiny-code-action").code_action()
      end, { desc = "Code actions", noremap = true, silent = true })
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lspsaga").setup {
        ui = {
          border = "rounded",
          title = true,
          winblend = 10,
          devicon = true,
        },
        lightbulb = {
          enable = false,
        },
      }
      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { noremap = true, silent = true })
    end,
  },

  -----------------------------------------------------------------------------
  -- Debugging
  -----------------------------------------------------------------------------
  -- The commented out `nvim-dap` plugin should be here. If you uncomment it,
  -- make sure to remove it from the `mason` plugin's dependency list.
  -- {
  --   "mfussenegger/nvim-dap",
  --   lazy = true,
  --   keys = {
  --     {
  --       "<leader>db",
  --       function()
  --         require("dap").toggle_breakpoint()
  --       end,
  --       { desc = "Toggle breakpoint" },
  --     },
  --     "<leader>dc",
  --     function()
  --       require("dap").continue()
  --     end,
  --     "<leader>dC",
  --     function()
  --       require("dap").run_to_cursor()
  --     end,
  --     "<leader>dT",
  --     function()
  --       require("dap").terminate()
  --     end,
  --   },
  -- },
  { "mfussenegger/nvim-dap" },
  { "jay-babu/mason-nvim-dap.nvim" }, -- DAP integrations for Mason
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },

  -----------------------------------------------------------------------------
  -- File Management & Navigation
  -----------------------------------------------------------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    opts = {
      close_if_last_window = false,
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        indent = { padding = 1 },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰜌",
          default = "",
        },
        modified = { symbol = "[+]" },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "",
            renamed = "➜",
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "✓",
            conflict = "",
          },
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["<space>"] = "none",
        },
      },
    },
    config = function()
      vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#999999" })
    end,
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = { set_default_explorer = false },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -----------------------------------------------------------------------------
  -- Git Integration
  -----------------------------------------------------------------------------
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  -----------------------------------------------------------------------------
  -- Diagnostics & LSP Utilities
  -----------------------------------------------------------------------------
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

  -----------------------------------------------------------------------------
  -- Aesthetics & UI
  -----------------------------------------------------------------------------
  { "wakatime/vim-wakatime", lazy = false },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {},
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    lazy = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup {
        options = {
          offsets = {
            {
              filetype = "neo-tree",
              text = "Neotree file explorer",
              separator = true,
              text_align = "center",
              width = 30,
            },
          },
        },
      }
    end,
  },
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10,
    opts = {},
  },
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
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged", "FocusLost" },
    opts = {
      enabled = true,
      trigger_events = { "InsertLeave", "TextChanged" },
      debounce_delay = 135,
      condition = function(buf)
        local fn = vim.fn
        return fn.getbufvar(buf, "&modifiable") == 1
      end,
    },
  },
  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
    end,
  },

  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = { cursor = {}, scroll = {}, resize = {} },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = { theme = "dracula", globalstatus = true },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
