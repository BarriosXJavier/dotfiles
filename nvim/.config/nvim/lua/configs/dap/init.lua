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

-- Load language-specific DAP configurations
-- You can uncomment and customize these as needed.
-- For example, to load the C/C++ configuration:
-- require("configs.dap.c")
-- require("configs.dap.go")
-- require("configs.dap.node")
-- require("configs.dap.python")
-- require("configs.dap.rust")
-- require("configs.dap.typescript")

-- Example: Automatically load all files in this directory as DAP configurations
local dap_configs_path = vim.fn.stdpath("config") .. "/lua/configs/dap"
local dap_config_files = vim.fn.readdir(dap_configs_path)

for _, file_name in ipairs(dap_config_files) do
  if file_name:match("%.lua$") and file_name ~= "init.lua" then
    local module_name = "configs.dap." .. file_name:gsub("%.lua$", "")
    local ok, err = pcall(require, module_name)
    if not ok then
      vim.notify("Error loading DAP config " .. module_name .. ": " .. err, vim.log.levels.ERROR)
    end
  end
end
