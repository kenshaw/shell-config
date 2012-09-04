#!/bin/bash

for i in gitconfig gitignore vimrc; do 
  echo cp $i ~/.$i
done
