local dap = require("dap")
local mason_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"

dap.adapters.python = {
  type = "executable",
  command = vim.fn.executable(mason_python) == 1 and mason_python or "python3",
  args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}", -- current buffer
    pythonPath = function()
      return "/usr/bin/python3"
    end,
  },
}
