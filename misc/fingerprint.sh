#!/bin/bash

HOST=$1

if [ -z "$HOST" ]; then
  echo "usage: $0 <HOST:PORT>"
  exit
fi

set -e
openssl s_client -connect $HOST < /dev/null 2>/dev/null \
  | openssl x509 -fingerprint -noout -in /dev/stdin\
  | cut --delimiter '=' -f 2 \
  | tr -d '[:]' | tr '[A-F]' '[a-f]'
