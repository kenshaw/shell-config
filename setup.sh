#!/bin/bash

for i in gitconfig gitignore vimrc; do 
  if [ ! -e ~/$i ]; then 
    cp $i ~/.$i
  fi 
done
