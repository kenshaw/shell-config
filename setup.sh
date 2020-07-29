#!/bin/bash

SRC="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -z "$REMOTE_SHELL_USER" ]; then
  echo "error: \$REMOTE_SHELL_USER is defined!"
  exit 1
fi

# link files in env
for i in $(ls $SRC/env); do
  if [[ ! -f $i && ! -e $HOME/.$i && $i != "init.vim" ]]; then
    echo "LINKING: $SRC/env/$i -> ~/.$i"
    ln -s $SRC/env/$i $HOME/.$i
  fi
done

# link neovim init
if [ ! -e $HOME/.config/nvim/init.vim ]; then
  echo "CREATING: ~/.config/nvim"
  mkdir -p $HOME/.config/nvim
  echo "LINKING: $SRC/env/init.vim -> ~/.config/nvim/init.vim"
  ln -s $SRC/env/init.vim $HOME/.config/nvim/init.vim
fi

LKBIN=$(which lesskey)
if [ ! -z "$LKBIN" ]; then
  echo "Running $LKBIN"
  $LKBIN
fi
