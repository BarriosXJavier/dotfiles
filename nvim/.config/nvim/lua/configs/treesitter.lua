local M = {}

local parsers = {
  "vim",
  "lua",
  "vimdoc",
  "html",
  "css",
  "scss",
  "javascript",
  "jsdoc",
  "typescript",
  "tsx",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "python",
  "rust",
  "c",
  "cpp",
  "sql",
  "json",
  "jsonc",
  "yaml",
  "toml",
  "bash",
  "zsh",
  "dockerfile",
  "markdown",
  "markdown_inline",
  "svelte",
  "vue",
  "query",
  "regex",
  "git_config",
  "gitcommit",
  "gitignore",
  "diff",
}

local function create_install_command()
  if vim.fn.exists(":TSInstallRecommended") == 2 then
    return
  end

  vim.api.nvim_create_user_command("TSInstallRecommended", function()
    require("nvim-treesitter").install(parsers, { summary = true })
  end, {
    desc = "Install the recommended Treesitter parsers for this config",
  })
end

local function start_highlighting(args)
  local bufnr = args.buf
  local filetype = vim.bo[bufnr].filetype
  if filetype == "" then
    return
  end

  local lang = vim.treesitter.language.get_lang(filetype) or filetype
  local ok = pcall(vim.treesitter.language.add, lang)
  if not ok then
    return
  end

  pcall(vim.treesitter.start, bufnr, lang)
end

function M.setup()
  require("nvim-treesitter").setup()
  create_install_command()

  local group = vim.api.nvim_create_augroup("UserTreesitterHighlight", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = start_highlighting,
  })

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      start_highlighting({ buf = bufnr })
    end
  end
end

return M
