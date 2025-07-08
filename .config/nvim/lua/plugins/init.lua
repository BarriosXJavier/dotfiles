return {
  -----------------------------------------------------------------------------
  -- Core / Utility Plugins
  -----------------------------------------------------------------------------
  { "nvim-lua/plenary.nvim" },
  { "MunifTanjim/nui.nvim" },

  {
    "nvimtools/none-ls.nvim",
    event = { "BufWritePre", "BufNewFile", "LspAttach", "BufReadPost" },
    opts = function()
      local null_ls = require "null-ls"
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      return {
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylua,
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
                vim.lsp.buf.format {
                  bufnr = bufnr,
                  timeout_ms = 5000,
                  async = false,
                }
              end,
            })
          end
        end,
      }
    end,
  },

  {
    "folke/trouble.nvim",
    opts = { focus = true },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Creates a beautiful debugger UI
      "rcarriga/nvim-dap-ui",

      -- Required dependency for nvim-dap-ui
      "nvim-neotest/nvim-nio",

      -- Language-specific debuggers
      "leoluz/nvim-dap-go", -- Golang

      -- Shows variable values inline as virtual text
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      {
        "<leader>Dc",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Start/Continue",
      },
      {
        "<leader>Dsi",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },
      {
        "<leader>DsO",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over",
      },
      {
        "<leader>Dso",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },
      {
        "<leader>Db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle Breakpoint",
      },
      {
        "<leader>DB",
        function()
          require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
        end,
        desc = "Debug: Set Conditional Breakpoint",
      },
      {
        "<leader>Dt",
        function()
          require("dapui").toggle()
        end,
        desc = "Debug: Toggle UI",
      },
      {
        "<leader>Dl",
        function()
          require("dap").run_last()
        end,
        desc = "Debug: Run Last Configuration",
      },
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      -- Dap UI setup
      dapui.setup {
        icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
        controls = {
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
          },
        },
      }

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close

      -- Setup virtual text to show variable values inline
      require("nvim-dap-virtual-text").setup()

      require("dap-go").setup {
        delve = {
          -- Use Mason's delve installation with fallback to system delve
          path = function()
            local mason_delve = vim.fn.stdpath "data" .. "/mason/bin/dlv"
            if vim.fn.executable(mason_delve) == 1 then
              return mason_delve
            end
            -- Fallback to system delve
            return vim.fn.exepath "dlv" ~= "" and vim.fn.exepath "dlv" or "dlv"
          end,

          -- On Windows delve must be run attached or it crashes.
          -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
          -- detached = vim.fn.has 'win32' == 0,
        },
      }
    end,
  },


  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
    },
  },
  -----------------------------------------------------------------------------
  -- LSP & Completion
  -----------------------------------------------------------------------------
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = function()
      require "configs.lspconfig"
    end,
  },
  { "hinell/lsp-timeout.nvim",     dependencies = { "neovim/nvim-lspconfig" } },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup { preset = "classic" }
      vim.diagnostic.config { virtual_text = false }
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup(require("configs.nvimtree").override_options)
    end,
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
    },
    config = require("configs.nvim-cmp").setup,
    opts = require("configs.nvim-cmp").opts,
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
        lightbulb = { enable = false },
      }
      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { noremap = true, silent = true })
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {},
  },
  {
    "jinzhongjia/LspUI.nvim",
    branch = "main",
    config = function()
      require("LspUI").setup {}
    end,
  },
  {
    "rachartier/tiny-code-action.nvim",
    lazy = false,
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

  -----------------------------------------------------------------------------
  -- DAP
  -----------------------------------------------------------------------------
  { "mfussenegger/nvim-dap" },
  { "jay-babu/mason-nvim-dap.nvim" },
  { "rcarriga/nvim-dap-ui",        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },

  -----------------------------------------------------------------------------
  -- File Management & Navigation
  -----------------------------------------------------------------------------
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = require("configs.bufferline").setup,
  },

  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "stevearc/oil.nvim",
    opts = { set_default_explorer = false },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
  },
  { "chentoast/marks.nvim",        event = "VeryLazy",   opts = {} },

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

  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require("blame").setup {}
    end,
  },

  -----------------------------------------------------------------------------
  -- Diagnostics & LSP Utilities
  -----------------------------------------------------------------------------
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",      desc = "Symbols (Trouble)" },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions/References",
      },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",  desc = "Quickfix List" },
    },
  },

  -----------------------------------------------------------------------------
  -- Aesthetics & UI
  -----------------------------------------------------------------------------
  { "wakatime/vim-wakatime",       lazy = false },
  { "catgoose/nvim-colorizer.lua", event = "BufReadPre", opts = {} },

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
      ensure_installed = { "vim", "lua", "vimdoc", "html", "css" },
    },
  },
  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
    end,
  },

  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = require("configs.notify").setup,
  },

  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = require("configs.noice").setup,
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },

  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = { cursor = {}, scroll = {}, resize = {} },
  },

  {
    "nvim-lualine/lualine.nvim",
    event = { "VimEnter", "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = require("configs.lualine").setup,
  },

  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10, -- Needs to be a really low priority, to catch others plugins keybindings.
    opts = {
      -- your configuration
    },
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = true },
      input = { enabled = false },
      picker = { enabled = false },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
}
