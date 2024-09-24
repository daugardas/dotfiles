#!/bin/bash

# echo $(/usr/bin/curl -s https://api.ipify.org) > $HOME/.config/waybar/custom/external-ip/currentip

echo '{"text": "'$(/usr/bin/curl -s https://api.ipify.org)'", "class":"clicked"}' > $HOME/.config/waybar/custom/external-ip/currentip