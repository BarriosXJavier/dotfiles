vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 80
vim.opt.scrolloff = 8
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.guicursor = {
  "n-v-c:block-Cursor", -- Steady block in Normal/Visual/Command-line
  "i-ci:blinkon100-blinkoff100-blinkwait1000-block-Cursor", -- Blinking block in Insert/Command-line Insert
  "r:blinkon100-blinkoff100-blinkwait500-hor100-Cursor", -- Blinking thick horizontal in Replace mode
}
vim.opt.rtp:prepend(lazypath)
vim.keymap.set("n", "<leader>fm", function()
  require("conform").format {
    async = true,
    timeout_ms = 2500, -- Adjust timeout if necessary
    lsp_fallback = true,
  }
end, { desc = "Format file with conform" })

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

require("tag-replacer").setup()

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
