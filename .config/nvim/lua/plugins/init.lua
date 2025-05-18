return {

  --󰒓 CORE / LSP ----------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  { "williamboman/mason-lspconfig.nvim" },

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
                  timeout_ms = 2500,
                  async = false,
                }
              end,
            })
          end
        end,
      }
    end,
  },

  -- LSP UX --------------------------------------------------------------------

  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lspsaga").setup {
        ui = { border = "rounded", title = true, winblend = 10, devicon = true },
        lightbulb = { enable = false },
      }
      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { noremap = true, silent = true })
    end,
  },

  {
    "rachartier/tiny-code-action.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("tiny-code-action").setup {}
      vim.keymap.set("n", "<leader>ca", function()
        require("tiny-code-action").code_action()
      end, { desc = "Code actions", noremap = true, silent = true })
    end,
  },

  -- COMPLETION ----------------------------------------------------------------

  {
    "saghen/blink.cmp",
    lazy = false,
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets", "hrsh7th/nvim-cmp" },
    opts = {
      keymap = {
        preset = "default",
      },
      appearance = { nerd_font_variant = "mono" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      cmdline = {
        enabled = true,
        sources = { "path", "lsp" },
      },
      signature = { enabled = true },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default", "cmdline.sources" },
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
      ensure_installed = { "vim", "lua", "vimdoc", "html", "css" },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    lazy = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = true,
  },

  { "catgoose/nvim-colorizer.lua",      event = "BufReadPre",  opts = {} },
  { "rachartier/tiny-glimmer.nvim",     event = "VeryLazy",    priority = 10, opts = {} },

  -- EDITING / DEV UX ----------------------------------------------------------

  { "windwp/nvim-autopairs",            event = "InsertEnter", config = true },

  {
    "okuuva/auto-save.nvim",
    version = "^1.0.0",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {},
  },

  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "astro",
    },
    opts = {},
  },

  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, "<leader>xe", require("nvim-emmet").wrap_with_abbreviation)
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = {},
      explorer = {},
      indent = {},
      input = {},
      picker = {},
      notifier = {},
      quickfile = {},
      scope = {},
      scroll = {},
      statuscolumn = {},
      words = {},
    },
  },

  -- DIAGNOSTICS / NAV --------------------------------------------------------

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / refs" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)" },
    },
  },

  --🔧 TOOLS --------------------------------------------------------------------

  { "wakatime/vim-wakatime",       lazy = false },
  { "ellisonleao/carbon-now.nvim", lazy = true, cmd = "CarbonNow", opts = {} },

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
}
