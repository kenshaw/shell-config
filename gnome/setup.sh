#!/bin/bash

# colors taken from: https://raw.githubusercontent.com/denysdovhan/one-gnome-terminal/master/one-dark.sh
#
DKEY="org.gnome.desktop"
TKEY="org.gnome.Terminal.Legacy.Profile:/:0/"

gset() {
  (set -x;
    gsettings set "$1" "$2" "$3"
  )
}

dset() {
  gset "${DKEY}.$1" "$2" "$3"
}

tset() {
  gset "${TKEY}" "$1" "$2"
}

dset wm.keybindings switch-windows "['<Alt>Tab']"
dset wm.keybindings switch-windows-backward "['<Shift><Alt>Tab', '<Alt>Above_Tab']"
dset wm.keybindings switch-applications "[]"
dset wm.keybindings switch-applications-backward "[]"
dset interface cursor-size 48


tset palette "['#000000', '#e06c75', '#87d787', '#d19a66', '#00aeff', '#c678dd', '#56b6c2', '#abb2bf', '#5c6370', '#e06c75', '#87d787', '#d19a66', '#00aeff', '#c678dd', '#56b6c2', '#ffffff']"

#dset background-color "'#282c34'"
tset visible-name 'Test'
tset background-color "'#000000'"
tset foreground-color "'#abb2bf'"
tset bold-color "'#abb2bf'"
tset bold-color-same-as-fg "true"
tset use-theme-colors "false"
tset use-theme-background "false"
tset enable-sixel "true"
