local dap = require("dap")

-- Try to use go-debug-adapter from Mason, fallback to dlv
local go_adapter_path = vim.fn.stdpath("data") .. "/mason/packages/go-debug-adapter/go-debug-adapter"

dap.adapters.go = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.filereadable(go_adapter_path) == 1 and go_adapter_path or "dlv",
    args = vim.fn.filereadable(go_adapter_path) == 1 
      and { "dap", "-l", "127.0.0.1:${port}" }
      or { "dap", "-l", "127.0.0.1:${port}" },
  },
}

dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
}
