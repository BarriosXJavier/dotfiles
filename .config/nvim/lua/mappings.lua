require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

-- resize with arrows
map("n", "<C-Left>", ":vertical resize -2<CR>", nore)
map("n", "<C-Right>", ":vertical resize +2<CR>", nore)



