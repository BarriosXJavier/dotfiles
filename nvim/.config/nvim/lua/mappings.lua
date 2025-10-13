require("nvchad.mappings")

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Lsp saga
map("n", "K", "<cmd>Lspsaga hover_doc<CR>", { noremap = true, silent = true })
map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "LSP: Code Action" })

-- Toggle nvim tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle Nvim Tree" })

-- Resize splits with arrow keys
map("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, desc = "Resize split: Shrink" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, desc = "Resize split: Expand" })

-- Scroll down/up and center the screen
map("n", "<C-d>", "<C-d>zz", { noremap = true, desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { noremap = true, desc = "Scroll up and center" })

map("i", "<M-l>", "<Plug>(copilot-accept)", { desc = "Copilot: Accept suggestion" })
map("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Copilot: Next suggestion" })
map("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Copilot: Previous suggestion" })
map("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Copilot: Dismiss suggestion" })

-- Trouble nvim
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map(
	"n",
	"<leader>cl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ desc = "LSP Definitions/References" }
)
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List" })
map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List" })

-- undo tree
map("n", "<leader><F5>", "<cmd>UndotreeToggle<cr>", { desc = "Nvim Undotree" })

-- Copilot mappings
-- Copilot inline suggestions
map("i", "<C-l>", function()
	require("copilot.suggestion").accept()
end, { desc = "Copilot: accept suggestion" })

map("i", "<M-]>", function()
	require("copilot.suggestion").next()
end, { desc = "Copilot: next suggestion" })

map("i", "<M-[>", function()
	require("copilot.suggestion").prev()
end, { desc = "Copilot: previous suggestion" })

map("i", "<C-e>", function()
	require("copilot.suggestion").dismiss()
end, { desc = "Copilot: dismiss suggestion" })
