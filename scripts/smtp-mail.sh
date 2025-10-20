#!/bin/bash

HOST=$1
PORT=25
FROM=$2
TO=$3

if [ ! -z "$(cut -s -d: -f2 <<< "$HOST")" ]; then
  PORT=$(cut -s -d: -f2 <<< $HOST)
  HOST=${HOST%:$PORT}
fi

if [[ -z "$HOST" || -z "$PORT" || -z "$FROM" || -z "$TO" ]]; then
  echo "usage: $0 <host>[:port] <from> <to>"
  exit 1
fi

DATA=$(cat << END
EHLO $HOST
MAIL FROM: $FROM
RCPT TO: $TO
DATA
From: $FROM
To: $TO
Subject: test email

This is a test email from $FROM to $TO -- $(date)
.

QUIT
END
)

(while read LINE; do
  sleep 0.2s
  echo "> $LINE" 1>&2
  echo $LINE
done <<< "$DATA") | telnet $HOST $PORT
