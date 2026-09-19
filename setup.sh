#!/bin/bash

SRC="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PLATFORM=$(uname|sed -e 's/_.*//'|tr '[:upper:]' '[:lower:]'|sed -e 's/^\(msys\|mingw\).*/windows/')

CONFIG_DIR=$HOME/.config
if [ "$PLATFORM" = "windows" ]; then
  # ln -s must produce real NTFS symlinks, not copies; needs developer mode
  # (or an elevated shell)
  export MSYS=winsymlinks:nativestrict

  # %LOCALAPPDATA% is authoritative -- the profile dir does not always match
  # $USER, and the drive is not always C:
  if [ -n "$LOCALAPPDATA" ]; then
    CONFIG_DIR=$(cygpath -u "$LOCALAPPDATA")
  else
    CONFIG_DIR=$(cygpath -u "$(cmd //d //c 'echo %LOCALAPPDATA%' | tr -d '\r')")
  fi

  # bail early if symlinks silently degrade to copies, otherwise the whole run
  # scatters stale duplicates through AppData
  probe=$(mktemp -d)
  if ! ln -s "$SRC/setup.sh" "$probe/probe" 2>/dev/null || [ ! -L "$probe/probe" ]; then
    rm -rf "$probe"
    echo "ERROR: cannot create native symlinks." >&2
    echo "  enable Developer Mode (Settings > System > For developers), or run" >&2
    echo "  this from an elevated MSYS2 shell." >&2
    exit 1
  fi
  rm -rf "$probe"
fi

rm_link() {
  local target
  target=$(readlink "$1" 2>/dev/null) || return 0

  # never touch systemd unit links
  case "$1" in "$CONFIG_DIR"/systemd/user/*) return 0 ;; esac

  # only ever remove links that point back into this repo. on windows the home
  # directory is full of legacy junctions (Cookies, My Documents, ...) that look
  # like symlinks and deny access -- a broken-link heuristic would delete them.
  case "$target" in
    "$SRC"/*)
      (set -x;
        rm -f "$1"
      )
    ;;
  esac
}

clean_config() {
  local d
  [ -d "$HOME" ] && for i in $(find "$HOME" -mindepth 1 -maxdepth 1 -type l 2>/dev/null); do
    rm_link "$i"
  done
  for d in "$CONFIG_DIR" "$HOME/.local/share/applications" "$HOME/.local/share/pixmaps"; do
    [ -d "$d" ] || continue
    for i in $(find "$d" -type l 2>/dev/null); do
      rm_link "$i"
    done
  done
}

do_link() {
  if [[ -e $2 && "$(realpath "$1")" != "$(realpath "$2")" ]]; then
    echo "WARNING: $2 is linked to $(realpath "$2"); removing"
    (set -x;
      rm -f "$2"
    )
  fi
  if [[ ! -e $2 ]]; then
    mkdir -p "$(dirname "$2")"
    (set -x;
      ln -s "$1" "$2"
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
  do_link $(realpath $i) "${CONFIG_DIR}/${i#"$SRC/config/"}"
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
