return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufNewFile", "LspAttach", "BufReadPost" },
    opts = function()
      local config = require "configs.conform"
      config.format_on_save = { timeout_ms = 500, lsp_fallback = true, async = true }
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

  --[[{
    "Exafunction/codeium.vim",
    event = "BufEnter",
  },
  ]]
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

  -- [[{
  --"zbirenbaum/copilot.lua",
  --cmd = "Copilot",
  --event = "InsertEnter",
  --config = function()
  --require("copilot").setup {}
  --end,
  -- }]],

  -- {
  --   "zbirenbaum/copilot-cmp",
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end,
  -- },

  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     -- -- GitHub Copilot integration
  --     -- {
  --     --   "github/copilot.vim", -- Base Copilot plugin
  --     -- },
  --     -- {
  --     --   "zbirenbaum/copilot-cmp", -- CMP source for Copilot
  --     --   config = function()
  --     --     require("copilot_cmp").setup()
  --     --   end,
  --     -- },
  --
  --     -- Command line completion
  --     {
  --       "hrsh7th/cmp-cmdline",
  --       event = "CmdlineEnter",
  --       config = function()
  --         local cmp = require "cmp"
  --         cmp.setup.cmdline("/", {
  --           mapping = cmp.mapping.preset.cmdline(),
  --           sources = { { name = "buffer" } },
  --         })
  --
  --         cmp.setup.cmdline(":", {
  --           mapping = cmp.mapping.preset.cmdline(),
  --           sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
  --           matching = { disallow_symbol_nonprefix_matching = false },
  --         })
  --       end,
  --     },
  --   },
  --
  --   opts = function(_, opts)
  --     -- Add Copilot as a completion source
  --     table.insert(opts.sources, 1, {
  --       name = "copilot",
  --       group_index = 1,
  --       priority = 100,
  --     })
  --
  --     -- Optional: Configure trigger characters if needed
  --     opts.sources[1].trigger_characters = { "-" }
  --   end,
  -- },
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

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },

  {
    "BarriosXJavier/tag-replacer.nvim",
    lazy = false,
    cmd = { "ReplaceTag", "ReplaceTagVisual" },
    config = function()
      require("tag-replacer").setup()
    end,
  },

  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = { "rafamadriz/friendly-snippets" },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = "default" },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
