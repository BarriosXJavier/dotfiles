local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Load terminal wallpapers
local wallpaper_dir = "/home/maksim/Pictures/wallpapers/terminal"
local wallpapers = {}

for _, ext in ipairs({ "jpg", "png", "jpeg" }) do
  local globbed = wezterm.glob(wallpaper_dir .. "/*." .. ext)
  for _, path in ipairs(globbed) do
    table.insert(wallpapers, path)
  end
end

-- Guard against empty wallpaper folder
if #wallpapers == 0 then
  wezterm.log_error("No wallpapers found in " .. wallpaper_dir)
else
  -- Seed RNG once per run
  math.randomseed(os.time())

  -- Random wallpaper selection
  local selected_wallpaper = wallpapers[math.random(#wallpapers)]

  -- Set wallpaper
  config.window_background_image = selected_wallpaper

  -- Schedule random wallpaper pick every 1hr
  wezterm.on("window-config-reloaded", function()
    wezterm.time.call_after(3600, function()
      wezterm.reload_configuration()
    end)
  end)
end

-- Font settings
config.font_size = 14
config.font = wezterm.font_with_fallback({
  { family = "Iosevka Nerd Font" },
  { family = "JetBrainsMono Nerd Font" },
})

config.colors = {
  cursor_bg = "white",
  cursor_border = "white",
  background = "#1a1b26",
}

config.color_scheme = "Tokyo Night"
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.hide_mouse_cursor_when_typing = true
config.default_cursor_style = "BlinkingBar"
config.cursor_thickness = 0.50
config.window_background_opacity = 0.90
config.window_background_image_hsb = {
  brightness = 0.050,
  hue = 1,
  saturation = 1,
}

return config


