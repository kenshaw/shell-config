#!/bin/bash

for i in gitconfig gitignore vimrc; do 
  if [ ! -e ~/.$i ]; then
    echo "Copying: $i to ~/.$i"
    cp $i ~/.$i
  fi 
done
