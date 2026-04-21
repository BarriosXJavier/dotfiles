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
      require("configs.lspsaga").setup(

      )
      vim.api.nvim_set_hl(0, "SagaNormal", { bg = "none" })
      vim.api.nvim_set_hl(0, "SagaBorder", { bg = "none" })
      vim.api.nvim_set_hl(0, "SagaTitle", { bg = "none" })
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
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      { "blazkowolf/gruber-darker.nvim",
      },
    },
    config = function()
      local c = require("gruber-darker.palette")
      require("bufferline").setup({
        highlights = {
          fill                        = { bg = c["bg-1"].value },
          background                  = { fg = c.quartz.value, bg = c["bg-1"].value },
          buffer_selected             = { fg = c.fg.value, bg = c.bg.value, bold = true, italic = true },
          buffer_visible              = { fg = c.quartz.value, bg = c["bg-1"].value },
          close_button                = { fg = c.quartz.value, bg = c["bg-1"].value },
          close_button_selected       = { fg = c.red.value, bg = c.bg.value },
          close_button_visible        = { fg = c.quartz.value, bg = c["bg-1"].value },
          separator                   = { fg = c["bg-1"].value, bg = c["bg-1"].value },
          separator_selected          = { fg = c["bg-1"].value, bg = c.bg.value },
          separator_visible           = { fg = c["bg-1"].value, bg = c["bg-1"].value },
          indicator_selected          = { fg = c.yellow.value, bg = c.bg.value },
          indicator_visible           = { fg = c["bg-1"].value, bg = c["bg-1"].value },
          modified                    = { fg = c.yellow.value, bg = c["bg-1"].value },
          modified_selected           = { fg = c.yellow.value, bg = c.bg.value },
          modified_visible            = { fg = c.yellow.value, bg = c["bg-1"].value },
          duplicate                   = { fg = c.quartz.value, bg = c["bg-1"].value, italic = true },
          duplicate_selected          = { fg = c.fg.value, bg = c.bg.value, italic = true },
          duplicate_visible           = { fg = c.quartz.value, bg = c["bg-1"].value, italic = true },
          numbers                     = { fg = c.quartz.value, bg = c["bg-1"].value },
          numbers_selected            = { fg = c.fg.value, bg = c.bg.value, bold = true },
          numbers_visible             = { fg = c.quartz.value, bg = c["bg-1"].value },
          diagnostic                  = { fg = c.quartz.value, bg = c["bg-1"].value },
          diagnostic_selected         = { fg = c.fg.value, bg = c.bg.value },
          diagnostic_visible          = { fg = c.quartz.value, bg = c["bg-1"].value },
          error                       = { fg = c.red.value, bg = c["bg-1"].value },
          error_selected              = { fg = c.red.value, bg = c.bg.value, bold = true },
          error_visible               = { fg = c.red.value, bg = c["bg-1"].value },
          error_diagnostic            = { fg = c.red.value, bg = c["bg-1"].value },
          error_diagnostic_selected   = { fg = c.red.value, bg = c.bg.value },
          warning                     = { fg = c.yellow.value, bg = c["bg-1"].value },
          warning_selected            = { fg = c.yellow.value, bg = c.bg.value, bold = true },
          warning_visible             = { fg = c.yellow.value, bg = c["bg-1"].value },
          warning_diagnostic          = { fg = c.yellow.value, bg = c["bg-1"].value },
          warning_diagnostic_selected = { fg = c.yellow.value, bg = c.bg.value },
          info                        = { fg = c.quartz.value, bg = c["bg-1"].value },
          info_selected               = { fg = c.fg.value, bg = c.bg.value, bold = true },
          info_visible                = { fg = c.quartz.value, bg = c["bg-1"].value },
          hint                        = { fg = c.quartz.value, bg = c["bg-1"].value },
          hint_selected               = { fg = c.fg.value, bg = c.bg.value, bold = true },
          hint_visible                = { fg = c.quartz.value, bg = c["bg-1"].value },
          tab                         = { fg = c.quartz.value, bg = c["bg-1"].value },
          tab_selected                = { fg = c.fg.value, bg = c.bg.value, bold = true },
          tab_close                   = { fg = c.red.value, bg = c["bg-1"].value },
          tab_separator               = { fg = c["bg-1"].value, bg = c["bg-1"].value },
          tab_separator_selected      = { fg = c["bg-1"].value, bg = c.bg.value },
          offset_separator            = { fg = c["bg-1"].value, bg = c["bg-1"].value },
        },
        options = {
          separator_style         = { "", "" },
          show_close_icon         = true,
          bold                    = true,
          show_buffer_close_icons = true,
          offsets                 = {
            {
              filetype   = "NvimTree",
              text       = "NvimTree",
              highlight  = "Directory",
              text_align = "center",
              separator  = true,
            },
          },
        },
      })
    end,
  },

  {
    "echasnovski/mini.bufremove",
    version = false,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      view = {
        float = {
          enable = true,
          open_win_config = function()
            local columns = vim.o.columns
            local lines = vim.o.lines
            local cmdheight = vim.o.cmdheight

            local usable_height = lines - cmdheight

            local width = math.floor(columns * 0.5)
            local height = math.floor(usable_height * 0.8)

            local col = math.floor((columns - width) / 2)
            local row = math.floor((usable_height - height) / 2)

            return {
              relative = "editor",
              border = "rounded",
              width = width,
              height = height,
              col = col,
              row = row,
            }
          end,
        },
      },
    },
  }
}
