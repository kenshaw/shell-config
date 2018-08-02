#!/bin/bash

SRC="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# link files in gitconfig
for i in $(ls $SRC/|grep -v \.sh); do
  if [[ ! -e $HOME/.gitconfig-$i ]]; then
    echo "Linking: $SRC/$i to ~/.gitconfig-$i"
    ln -s $SRC/$i $HOME/.gitconfig-$i
  fi
done
