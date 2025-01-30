return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufNewFile", "LspAttach" },
    opts = function()
      local config = require "configs.conform"
      config.format_on_save = { timeout_ms = 500, lsp_fallback = true }
      return config
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
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

  { "wakatime/vim-wakatime", lazy = false },

  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
  },

  {
    "ellisonleao/carbon-now.nvim",
    lazy = true,
    cmd = "CarbonNow",
    opts = { --[[ your custom config here ]]
    },
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
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  { "williamboman/mason-lspconfig.nvim" },

  { "mfussenegger/nvim-dap" },

  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    lazy = false,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  { "nvim-tree/nvim-web-devicons" },

  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "magick" },
    },
  },

  {
    "3rd/image.nvim",
    dependencies = { "luarocks.nvim" },
    config = function()
      require("image").setup {
        backend = "ueberzug",
        max_height_window_percentage = 50,
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
      }
    end,
  },

  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup {}
    end,
    lazy = false,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    lazy = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup {}
    end,
  },

  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
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
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
    end,
  },

  {
    "jinzhongjia/LspUI.nvim",
    branch = "main",
    config = function()
      require("LspUI").setup {
        -- config options go here
      }
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    opts = {
      direction = "float",
    },
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    },
  },

  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup {
        lightbulb = {
          enable = false,
        },
      }
      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { noremap = true, silent = true })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
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
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- GitHub Copilot integration
      {
        "github/copilot.vim", -- Base Copilot plugin
      },
      {
        "zbirenbaum/copilot-cmp", -- CMP source for Copilot
        config = function()
          require("copilot_cmp").setup()
        end,
      },

      -- Command line completion
      {
        "hrsh7th/cmp-cmdline",
        event = "CmdlineEnter",
        config = function()
          local cmp = require "cmp"
          cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = { { name = "buffer" } },
          })

          cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
            matching = { disallow_symbol_nonprefix_matching = false },
          })
        end,
      },
    },

    opts = function(_, opts)
      -- Add Copilot as a completion source
      table.insert(opts.sources, 1, {
        name = "copilot",
        group_index = 1,
        priority = 100,
      })

      -- Optional: Configure trigger characters if needed
      opts.sources[1].trigger_characters = { "-" }
    end,
  },
}
