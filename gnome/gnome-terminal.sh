#!/usr/bin/env bash

# taken from: https://raw.githubusercontent.com/denysdovhan/one-gnome-terminal/master/one-dark.sh

# ONE DARK
# --- ----
# Gnome Terminal color scheme install script
# Based on:
#   https://github.com/chriskempson/base16-gnome-terminal/

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="One Dark"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="one-dark"
[[ -z "$DCONF" ]] && DCONF=dconf
[[ -z "$UUIDGEN" ]] && UUIDGEN=uuidgen

dset() {
    local key="$1"; shift
    local val="$1"; shift

    if [[ "$type" == "string" ]]; then
        val="'$val'"
    fi

    "$DCONF" write "$PROFILE_KEY/$key" "$val"
}

# because dconf still doesn't have "append"
dlist_append() {
    local key="$1"; shift
    local val="$1"; shift

    local entries="$(
        {
            "$DCONF" read "$key" | tr -d '[]' | tr , "\n" | grep -F -v "$val"
            echo "'$val'"
        } | head -c-1 | tr "\n" ,
    )"

    "$DCONF" write "$key" "[$entries]"
}

# Newest versions of gnome-terminal use dconf
if which "$DCONF" > /dev/null 2>&1; then
    [[ -z "$BASE_KEY_NEW" ]] && BASE_KEY_NEW=/org/gnome/terminal/legacy/profiles:

    if [[ -n "`$DCONF list $BASE_KEY_NEW/`" ]]; then
        if which "$UUIDGEN" > /dev/null 2>&1; then
            PROFILE_SLUG=`uuidgen`
        fi

        if [[ -n "`$DCONF read $BASE_KEY_NEW/default`" ]]; then
            DEFAULT_SLUG=`$DCONF read $BASE_KEY_NEW/default | tr -d \'`
        else
            DEFAULT_SLUG=`$DCONF list $BASE_KEY_NEW/ | grep '^:' | head -n1 | tr -d :/`
        fi

        DEFAULT_KEY="$BASE_KEY_NEW/:$DEFAULT_SLUG"
        PROFILE_KEY="$BASE_KEY_NEW/:$PROFILE_SLUG"

        # copy existing settings from default profile
        $DCONF dump "$DEFAULT_KEY/" | $DCONF load "$PROFILE_KEY/"

        # add new copy to list of profiles
        dlist_append $BASE_KEY_NEW/list "$PROFILE_SLUG"

        # update profile values with theme options
        dset visible-name "'$PROFILE_NAME'"
        #dset palette "['#000000', '#e06c75', '#98c379', '#d19a66', '#61afef', '#c678dd', '#56b6c2', '#abb2bf', '#5c6370', '#e06c75', '#98c379', '#d19a66', '#61afef', '#c678dd', '#56b6c2', '#ffffff']"
        dset palette "['#000000', '#e06c75', '#87d787', '#d19a66', '#00aeff', '#c678dd', '#56b6c2', '#abb2bf', '#5c6370', '#e06c75', '#87d787', '#d19a66', '#00aeff', '#c678dd', '#56b6c2', '#ffffff']"
        #dset background-color "'#282c34'"
        dset background-color "'#000000'"
        dset foreground-color "'#abb2bf'"
        dset bold-color "'#abb2bf'"
        dset bold-color-same-as-fg "true"
        dset use-theme-colors "false"
        dset use-theme-background "false"

        unset PROFILE_NAME
        unset PROFILE_SLUG
        unset DCONF
        unset UUIDGEN
        exit 0
    fi
fi

# Fallback for Gnome 2 and early Gnome 3
[[ -z "$GCONFTOOL" ]] && GCONFTOOL=gconftool
[[ -z "$BASE_KEY" ]] && BASE_KEY=/apps/gnome-terminal/profiles

PROFILE_KEY="$BASE_KEY/$PROFILE_SLUG"

gset() {
    local type="$1"; shift
    local key="$1"; shift
    local val="$1"; shift

    "$GCONFTOOL" --set --type "$type" "$PROFILE_KEY/$key" -- "$val"
}

# Because gconftool doesn't have "append"
glist_append() {
    local type="$1"; shift
    local key="$1"; shift
    local val="$1"; shift

    local entries="$(
        {
            "$GCONFTOOL" --get "$key" | tr -d '[]' | tr , "\n" | grep -F -v "$val"
            echo "$val"
        } | head -c-1 | tr "\n" ,
    )"

    "$GCONFTOOL" --set --type list --list-type $type "$key" "[$entries]"
}

# Append profile to the profile list
glist_append string /apps/gnome-terminal/global/profile_list "$PROFILE_SLUG"

gset string visible_name "$PROFILE_NAME"
#gset string palette "#000000:#e06c75:#98c379:#d19a66:#61afef:#c678dd:#56b6c2:#abb2bf:#5c6370:#e06c75:#98c379:#d19a66:#61afef:#c678dd:#56b6c2:#ffffff"
gset string palette "#000000:#e06c75:#87d787:#d19a66:#00aeff:#c678dd:#56b6c2:#abb2bf:#5c6370:#e06c75:#87d787:#d19a66:#00aeff:#c678dd:#56b6c2:#ffffff"
#gset string background_color "#282c34"
gset string background_color "#000000"
gset string foreground_color "#abb2bf"
gset string bold_color "#abb2bf"
gset bool   bold_color_same_as_fg "true"
gset bool   use_theme_colors "false"
gset bool   use_theme_background "false"

unset PROFILE_NAME
unset PROFILE_SLUG
unset DCONF
unset UUIDGEN
