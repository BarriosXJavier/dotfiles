vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 0
vim.opt.breakindent = true
vim.opt.scrolloff = 8
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.guicursor = {
"n-v-c:block-Cursor", -- Steady block in Normal/Visual/Command-line
"i-ci:blinkon100-blinkoff100-blinkwait1000-block-Cursor", -- Blinking block in Insert/Command-line Insert
"r:blinkon100-blinkoff100-blinkwait1000-block-Cursor", -- Blinking block in Replace mode
}

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
local repo = "https://github.com/folke/lazy.nvim.git"
vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

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

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
require "mappings"
end)
