vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "

vim.opt.textwidth = 80
-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

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

require("base46").load_all_highlights()

-- load options, autocmds, mappings
require("options")
require("autocmds")
vim.schedule(function()
	require("mappings")
end)

local variant_file = vim.fn.stdpath("data") .. "/.tokyonight_variant"
local file = io.open(variant_file, "r")
if file then
  local variant = file:read("*a")
  file:close()
  if variant and variant ~= "" then
    vim.defer_fn(function()
      vim.cmd("colorscheme " .. variant)
    end, 100)
  end
end
