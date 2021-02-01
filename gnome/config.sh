#!/bin/bash

# swap escape and capslock
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"

# numix icons
gsettings set org.gnome.desktop.interface icon-theme "Numix-Circle"

# enable fractional scaling in settings
#gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
