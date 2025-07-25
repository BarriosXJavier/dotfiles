local wezterm = require "wezterm"
local config = wezterm.config_builder()

-- Font settings
config.font_size = 14
-- config.line_height = 1.2
-- config.font = wezterm.font("Iosevka Nerd Font Propo")

config.font = wezterm.font("Iosevka Nerd Font")
-- colors
config.colors = {
  cursor_bg = "white",
  cursor_border = "white",
  background = "#1a1b26",
}

-- Appearance
config.color_scheme = "Tokyo Night"
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0
}

config.hide_mouse_cursor_when_typing = true
config.default_cursor_style = "BlinkingBar"
config.window_background_opacity = 0.85


return config
