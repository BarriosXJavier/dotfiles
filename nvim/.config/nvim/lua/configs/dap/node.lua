-- lua/configs/dap/node.lua
local dap = require("dap")

-- Use js-debug-adapter (modern replacement for node-debug2)
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = {
      vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
      "${port}",
    },
  },
}

dap.configurations.javascript = {
  {
    name = "Launch file",
    type = "pwa-node",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
  },
  {
    name = "Attach",
    type = "pwa-node",
    request = "attach",
    processId = require("dap.utils").pick_process,
    cwd = vim.fn.getcwd(),
  },
}
