#!/bin/bash

for i in gitconfig gitignore vimrc; do 
  cp $i ~/.$i
done
