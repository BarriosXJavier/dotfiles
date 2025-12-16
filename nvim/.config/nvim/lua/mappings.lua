require("nvchad.mappings")

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true })

-- Toggle nvim tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle Nvim Tree" })

-- Resize splits with arrow keys
map("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, desc = "Resize split: Shrink" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, desc = "Resize split: Expand" })

-- Scroll down/up and center the screen
map("n", "<C-d>", "<C-d>zz", { noremap = true, desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { noremap = true, desc = "Scroll up and center" })

-- map("i", "<M-l>", "<Plug>(copilot-accept)", { desc = "Copilot: Accept suggestion" })
-- map("i", "<M-]>", "<Plug>(copilot-next)", { desc = "Copilot: Next suggestion" })
-- map("i", "<M-[>", "<Plug>(copilot-previous)", { desc = "Copilot: Previous suggestion" })
-- map("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Copilot: Dismiss suggestion" })

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

-- Copilot mappings
-- Copilot inline suggestions
map("i", "<M-l>", function()
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

map("n", "<leader>cc", "<cmd>CopilotChatOpen<cr>", { desc = "Copilot Open Chat" })
map("n", "<leader>cx", "<cmd>CopilotChatClose<cr>", { desc = "Copilot Close Chat" })

map("n", "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", { desc = "Toggle Undo Tree" })

-- nvim blame
map("n", "<leader>gb", "<cmd>BlameToggle<cr>", { desc = "Toggle Git Blame" })

-- LspSaga keymaps
map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })
map("n", "gD", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition" })

map("n", "<leader>Z", function()
	require("zen-mode").open()
end, {desc = "Open Zen Mode"})
