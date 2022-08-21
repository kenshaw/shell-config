#!/bin/bash

SRC="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -z "$REMOTE_SHELL_USER" ]; then
  echo "error: \$REMOTE_SHELL_USER is defined!"
  exit 1
fi

do_link() {
  if [[ ! -e $2 ]]; then
    (set -x;
      ln -s $1 $2)
  fi
}

# link dot files in env
for i in $(find $SRC/env -mindepth 1 -maxdepth 1); do
  NAME=$(basename $i)
  if [[ "$NAME" == "config" ]]; then
    continue
  fi
  do_link $i $HOME/.$NAME
done

# link files in env/config to config dir
for i in $(find $SRC/env/config -type f); do
  DIR=$(dirname "${i#$SRC/env/config/}")
  if [[ "$DIR" != "." && ! -z "$DIR" && ! -d $HOME/.config/$DIR ]]; then
    (set -x;
      mkdir -p $HOME/.config/$DIR
    )
  fi
  do_link $i "$HOME/.config/${i#"$SRC/env/config/"}"
done

# ensure vim-plug exists
if [ ! -e $HOME/.config/nvim/autoload/plug.vim ]; then
  curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
