#!/bin/bash

SRC="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -z "$REMOTE_SHELL_USER" ]; then
  echo "error: \$REMOTE_SHELL_USER is defined!"
  exit 1
fi

# link files in env
for i in $(ls $SRC/env); do
  if [[ ! -f $i && ! -e $HOME/.$i && $i != "init.vim" && $i != "coc-settings.json" ]]; then
    echo "LINKING: $SRC/env/$i -> ~/.$i"
    ln -s $SRC/env/$i $HOME/.$i
  fi
done

if [ ! -d $HOME/.config/nvim ]; then
  echo "CREATING: ~/.config/nvim"
  mkdir -p $HOME/.config/nvim
fi

# link neovim init
if [ ! -e $HOME/.config/nvim/init.vim ]; then
  echo "LINKING: $SRC/env/init.vim -> ~/.config/nvim/init.vim"
  ln -s $SRC/env/init.vim $HOME/.config/nvim/init.vim
fi

if [ ! -e $HOME/.config/nvim/coc-settings.json ]; then
  echo "LINKING: $SRC/env/coc-settings.json -> ~/.config/nvim/coc-settings.json"
  ln -s $SRC/env/coc-settings.json $HOME/.config/nvim/coc-settings.json
fi

if [ ! -e $HOME/.config/nvim/autoload/plug.vim ]; then
  curl -fLo $HOME/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

LKBIN=$(which lesskey)
if [ ! -z "$LKBIN" ]; then
  echo "Running $LKBIN"
  $LKBIN
fi
