#!/usr/bin/env bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For Dark and Light switching
# Note: Scripts are looking for keywords Light or Dark except for wallpapers as the are in a separate directories

# Paths
PICTURES_DIR="$(xdg-user-dir PICTURES 2>/dev/null || echo "$HOME/Pictures")"
wallpaper_base_path="$PICTURES_DIR/wallpapers/Dynamic-Wallpapers"
dark_wallpapers="$wallpaper_base_path/Dark"
light_wallpapers="$wallpaper_base_path/Light"
hypr_config_path="$HOME/.config/hypr"
swaync_style="$HOME/.config/swaync/style.css"
ags_style="$HOME/.config/ags/user/style.css"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
notif="$HOME/.config/swaync/images/bell.png"
wallust_rofi="$HOME/.config/wallust/templates/colors-rofi.rasi"

kitty_conf="$HOME/.config/kitty/kitty.conf"

wallust_config="$HOME/.config/wallust/wallust.toml"
pallete_dark="dark16"
pallete_light="light16"
qt5ct_dark="$HOME/.config/qt5ct/colors/Catppuccin-Mocha.conf"
qt5ct_light="$HOME/.config/qt5ct/colors/Catppuccin-Latte.conf"
qt6ct_dark="$HOME/.config/qt6ct/colors/Catppuccin-Mocha.conf"
qt6ct_light="$HOME/.config/qt6ct/colors/Catppuccin-Latte.conf"

# intial kill process
for pid in waybar rofi swaync ags swaybg; do
    killall -SIGUSR1 "$pid"
done


# Initialize swww if needed
swww query || swww-daemon --format xrgb

# Set swww options
swww="swww img"
effect="--transition-bezier .43,1.19,1,.4 --transition-fps 60 --transition-type grow --transition-pos 0.925,0.977 --transition-duration 2"

# Determine current theme mode
if [ "$(cat $HOME/.cache/.theme_mode)" = "Light" ]; then
    next_mode="Dark"
    # Logic for Dark mode
    wallpaper_path="$dark_wallpapers"
else
    next_mode="Light"
    # Logic for Light mode
    wallpaper_path="$light_wallpapers"
fi
# Select Qt color scheme templates for the upcoming mode
if [ "$next_mode" = "Dark" ]; then
    qt5ct_color_scheme="$qt5ct_dark"
    qt6ct_color_scheme="$qt6ct_dark"
else
    qt5ct_color_scheme="$qt5ct_light"
    qt6ct_color_scheme="$qt6ct_light"
fi

# Function to update theme mode for the next cycle
update_theme_mode() {
    echo "$next_mode" > "$HOME/.cache/.theme_mode"
}

# Function to notify user
notify_user() {
    notify-send -u low -i "$notif" " Switching to" " $1 mode"
}

# Use sed to replace the palette setting in the wallust config file
if [ "$next_mode" = "Dark" ]; then
    sed -i 's/^palette = .*/palette = "'"$pallete_dark"'"/' "$wallust_config" 
else
    sed -i 's/^palette = .*/palette = "'"$pallete_light"'"/' "$wallust_config" 
fi

notify_user "$next_mode"


set_surface_overlays() {
    mode="$1"

    if [ "$mode" = "Dark" ]; then
        swaync_bg='rgba(0, 0, 0, 0.8);'
        ags_bg='rgba(0, 0, 0, 0.4);'
        ags_text='rgba(255, 255, 255, 0.7);'
        neutral_bg='#111111;'
        rofi_bg='rgba(0,0,0,0.7);'
    else
        swaync_bg='rgba(255, 255, 255, 0.9);'
        ags_bg='rgba(255, 255, 255, 0.4);'
        ags_text='rgba(0, 0, 0, 0.7);'
        neutral_bg='#F0F0F0;'
        rofi_bg='rgba(255,255,255,0.9);'
    fi

    if [ -f "$swaync_style" ]; then
        sed -i "/@define-color noti-bg/s/rgba([0-9]*,\s*[0-9]*,\s*[0-9]*,\s*[0-9.]*);/$swaync_bg/" "${swaync_style}"
    fi

    if command -v ags >/dev/null 2>&1 && [ -f "$ags_style" ]; then
        sed -i "/@define-color noti-bg/s/rgba([0-9]*,\s*[0-9]*,\s*[0-9]*,\s*[0-9.]*);/$ags_bg/" "${ags_style}"
        sed -i "/@define-color text-color/s/rgba([0-9]*,\s*[0-9]*,\s*[0-9]*,\s*[0-9.]*);/$ags_text/" "${ags_style}"
        sed -i "/@define-color noti-bg-alt/s/#.*;/$neutral_bg/" "${ags_style}"
    fi

    if [ -f "$wallust_rofi" ]; then
        sed -i "/^background:/s/.*/background: $rofi_bg/" "$wallust_rofi"
    fi
}

set_kitty_theme_source() {
    [ -f "$kitty_conf" ] || return 0

    if grep -q -E '^[#[:space:]]*include\s+\./kitty-themes/.*\.conf' "$kitty_conf"; then
        sed -i -E 's|^[#[:space:]]*include\s+\./kitty-themes/.*\.conf|include ./kitty-themes/01-Wallust.conf|' "$kitty_conf"
    else
        printf '\ninclude ./kitty-themes/01-Wallust.conf\n' >> "$kitty_conf"
    fi
}

set_surface_overlays "$next_mode"
set_kitty_theme_source

for pid_kitty in $(pidof kitty); do
    kill -SIGUSR1 "$pid_kitty"
done

# Set Dynamic Wallpaper for Dark or Light Mode
if [ "$next_mode" = "Dark" ]; then
    next_wallpaper="$(find -L "${dark_wallpapers}" -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | shuf -n1 -z | xargs -0)"
else
    next_wallpaper="$(find -L "${light_wallpapers}" -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | shuf -n1 -z | xargs -0)"
fi

# Update wallpaper using swww command
$swww "${next_wallpaper}" $effect


# Set Kvantum Manager theme & QT5/QT6 settings
if [ "$next_mode" = "Dark" ]; then
    kvantum_theme="catppuccin-mocha-blue"
    #qt5ct_color_scheme="$HOME/.config/qt5ct/colors/Catppuccin-Mocha.conf"
    #qt6ct_color_scheme="$HOME/.config/qt6ct/colors/Catppuccin-Mocha.conf"
else
    kvantum_theme="catppuccin-latte-blue"
    #qt5ct_color_scheme="$HOME/.config/qt5ct/colors/Catppuccin-Latte.conf"
    #qt6ct_color_scheme="$HOME/.config/qt6ct/colors/Catppuccin-Latte.conf"
fi

sed -i "s|^color_scheme_path=.*$|color_scheme_path=$qt5ct_color_scheme|" "$HOME/.config/qt5ct/qt5ct.conf"
sed -i "s|^color_scheme_path=.*$|color_scheme_path=$qt6ct_color_scheme|" "$HOME/.config/qt6ct/qt6ct.conf"
kvantummanager --set "$kvantum_theme"


# GTK themes and icons switching
swap_mode_variant() {
    current_value="$1"
    mode="$2"

    if [ -z "$current_value" ]; then
        return 1
    fi

    candidate="$current_value"
    if [ "$mode" = "Light" ]; then
        candidate=$(printf '%s' "$candidate" | sed \
            -e 's/Dark/Light/g' \
            -e 's/dark/light/g' \
            -e 's/Mocha/Latte/g' \
            -e 's/mocha/latte/g')
    else
        candidate=$(printf '%s' "$candidate" | sed \
            -e 's/Light/Dark/g' \
            -e 's/light/dark/g' \
            -e 's/Latte/Mocha/g' \
            -e 's/latte/mocha/g')
    fi

    if [ "$candidate" = "$current_value" ]; then
        return 1
    fi

    printf '%s\n' "$candidate"
}

apply_paired_variant() {
    mode="$1"
    current_value="$2"
    search_dir="$3"
    gsettings_key="$4"
    flatpak_env="$5"
    qt_conf_key="$6"

    [ -n "$current_value" ] || return 0

    candidate="$(swap_mode_variant "$current_value" "$mode")" || return 0
    if [ -n "$search_dir" ] && [ -d "$search_dir" ] && [ ! -d "$search_dir/$candidate" ]; then
        echo "Paired variant not found for $current_value"
        return 0
    fi

    echo "Switching $gsettings_key: $current_value -> $candidate"
    gsettings set org.gnome.desktop.interface "$gsettings_key" "$candidate"

    if [ -n "$qt_conf_key" ]; then
        sed -i "s|^$qt_conf_key=.*$|$qt_conf_key=$candidate|" "$HOME/.config/qt5ct/qt5ct.conf"
        sed -i "s|^$qt_conf_key=.*$|$qt_conf_key=$candidate|" "$HOME/.config/qt6ct/qt6ct.conf"
    fi

    if command -v flatpak >/dev/null 2>&1; then
        if [ -n "$search_dir" ]; then
            flatpak --user override --filesystem="$search_dir"
            sleep 0.5
        fi
        if [ -n "$flatpak_env" ]; then
            flatpak --user override --env="$flatpak_env=$candidate"
        fi
    fi
}

set_custom_gtk_theme() {
    mode=$1
    gtk_themes_directory="$HOME/.themes"
    icon_directory="$HOME/.icons"

    case "$mode" in
        Light)
            gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
            ;;
        Dark)
            gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
            ;;
        *)
            echo "Invalid mode provided."
            return 1
            ;;
    esac

    current_theme="$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'")"
    current_icon="$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | tr -d "'")"

    apply_paired_variant "$mode" "$current_theme" "$gtk_themes_directory" "gtk-theme" "GTK_THEME" ""
    apply_paired_variant "$mode" "$current_icon" "$icon_directory" "icon-theme" "ICON_THEME" "icon_theme"
}

# Call the function to set GTK theme and icon theme based on mode
set_custom_gtk_theme "$next_mode"

# Update theme mode for the next cycle
update_theme_mode


${SCRIPTSDIR}/WallustSwww.sh &&

sleep 2
# kill process
for pid1 in waybar rofi swaync ags swaybg; do
    killall "$pid1"
done

sleep 1
${SCRIPTSDIR}/Refresh.sh 

sleep 0.5
# Display notifications for theme and icon changes 
notify-send -u low -i "$notif" " Themes switched to:" " $next_mode Mode"

exit 0
