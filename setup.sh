#!/bin/bash

SRC="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for i in $(ls $SRC/env); do
  if [[ ! -f $i && ! -e ~/.$i ]]; then
    echo "Linking: $SRC/env/$i to ~/.$i"
    ln -s $SRC/env/$i ~/.$i
  fi
done

if [[ ! -d ~/src/icdiff ]]; then
  echo "Checking out icdiff"

  pushd ~/src > /dev/null
  git clone https://github.com/jeffkaufman/icdiff.git

  popd > /dev/null
fi

lesskey
