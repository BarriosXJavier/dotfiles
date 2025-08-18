require "nvchad.mappings"
local tokyonight = require("configs.tokyonight")

local map = vim.keymap.set



-- Normal mode for faster command mode
map("n", ";", ":", { desc = "CMD: Enter command mode" })

-- jk to escape insert mode
map("i", "jk", "<ESC>", { desc = "Esc: Escape insert mode" })

-- Toggle nvim tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle Nvim Tree" })

-- Resize splits with arrow keys
map("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, desc = "Resize split: Shrink" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, desc = "Resize split: Expand" })

-- Scroll down/up and center the screen
map("n", "<C-d>", "<C-d>zz", { noremap = true, desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { noremap = true, desc = "Scroll up and center" })

-- Auto save toggle
map("n", "<leader>as", "<cmd>ASToggle<CR>", { desc = "Toggle Autosave" })

-- snacks notification
map("n", "<leader>sh", function()
  require("snacks.notifier").show_history()
end, { desc = "show notification history" })

-- Conform format
map("n", "<leader>F", function()
  require("conform").format()
end, { desc = "Conform format" })


map("n", "<leader>tt", function()
  require("configs.tokyonight").pick_variant()
end, { desc = "Pick TokyoNight variant" })
