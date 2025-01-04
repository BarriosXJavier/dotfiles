-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
local options = {

  base46 = {

    theme = "catppuccin", -- default theme

    hl_add = {
      LineNr = { fg = "#d0be98" },
      CursorLineNr = { fg = "#87d9e8" },
    },
    hl_override = {
      Comment = { fg = "#c0c0c0", italic = true },
    },
    integrations = {},
    changed_themes = {},
    transparency = true,
    theme_toggle = { "catppuccin", "tokyonight" },
  },

  ui = {
    cmp = {
      icons_left = true, -- only for non-atom styles!
      lspkind_text = true,
      style = "default", -- default/flat_light/flat_dark/atom/atom_colored
      format_colors = {
        tailwind = true, -- will work for css lsp too
        icon = "󱓻",
      },
    },

    telescope = { style = "borderless" }, -- borderless / bordered

    statusline = {
      enabled = true,
      theme = "default",
      separator_style = "arrow",
      order = nil,
      modules = nil,
    },

    -- lazyload it when there are 1+ buffers
    tabufline = {
      enabled = true,
      lazyload = true,
      order = { "treeOffset", "buffers", "tabs", "btns" },
      modules = nil,
    },
  },

  nvdash = {
    load_on_startup = true,
    header = {
      " ,,                                     ,,                               ",
      "*MM                                     db                               ",
      " MM                                                                     ",
      ' MM,dMMb.   ,6"Yb.  `7Mb,od8 `7Mb,od8 `7MM  ,pW"Wq.  ,pP"Ybd  `7M\'   `MF\' ',
      " MM    `Mb 8)   MM    MM' \"'   MM' \"'   MM 6W'   `Wb 8I   `\"    `VA ,V'  ",
      " MM     M8  ,pm9MM    MM       MM       MM 8M     M8 `YMMMa.      XMX     ",
      " MM.   ,M9 8M   MM    MM       MM       MM YA.   ,A9 L.   I8    ,V' VA.   ",
      " P^YbmdP'  `Moo9^Yo..JMML.   .JMML.   .JMML.`Ybmd9'  M9mmmP'  .AM.   .MA. ",
      "                                                                      ",
      "     Powered By eovim    ",
    },

    buttons = {
      { txt = "  Find File", keys = "Spc f f", cmd = "Telescope find_files" },
      { txt = "  Recent Files", keys = "Spc f o", cmd = "Telescope oldfiles" },
      { txt = "󰈭  Find Word", keys = "Spc f w", cmd = "Telescope live_grep" },
      { txt = "󱥚  Themes", keys = "Spc t h", cmd = ":lua require('nvchad.themes').open()" },
      { txt = "  Mappings", keys = "Spc c h", cmd = "NvCheatsheet" },

      { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },

      {
        txt = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime) .. " ms"
          return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
        end,
        hl = "NvDashLazy",
        no_gap = true,
      },

      { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },
    },
  },

  term = {
    winopts = { number = false, relativenumber = false },
    sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },

  lsp = { signature = true },

  cheatsheet = {
    theme = "grid",                                                     -- simple/grid
    excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
  },

  mason = { pkgs = {} },

  colorify = {
    enabled = true,
    mode = "virtual", -- fg, bg, virtual
    virt_text = "󱓻 ",
    highlight = { hex = true, lspvars = true },
  },
}

local status, chadrc = pcall(require, "chadrc")
return vim.tbl_deep_extend("force", options, status and chadrc or {})
