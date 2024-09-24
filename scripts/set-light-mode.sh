#!/bin/sh
gsettings set org.gnome.desktop.interface color-scheme prefer-light
# gsettings set org.gnome.desktop.interface color-scheme prefer-light
kitty +kitten themes --reload-in=all "One Half Light"

current_gtk3_theme=$(gsettings get org.gnome.desktop.interface gtk-theme)

light_theme="Adwaita"
path_to_light_theme="$HOME/.themes/$light_theme"

if [ "$current_gtk3_theme" != "'$light_theme'" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme "$light_theme"
fi

# if light_theme is set to 'Adwaita', then backup the current gtk-4.0 theme, and remove gtk-4.0 directory contents
if [ "$light_theme" = "Adwaita" ]; then
    mv ~/.config/gtk-4.0 ~/.config/gtk-4.0.bak
    mkdir ~/.config/gtk-4.0
else
    # if light_theme is not 'Adwaita', then copy light theme gtk-4.0 contents to ~/.config/gtk-4.0, and replace
    # the current gtk-4.0 theme
    cp -r $path_to_light_theme/gtk-4.0 ~/.config
fi

# change contents of ~/.gtk-theme-env to light theme name
echo "export GTK_THEME=$light_theme" > $HOME/.gtk-theme-env

echo "set color-scheme to 'prefer-light'"
