local dap = require("dap")
local dapui = require("dapui")

require("nvim-dap-virtual-text").setup()
dapui.setup()

-- UI auto open/close
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step Out" })

vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
vim.keymap.set("n", "<Leader>B", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP: Conditional Breakpoint" })

vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "DAP: Toggle UI" })

vim.keymap.set("n", "<Leader>de", function()
  dap.terminate()
  dap.disconnect({ terminateDebuggee = true })
  dapui.close()
  dap.clear_breakpoints()
  vim.cmd("DapVirtualTextDisable")
end, { desc = "DAP: Fully exit session" })

require("mason-nvim-dap").setup({
  automatic_installation = true,
  handlers = {}, -- or provide custom handlers
})

-- Optional: load per-language config
pcall(require, "configs.dap.node")
pcall(require, "configs.dap.rust")
pcall(require, "configs.dap.python")
pcall(require, "configs.dap.go")
pcall(require, "configs.dap.typescript")
pcall(require, "configs.dap.c")
