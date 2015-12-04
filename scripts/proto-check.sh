#!/bin/bash

# simple script using openssl to get the available protocols (ie, to check for http/2)

HOST="$1"
PORT="443"

PAR=$(echo $HOST|awk -F: '{print $2}')

if [ ! -z "$PAR" ]; then
  PORT="$PAR"
elif [ ! -z "$2" ]; then
  PORT="$2"
else
  PORT="443"
fi

openssl s_client -connect $HOST:$PORT -nextprotoneg '' 2>&1 |sed -n -e 's/^Protocols advertised by server:\s*//p'
