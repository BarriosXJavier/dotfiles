require "nvchad.options"

local o = vim.o

-- UI
o.cursorlineopt = "both"
o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.scrolloff = 8
o.linebreak = true
o.breakindent = true
o.termguicolors = true
o.guicursor = "n-v-c-sm:block-blinkon0,"
  .. "i-ci:block-blinkwait0-blinkon50-blinkoff50,"
  .. "r-cr:block-blinkwait0-blinkon50-blinkoff50"

-- Editing
o.clipboard = "unnamedplus"
o.hidden = true
o.updatetime = 300

-- Tabs & Indent (default)
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = false
o.smartindent = true

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true
