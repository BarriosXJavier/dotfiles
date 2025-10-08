local dap = require("dap")

dap.adapters.python = {
  type = "executable",
  command = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
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
