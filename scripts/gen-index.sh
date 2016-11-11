#!/bin/bash

DIR=$PWD

if [ ! -z "$1" ]; then
  DIR=$1
fi

echo '<html><body>'
ls $DIR|sed 's/^.*/<a href="&">&<\/a><br\/>/'
echo '</body></html>'
