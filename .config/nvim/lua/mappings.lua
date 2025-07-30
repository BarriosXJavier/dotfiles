require("nvchad.mappings")

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
