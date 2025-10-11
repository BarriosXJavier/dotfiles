-- Load NvChad defaults first
require "nvchad.autocmds"

-- 🔹 ibl safe setup
local ok, ibl = pcall(require, "ibl")
if ok then
  ibl.setup {
    indent = { char = "│" },
  }
end

-- 🔹 universal refresh chain (fires on ANY :colorscheme)
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local ok_ibl, ibl = pcall(require, "ibl")
    if ok_ibl then
      pcall(ibl.refresh)
    end

    local ok_ll, lualine = pcall(require, "lualine")
    if ok_ll then
      pcall(lualine.setup, { options = { theme = vim.g.colors_name } })
    end

    local ok_nt, nt = pcall(require, "nvim-tree")
    if ok_nt then
      vim.schedule(function()
        pcall(nt.refresh)
      end)
    end

    local ok_wk, wk = pcall(require, "which-key")
    if ok_wk then
      vim.schedule(function()
        pcall(wk.setup, {})
      end)
    end

    local ok_ts, _ = pcall(require, "telescope")
    if ok_ts then
      vim.schedule(function()
        vim.cmd "hi! link TelescopeBorder FloatBorder"
        vim.cmd "hi! link TelescopePromptBorder TelescopeBorder"
      end)
    end

    local ok_tr, transparent = pcall(require, "transparent")
    if ok_tr then
      pcall(transparent.enable)
    end

    vim.notify("Colorscheme applied: " .. vim.g.colors_name, vim.log.levels.INFO, { title = "Theme" })
  end,
})

vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    -- wait for base46 async theme to finish drawing
    vim.defer_fn(function()
      vim.cmd.colorscheme("tokyonight-moon")
      vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "*" })
      vim.notify("Forced tokyonight-moon applied", vim.log.levels.INFO, { title = "Theme" })
    end, 300)
  end,
})

vim.schedule(function()
  vim.cmd.colorscheme("tokyonight-moon")
  vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "*" })
end)

