#!/bin/bash

SRC="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# link files in env
for i in $(ls $SRC/env); do
  if [[ ! -f $i && ! -e $HOME/.$i && $i != "init.vim" ]]; then
    echo "Linking: $SRC/env/$i to ~/.$i"
    ln -s $SRC/env/$i $HOME/.$i
  fi
done

# link neovim init
if [ ! -e $HOME/.config/nvim/init.vim ]; then
  echo "Creating ~/.config/nvim"
  mkdir -p $HOME/.config/nvim

  echo "Linking: $SRC/env/init.vim to ~/.config/nvim/init.vim"
  ln -s $SRC/env/init.vim $HOME/.config/nvim/init.vim
fi

LKBIN=$(which lesskey)
if [ ! -z "$LKBIN" ]; then
  echo "Running $LKBIN"
  $LKBIN
fi
