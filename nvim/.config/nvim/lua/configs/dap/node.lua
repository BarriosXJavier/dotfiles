-- lua/configs/dap/node.lua
local dap = require("dap")

dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = {
    os.getenv("HOME") .. "/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js",
  },
}

dap.configurations.javascript = {
  {
    name = "Launch file",
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
}
