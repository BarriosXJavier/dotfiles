require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Toggle nvim tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle Nvim Tree" })

-- Resize splits with arrow keys
map("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, desc = "Resize split: Shrink" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, desc = "Resize split: Expand" })

-- Scroll down/up and center the screen
map("n", "<C-d>", "<C-d>zz", { noremap = true, desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { noremap = true, desc = "Scroll up and center" })

map(
	"n",
	"<leader>tp",
	require("configs.tokyonight-picker").pick_tokyonight_variant,
	{ desc = "Pick tokyonight variant" }
)

map("i", "<M-l>", "<Plug>(copilot-accept)", { desc = "Copilot: Accept suggestion" })
map("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Copilot: Next suggestion" })
map("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Copilot: Previous suggestion" })
map("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Copilot: Dismiss suggestion" })

map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "LSP: Code Action" })

