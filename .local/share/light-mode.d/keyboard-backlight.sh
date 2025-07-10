#!/usr/bin/env bash

# Disable keyboard backlight. Should be vendor agnostic.
# reference https://wiki.archlinux.org/title/Keyboard_backlight#D-Bus

BRIGHTNESS=0
dbus-send --system --type=method_call  --dest="org.freedesktop.UPower" "/org/freedesktop/UPower/KbdBacklight" "org.freedesktop.UPower.KbdBacklight.SetBrightness" "int32:$BRIGHTNESS"