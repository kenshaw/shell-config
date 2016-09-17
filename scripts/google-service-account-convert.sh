#!/bin/bash

KEY=$1
OUT=$2

if [[ $1 == "" || $2 == "" ]]; then
  echo "$0 <service account file.json> <out.p12>"
  exit 1
fi

jq -r '.private_key' $KEY | openssl pkcs12 -export -nocerts -inkey /dev/stdin -out $OUT -passout pass:
