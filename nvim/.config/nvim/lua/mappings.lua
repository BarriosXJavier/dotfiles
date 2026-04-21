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

-- LspSaga keymaps
map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })
map("n", "gD", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition" })

-- close buffer (safe, keeps layout)
map("n", "<leader>x", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "Close buffer" })

-- cycle buffers
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })

-- move buffers
map("n", "<leader>bh", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
map("n", "<leader>bl", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })

-- jump to buffer index
for i = 1, 9 do
  map("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<CR>", {
    desc = "Go to buffer " .. i,
  })
end

-- pick buffer visually
map("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })

-- close others
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
