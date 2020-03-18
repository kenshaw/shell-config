#!/bin/bash

APT=apt-get
APTITUDE=$(which aptitude||:)
if [ ! -z "$APTITUDE" ]; then
  APT=$APTITUDE
fi

if [ "$USER" != "root" ]; then
  echo "error: not root!"
  exit 1
fi

VARIANT=unstable

OPTIND=1
while getopts "v:" opt; do
case "$opt" in
  v) VARIANT=$OPTARG ;;
esac
done

set -x
add-apt-repository -y ppa:neovim-ppa/$VARIANT
$APT install neovim python-neovim python3-neovim -y
update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
update-alternatives --set vi /usr/bin/nvim
update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
update-alternatives --set vim /usr/bin/nvim
update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
update-alternatives --set editor /usr/bin/nvim
