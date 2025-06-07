require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>sp", function()
require("telescope.builtin").find_files { hidden = false, no_ignore = true }
end, { desc = "Telescope: find_files" })

map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neotree" })
