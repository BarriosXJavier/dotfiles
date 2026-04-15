return {
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    opts = require("configs.conform"),
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    cmd = { "Oil" },
    keys = {
      { "<leader>o", "<cmd>Oil<CR>", desc = "Oil File Manager" },
    },
    opts = {},
    -- Optional dependencies
    dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
  },

  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriptreact", "typescriptreact", "vue", "svelte", "xml" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      automatic_installation = false,
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      require("configs.lspconfig")
    end,
  },

  {
    "okuuva/auto-save.nvim",
    version = "*",             -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
    cmd = "ASToggle",          -- optional for lazy loading on command
    event = { "InsertLeave" }, -- optional for lazy loading on trigger events
    opts = {},
  },
  {
    import = "nvchad.blink.lazyspec",
    opts = function()
      local base_opts = require("nvchad.blink.config")
      return vim.tbl_deep_extend("force", base_opts, {
        cmdline = {
          enabled = true,
          sources = { "cmdline", "path", "buffer" },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          providers = {
            lsp = {
              min_keyword_length = 2,
              score_offset = 10,
            },
            snippets = {
              min_keyword_length = 2,
              score_offset = 5,
            },
          },
        },
        completion = {
          auto_brackets = { enabled = false },
          trigger = {
            show_on_insert_on_trigger_character = true,
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = {
              -- border = "rounded",
            },
          },
          menu = {
            border = "rounded",
          },
        },
        signature = {
          enabled = true,
          window = {
            border = "rounded",
          },
        },
      })
    end,
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup()
      vim.diagnostic.config({ virtual_text = false, underline = true }) -- Disable Neovim's default virtual text diagnostics
    end,
  },

  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("configs.lspsaga").setup()
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      require("configs.treesitter").setup()
    end,
  },

  { "chentoast/marks.nvim",  event = "VeryLazy", opts = {} },

  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10,
    opts = {},
  },

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
    cmd = { "BlameToggle", "BlameEnable", "BlameDisable" },
    keys = {
      { "<leader>gb", "<cmd>BlameToggle<cr>", desc = "Toggle Git Blame" },
    },
    config = function()
      require("blame").setup({})
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      focus = true,
      modes = {
        diagnostics = {
          decorators = {
            line = true,
            indent = true,
          },
        },
      },
    },
    focus = true,
  },

  { "wakatime/vim-wakatime", lazy = false },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
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

  { "tpope/vim-dadbod" },

  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "UndotreeToggle" },
    keys = {
      { "<leader>u", function() require("undotree").toggle() end, desc = "Toggle Undo Tree" },
    },
    config = true,
  },

  -- debugger
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      {
        "jay-babu/mason-nvim-dap.nvim",
        opts = {
          automatic_installation = false,
        },
      },
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("configs.dap")
    end,
  },

  -- sqls plugin for SQL LSP enhancements
  {
    "nanotee/sqls.nvim",
    ft = { "sql", "mysql", "plsql" },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = { lsp = { enabled = true } },
    },
    event = "VeryLazy",
  },
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
  },

  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup({
        indicator = {
          enabled = true,
          icon = "󱓻 ",
        },
      })
    end,
  },

  {
    "michaelb/sniprun",
    cmd = { "SnipRun", "SnipClose", "SnipReset" },
    keys = {
      { "<leader>r",  "<Plug>SnipRun",      mode = { "n", "v" },           desc = "Run SnipRun" },
      { "<leader>rc", "<cmd>SnipClose<cr>", desc = "Close SnipRun results" },
      { "<leader>rs", "<cmd>SnipReset<cr>", desc = "Stop SnipRun" },
    },
    branch = "master",

    build = "sh install.sh 1",
    -- do 'sh install.sh 1' if you want to force compile locally
    -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

    config = function()
      require("sniprun").setup({
        -- your options
      })
    end,
  },

  {
    "blazkowolf/gruber-darker.nvim",
    lazy = false,
    config = function()
      require("gruber-darker").setup({
        bold = true,
        italic = {
          comments = true,
          strings = true,
        },
        invert = {
          signs = false,
          tabline = true,
          visual = false,
        },
      })
      vim.cmd.colorscheme("gruber-darker")

      local c = require("gruber-darker.palette")
      local hl = vim.api.nvim_set_hl

      hl(0, "NvimTreeNormal", { bg = c["bg-1"].hex })
      hl(0, "NvimTreeNormalNC", { bg = c["bg-1"].hex })
      hl(0, "NvimTreeEndOfBuffer", { fg = c["bg-1"].hex })
      hl(0, "NvimTreeFolderIcon", { fg = c.green.hex })
      hl(0, "NvimTreeFolderName", { fg = c.green.hex })
      hl(0, "NvimTreeOpenedFolderName", { fg = c.green.hex })
      hl(0, "NvimTreeFolderArrowOpen", { fg = c.quartz.hex })
      hl(0, "NvimTreeFolderArrowClosed", { fg = c.quartz.hex })
      hl(0, "NvimTreeIndentMarker", { fg = c["bg+2"].hex })
      hl(0, "NvimTreeRootFolder", { fg = c.red.hex, bold = true })
      hl(0, "NvimTreeWinSeparator", { fg = c["bg-1"].hex, bg = c["bg-1"].hex })
      hl(0, "NvimTreeCursorLine", { bg = c["bg+1"].hex })
      hl(0, "NvimTreeSpecialFile", { fg = c.yellow.hex, bold = true, underline = true })
      hl(0, "NvimTreeGitNew", { fg = c.yellow.hex })
      hl(0, "NvimTreeGitDeleted", { fg = c.red.hex })
      hl(0, "NvimTreeGitDirty", { fg = c.red.hex })
      hl(0, "NvimTreeGitIgnored", { fg = c.quartz.hex })
      hl(0, "NvimTreeEmptyFolderName", { fg = c.quartz.hex })
    end,
  }
}
