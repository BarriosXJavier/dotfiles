return {
  -----------------------------------------------------------------------------
  -- Core / Utility Plugins
  -----------------------------------------------------------------------------

  { "nvim-lua/plenary.nvim" },
  { "MunifTanjim/nui.nvim" },

  {
    "stevearc/conform.nvim",
    config = function(_, opts)
      require("conform").setup(opts)
    end,
    opts = require "configs.conform",
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format()
        end,
        mode = "n",
        desc = "Conform Format",
      },
    },
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  {
    "okuuva/auto-save.nvim",
    version = "*",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      execution_message = {
        enabled = false,
      },
      callbacks = {
        after_saving = function(buf)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
          local time = os.date "%H:%M:%S"
          vim.notify(("Auto-saved %s at %s"):format(filename, time), vim.log.levels.INFO, {
            title = "AutoSave",
            timeout = 2000,
          })
        end,
      },
    },
  },

  { "tpope/vim-dadbod" },

  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = {
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "undotree" },
    },
  },

  -- debugger
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "jay-babu/mason-nvim-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require "configs.dap"
    end,
  },

  -----------------------------------------------------------------------------
  -- LSP & Completion
  -----------------------------------------------------------------------------

  {
    "nanotee/sqls.nvim",
    vim.lsp.enable "sqls",
  },

  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lspconfig"
    end,
  },

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
  { "chentoast/marks.nvim", event = "VeryLazy", opts = {} },

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
    opts = { focus = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions/References",
      },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
    },

    focus = true,
  },

  -----------------------------------------------------------------------------
  -- Aesthetics & UI
  -----------------------------------------------------------------------------
  { "wakatime/vim-wakatime", lazy = false },
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
    opts = {},
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = false },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = false },
      notifier = {
        enabled = true,
        timeout_ms = 2500,
        width = { min = 40, max = 0.3 },
        styles = {
          border = "rounded",
          zindex = 100,
          ft = "markdown",
          wo = {
            winblend = 5,
            wrap = false,
            conceallevel = 2,
            colorcolumn = "",
          },
          bo = { filetype = "snacks_notif" },
        },

        vim.keymap.set("n", "<leader>sh", function()
          require("snacks.notifier").show_history()
        end, { desc = "show notification history" }),
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
  },
}
