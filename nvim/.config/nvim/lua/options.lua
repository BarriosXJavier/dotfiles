-- overrides for nvchad.options

require("nvchad.options")

local o = vim.o

-- UI
o.cursorlineopt = "both" -- highlight line & number
o.number = true -- absolute line number
o.relativenumber = true -- relative line numbers
o.signcolumn = "yes" -- always show sign column (git, lsp)
o.scrolloff = 8 -- padding around cursor
o.wrap = false -- no line wrap (keeps code readable)
o.termguicolors = true -- better colors

-- Editing
o.clipboard = "unnamedplus" -- system clipboard
o.hidden = true -- keep buffers in background
o.updatetime = 300 -- faster diagnostics update

-- Tabs & Indent
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true -- spaces instead of tabs
o.smartindent = true -- smarter autoindent

-- Search
o.ignorecase = true -- case-insensitive search…
o.smartcase = true -- …unless uppercase is used
o.hlsearch = true -- highlight matches
o.incsearch = true -- live incremental search
