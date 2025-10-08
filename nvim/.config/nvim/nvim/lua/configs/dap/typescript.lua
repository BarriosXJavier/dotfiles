local dap = require("dap")

dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = {
    os.getenv("HOME") .. "/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js",
  },
}

dap.configurations.typescript = {
  {
    name = "Launch ts-node",
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    runtimeExecutable = "ts-node",
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
    internalConsoleOptions = "neverOpen",
    outFiles = { "${workspaceFolder}/**/*.ts" },
    skipFiles = { "<node_internals>/**", "node_modules/**" },
  },
}
