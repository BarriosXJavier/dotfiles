vim.g.mapleader = " "

-- Base46 theme cache path
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

-- ╭──────────────────────────────────────────────────────────╮
-- │                       Editor Settings                    │
-- ╰──────────────────────────────────────────────────────────╯
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 0
vim.opt.breakindent = true
vim.opt.scrolloff = 8

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.incsearch = true
vim.opt.guicursor = {
  "n-v-c:block-Cursor",
  "i-ci:blinkon200-blinkoff200-blinkwait200-block-Cursor",
  "r:blinkon200-blinkoff200-blinkwait200-block-Cursor",
}

-- ╭──────────────────────────────────────────────────────────╮
-- │                    Lazy Plugin Manager                   │
-- ╰──────────────────────────────────────────────────────────╯
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    repo,
    "--branch=stable",
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "*",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, lazy_config)

-- ╭──────────────────────────────────────────────────────────╮
-- │                       Load Theme                         │
-- ╰──────────────────────────────────────────────────────────╯
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- ╭──────────────────────────────────────────────────────────╮
-- │                   Core Modules (Opt/Maps)                │
-- ╰──────────────────────────────────────────────────────────╯
require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
