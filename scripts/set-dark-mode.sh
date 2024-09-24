#!/bin/sh
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

kitty +kitten themes --reload-in=all "Gruvbox Material Dark Hard"

current_gtk3_theme=$(gsettings get org.gnome.desktop.interface gtk-theme)

dark_theme="Gruvbox-Dark-BL-LB"
path_to_dark_theme="$HOME/.themes/$dark_theme"

if [ "$current_gtk3_theme" != "'$dark_theme'" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme "$dark_theme"
fi

# if light_theme is set to 'Adwaita-dark', then backup the current gtk-4.0 theme, and remove gtk-4.0 directory contents
if [ "$light_theme" = "Adwaita-dark" ]; then
    mv ~/.config/gtk-4.0 ~/.config/gtk-4.0.bak
    mkdir ~/.config/gtk-4.0
else
    # if light_theme is not "Adwaita-dark", then copy light theme gtk-4.0 contents to ~/.config/gtk-4.0, and replace
    # the current gtk-4.0 theme
    cp -r $path_to_dark_theme/gtk-4.0 ~/.config
fi

echo "export GTK_THEME=$dark_theme" > $HOME/.gtk-theme-env

echo "set color-scheme to '$dark_theme'"
