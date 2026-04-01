-- This file is loaded by `require "configs.dap"`
-- It should contain the setup for nvim-dap and load your language-specific configurations.

local dap = require("dap")
local dapui = require("dapui")

dapui.setup({
  -- your dapui configuration
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

for _, module_name in ipairs({
  "configs.dap.c",
  "configs.dap.go",
  "configs.dap.node",
  "configs.dap.python",
  "configs.dap.rust",
  "configs.dap.typescript",
}) do
  local ok, err = pcall(require, module_name)
  if not ok then
    vim.notify("Error loading DAP config " .. module_name .. ": " .. err, vim.log.levels.ERROR)
  end
end
