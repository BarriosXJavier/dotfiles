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
      theme = "tokyonight",
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
