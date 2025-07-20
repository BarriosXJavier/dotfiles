# NvChad Config (with Debugging)

This repo is my config for [NvChad](https://github.com/NvChad/NvChad).

## The only tricky part is getting DAPs set up and working and below is how I did it

---

##  DAP (Debug Adapter Protocol) Overview

This config adds full debugging support using:

- `nvim-dap`: core DAP client  
- `nvim-dap-ui`: floating panels and layout  
- `mason-nvim-dap`: automatic adapter install  
- `nvim-dap-virtual-text`: inline variable values  

DAPs are lazily loaded and language-agnostic. You wire in language-specific adapters via config files.

---

##  Plugin Install

Add this to `lua/plugins/init.lua`:

```lua
{
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "jay-babu/mason-nvim-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    require("configs.dap")
  end,
}
```

This loads the core DAP and calls your main config in `lua/configs/dap.lua`.

---

##  How DAP Installation Works

1. Run:

   ```vim
   :MasonInstall <adapter-name>
   ```

2. Adapter is installed to:

   ```
   ~/.local/share/nvim/mason/packages/<adapter>/
   ```

3. You define the DAP adapter and configuration manually in Lua:

   ```lua
   dap.adapters.node2 = { ... }
   dap.configurations.javascript = { ... }
   ```

---

##  My Recommended Config Structure

```text
lua/
├── configs/
│   ├── dap.lua           ← Main setup, UI, mappings
│   └── dap/
│       ├── node.lua      ← JS/TS (Node.js)
│       ├── python.lua    ← Python
│       ├── rust.lua      ← Rust
│       └── ...
├── plugins/
│   └── init.lua          ← Plugin list (including DAP)
```

In `dap.lua`, load your adapters:

```lua
pcall(require, "configs.dap.node")
pcall(require, "configs.dap.python")
```

Each submodule defines:

- `dap.adapters.<name>`
- `dap.configurations.<lang>`

---

##  Keybindings (defaults)

```text
<F5>        – Continue
<F10>       – Step Over
<F11>       – Step Into
<F12>       – Step Out
<Leader>b   – Toggle Breakpoint
<Leader>B   – Conditional Breakpoint
<Leader>du  – Toggle DAP UI
```

You can move these to `mappings.lua` or define inline.

---

## Credits

Based on [NvChad](https://github.com/NvChad/NvChad) — a Neovim distro.

