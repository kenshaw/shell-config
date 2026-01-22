#!/bin/bash

NAME=Example
EMAIL=kenshaw@gmail.com
ISSUER="Example Issuer"
SECRET=$(cat /dev/urandom | LANG=C tr -dc A-Z2-7 | head -c16)

OPTIND=1
while getopts "s:i:e:n:" opt; do
case "$opt" in
  s) SECRET=$OPTARG ;;
  e) EMAIL=$OPTARG ;;
  i) ISSUER=$OPTARG ;;
  n) NAME=$OPTARG ;;
esac
done

enc() {
  printf "%s" "$1" |jq -sRr @uri
}

convert_base32_to_hex() {
    local base32=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    local base32chars="ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
    local bits=""
    local hex=""

    for (( i=0; i<${#base32}; i++ )); do
        char="${base32:$i:1}"
        prefix="${base32chars%%$char*}"
        val=${#prefix}
        binary=$(echo "obase=2; $val" | bc)
        printf -v padded_bin "%05d" "$binary"
        bits+="$padded_bin"
    done

    for (( i=0; i+4<=${#bits}; i+=4 )); do
        chunk="${bits:$i:4}"
        dec=$((2#$chunk))
        printf -v hex_chunk "%X" "$dec"
        hex+="$hex_chunk"
    done

    echo "$hex"
}

DUOCODE=$(convert_base32_to_hex "$SECRET")

OTPAUTH=$(printf "otpauth://totp/%s:%s?secret=%s&issuer=%s" "$NAME" "$EMAIL" "$SECRET" "$(enc "$ISSUER")")

HASH=$(md5sum <<< "$OTPAUTH"|awk '{print $1}')

OUT=$HOME/.config/qrtotp/$HASH
echo "$OTPAUTH" > $OUT

echo "STORING: $OUT"
echo "DUOCODE: $DUOCODE"
iv "$OTPAUTH"
