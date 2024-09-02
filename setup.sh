#!/bin/bash

SRC="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_DIR=$HOME/.config

PLATFORM=$(uname|sed -e 's/_.*//'|tr '[:upper:]' '[:lower:]'|sed -e 's/^\(msys\|mingw\).*/windows/')
if [ "$PLATFORM" = "windows" ]; then
  CONFIG_DIR=/c/Users/$USER/AppData/Local
fi

if [ ! -z "$REMOTE_SHELL_USER" ]; then
  echo "error: \$REMOTE_SHELL_USER is defined!"
  exit 1
fi

do_link() {
  if [[ -e $2 && "$(realpath $1)" != "$(realpath $2)" ]]; then
    echo "WARNING: $2 is linked to $(realpath $1); removing"
    (set -x;
      rm $2
    )
  fi
  if [[ ! -e $2 ]]; then
    (set -x;
      ln -s $1 $2
    )
  fi
}

# link dot files in env
for i in $(find $SRC/env -mindepth 1 -maxdepth 1); do
  NAME=$(basename $i)
  if [[ "$NAME" == "config" || "$NAME" == "applications" ]]; then
    continue
  fi
  do_link $i $HOME/.$NAME
done

# link symlinks in env/config
for i in $(find $SRC/env/config -mindepth 1 -maxdepth 1 -type l); do
  do_link $(realpath $i) "$HOME/.config/${i#"$SRC/env/config/"}"
done

# link files in env/config to config dir
for i in $(find $SRC/env/config -type f); do
  DIR=$(dirname "${i#$SRC/env/config/}")
  CFG=$HOME/.config
  if [ "$DIR" = "nvim" ]; then
    CFG=$CONFIG_DIR
  fi
  if [[ "$DIR" != "." && ! -z "$DIR" && ! -d $CFG/$DIR ]]; then
    (set -x;
      mkdir -p $CFG/$DIR
    )
  fi
  do_link $i "$CFG/${i#"$SRC/env/config/"}"
done

# ensure vim-plug exists
if [ ! -e $CONFIG_DIR/nvim/autoload/plug.vim ]; then
  curl -fLo $CONFIG_DIR/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# bail if not a desktop
if [[ "$XDG_SESSION_TYPE" != "x11" && "$XDG_SESSION_TYPE" != "wayland" ]]; then
  exit 0
fi

# link application files
if [[ ! -d $HOME/.local/share/applications ]]; then
  (set -x;
    mkdir -p $HOME/.local/share/applications
  )
fi
for i in $(find $SRC/env/applications -maxdepth 1 -type f -iname \*.desktop); do
  do_link $i "$HOME/.local/share/applications/$(basename $i)"
  ICON="$(sed -e s/\.desktop$/.svg/ <<< "$i")"
  if [ -f "$ICON" ]; then
    mkdir -p $HOME/.local/share/pixmaps
    do_link "$ICON" "$HOME/.local/share/pixmaps/$(basename "$ICON")"
  fi
done
