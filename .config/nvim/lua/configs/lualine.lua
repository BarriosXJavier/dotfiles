local M = {}

function M.setup()
  local function get_lsp_status()
    local bufnr = vim.api.nvim_get_current_buf()
    local buf_ft = vim.bo[bufnr].filetype
    local lsp_clients, formatters = {}, {}

    for _, client in pairs(vim.lsp.get_clients()) do
      if client.attached_buffers[bufnr] and client.name ~= "copilot" and client.name ~= "null-ls" then
        table.insert(lsp_clients, client.name)
      end
    end

    local null_ls_ok, null_ls = pcall(require, "null-ls")
    if null_ls_ok then
      for _, source in ipairs(null_ls.get_sources()) do
        if source._validated and source.filetypes[buf_ft] then
          local method = source.method
          if method == null_ls.methods.FORMATTING or method == null_ls.methods.FORMATTING_SYNC then
            table.insert(formatters, source.name)
          end
        end
      end
    end

    local function dedupe(list)
      local seen, result = {}, {}
      for _, item in ipairs(list) do
        if not seen[item] then
          seen[item] = true
          table.insert(result, item)
        end
      end
      return result
    end

    lsp_clients = dedupe(lsp_clients)
    formatters = dedupe(formatters)

    local parts = {}
    if #lsp_clients > 0 then
      table.insert(parts, "LSP: " .. table.concat(lsp_clients, ", "))
    end
    if #formatters > 0 then
      table.insert(parts, "Fmt: " .. table.concat(formatters, ", "))
    end

    local status = #parts > 0 and table.concat(parts, " » ") or "LSP Inactive"
    local max_width = math.floor(vim.o.columns * 0.4)
    if #status > max_width then
      status = vim.fn.strcharpart(status, 0, max_width - 3) .. "…"
    end

    return status
  end

  require("lualine").setup {
    options = {
      theme = "dracula",
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_b = { "branch", "diff" },
      lualine_x = {
        "diagnostics",
        {
          function()
            local rec = vim.fn.reg_recording()
            return rec ~= "" and "Recording @" .. rec or ""
          end,
          color = { fg = "#f38ba8", gui = "bold" },
        },
        {
          function()
            local ok, s = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })
            if not ok or s.total == 0 then
              return "🔍"
            end
            return string.format("🔍 %d/%d", s.current, s.total)
          end,
          color = { fg = "#89b4fa" },
        },
        {
          function()
            return get_lsp_status()
          end,
          color = { gui = "bold" },
        },
        "filetype",
      },
    },
  }
end

return M
