local dap = require("dap")

if not dap.adapters["pwa-node"] then
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
end

dap.configurations.typescript = {
  {
    name = "Launch ts-node",
    type = "pwa-node",
    request = "launch",
    program = "${file}",
    cwd = "${workspaceFolder}",
    runtimeExecutable = "ts-node",
    runtimeArgs = { "--transpile-only" },
    sourceMaps = true,
    outFiles = { "${workspaceFolder}/**/*.js" },
    skipFiles = { "<node_internals>/**", "node_modules/**" },
  },
  {
    name = "Attach",
    type = "pwa-node",
    request = "attach",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}
