#!/bin/bash

# taken from http://www.debian-administration.org/articles/595

if [ $# != 4 ]
then
  echo "usage: $0 <src-ip> <src-port> <dst-ip> <dst-port>"
  exit 0
fi

SRC_IP=$1
SRC_PORT=$2
DEST_IP=$3
DEST_PORT=$4

echo 1 > /proc/sys/net/ipv4/ip_forward

iptables -t nat -A PREROUTING --dst $SRC_IP -p tcp --dport $SRC_PORT -j DNAT --to-destination $DEST_IP:$DEST_PORT
iptables -t nat -A POSTROUTING -p tcp --dst $DEST_IP --dport $DEST_PORT -j SNAT --to-source $SRC_IP
iptables -t nat -A OUTPUT --dst $SRC_IP -p tcp --dport $SRC_PORT -j DNAT --to-destination $DEST_IP:$DEST_PORT
