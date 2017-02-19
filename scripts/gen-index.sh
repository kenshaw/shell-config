#!/bin/bash

DIR=$PWD

if [ ! -z "$1" ]; then
  DIR=$1
fi

if [[ ! "$DIR" =~ \/$ ]]; then
  DIR="${DIR}/"
fi

IDX=$2
if [ -z "$IDX" ]; then
  IDX="/index.html"
fi

if [[ ! "$IDX" =~ ^\/ ]]; then
  IDX="/${IDX}"
fi

echo '<html><body>'
find "$DIR" -maxdepth 1 -type d -not -name \.\* |sort |grep -oP "^$DIR\K.*" |sed -e "s#^.*#<a href=\"&${IDX}\">& [DIR]</a><br/>#"
find "$DIR" -maxdepth 1 -type f -not -name \.\* -not -name index.html|sort |grep -oP "^$DIR\K.*" |sed -e "s#^.*#<a href=\"&\">&</a><br/>#"
echo '</body></html>'
