#!/bin/bash

IP=$1

INETNUM=$(whois $IP|sed -n 's/^\(inetnum\|netrange\):\s*\([0-9\.]\+\s*-\s*[0-9\.]\+\).*/\2/ip')

if [ -z "${INETNUM}" ]; then
  echo -n "UNKNOWN"
else
  NETMASK=$(ipcalc $INETNUM|tail -n +2|sed ':a;N;$!ba;s/\n/, /g')
  echo -n $NETMASK
fi
