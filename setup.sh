#!/bin/bash

SRC="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_DIR=$HOME/.config

PLATFORM=$(uname|sed -e 's/_.*//'|tr '[:upper:]' '[:lower:]'|sed -e 's/^\(msys\|mingw\).*/windows/')
if [ "$PLATFORM" = "windows" ]; then
  CONFIG_DIR=/c/Users/$USER/AppData/Local
fi

rm_link() {
  if [[ "$(readlink "$1")" =~ ^$SRC ]]; then
    (set -x;
      rm "$1"
    )
  fi
}

clean_config() {
  for i in $(find $HOME -mindepth 1 -maxdepth 1 -type l); do
    rm_link "$i"
  done
  for d in $CONFIG_DIR $HOME/.local/share/applications $HOME/.local/share/pixmaps; do
    for i in $(find $d -type l); do
      rm_link "$i"
    done
  done
}

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

# clean config
clean_config

if [ "$1" = "--clean" ]; then
  echo "exiting from --clean"
  exit 0
fi

# link dot files in home dir
for i in $(find $SRC/home -mindepth 1 -maxdepth 1); do
  do_link $i $HOME/.$(basename $i)
done

# link symlinks in config dir
for i in $(find $SRC/config -mindepth 1 -maxdepth 1 -type l); do
  do_link $(realpath $i) "$HOME/.config/${i#"$SRC/config/"}"
done

# link files in config dir
for i in $(find $SRC/config -type f); do
  mkdir -p "${CONFIG_DIR}/$(dirname "${i#$SRC/config/}")"
  do_link $i "${CONFIG_DIR}/${i#"$SRC/config/"}"
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
mkdir -p $HOME/.local/share/applications $HOME/.local/share/pixmaps
for i in $(find $SRC/apps -maxdepth 1 -type f -iname \*.desktop); do
  do_link $i "$HOME/.local/share/applications/$(basename $i)"
  ICON="$(sed -e s/\.desktop$/.svg/ <<< "$i")"
  if [ -f "$ICON" ]; then
    do_link "$ICON" "$HOME/.local/share/pixmaps/$(basename "$ICON")"
  fi
done
