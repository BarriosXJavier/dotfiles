local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- =========================
-- Fonts
-- =========================
config.font = wezterm.font_with_fallback({
	"Iosevka Nerd Font",
	"Fira Code Nerd Font",
})
config.font_size = 13

local fonts = {
	"Iosevka Nerd Font",
	"Fira Code Nerd Font",
}

local current_font = 1

local function set_font(window, step)
	current_font = ((current_font - 1 + step) % #fonts) + 1
	window:set_config_overrides({
		font = wezterm.font_with_fallback({ fonts[current_font] }),
	})
	wezterm.log_info("Switched to font: " .. fonts[current_font])
end

wezterm.on("switch-font-forward", function(window, _)
	set_font(window, 1)
end)
wezterm.on("switch-font-backward", function(window, _)
	set_font(window, -1)
end)

-- =========================
-- Wallpapers
-- =========================
local wallpaper_dir = wezterm.home_dir .. "/Pictures/wallpapers/terminal"
local cache_file = "/tmp/wezterm_wallpapers.cache"

math.randomseed(os.time() * 1000 + os.clock() * 1000000)

local function get_wallpapers(dir, cache_file)
	local wallpapers = {}
	local cache = io.open(cache_file, "r")
	if cache then
		for line in cache:lines() do
			if line ~= "" then
				table.insert(wallpapers, line)
			end
		end
		cache:close()
	end
	if #wallpapers == 0 then
		for _, ext in ipairs({ "jpg", "jpeg", "webp", "png", "JPG", "JPEG", "PNG", "WEBP" }) do
			for _, path in ipairs(wezterm.glob(dir .. "/*." .. ext)) do
				table.insert(wallpapers, path)
			end
		end
		if #wallpapers > 0 then
			local cache_write = io.open(cache_file, "w")
			if cache_write then
				for _, path in ipairs(wallpapers) do
					cache_write:write(path, "\n")
				end
				cache_write:close()
			end
		end
	end
	return wallpapers
end

local wallpapers = get_wallpapers(wallpaper_dir, cache_file)
local current_index = 1

local function file_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

local function next_index(idx, step)
	if #wallpapers <= 1 then
		return idx
	end
	return ((idx - 1 + step) % #wallpapers) + 1
end

local function change_wallpaper(window, index, step)
	local tries = 0
	while tries < #wallpapers do
		if wallpapers[index] and file_exists(wallpapers[index]) then
			current_index = index
			window:set_config_overrides({
				window_background_image = wallpapers[index],
				window_background_image_hsb = { brightness = 0.03, hue = 1, saturation = 1 },
			})
			return
		else
			index = next_index(index, step or 1)
		end
		tries = tries + 1
	end
end

-- =========================
-- Keybindings
-- =========================
config.keys = {
	{ key = "PageUp", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("next-wallpaper") },
	{ key = "PageDown", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("prev-wallpaper") },
	{ key = "F", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("switch-font-forward") },
	{ key = "B", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("switch-font-backward") },
	{ key = "r", mods = "CMD|SHIFT", action = wezterm.action.ReloadConfiguration },
}

wezterm.on("next-wallpaper", function(window, _)
	if #wallpapers > 0 then
		change_wallpaper(window, next_index(current_index, 1), 1)
	end
end)

wezterm.on("prev-wallpaper", function(window, _)
	if #wallpapers > 0 then
		change_wallpaper(window, next_index(current_index, -1), -1)
	end
end)

local function start_auto_cycle(window)
	wezterm.time.call_after(1800, function()
		if window:gui_window() then
			change_wallpaper(window, next_index(current_index, 1), 1)
			start_auto_cycle(window)
		end
	end)
end

wezterm.on("window-created", function(window, _)
	if #wallpapers > 0 then
		current_index = math.random(#wallpapers)
		change_wallpaper(window, current_index, 1)
		start_auto_cycle(window)
	end
end)

-- =========================
-- Appearance
-- =========================
config.color_scheme = "tokyonight"

config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.hide_mouse_cursor_when_typing = true
config.default_cursor_style = "BlinkingBar"
config.cursor_thickness = 0.4

return config
