#!/bin/bash

# to use: run as root, writing the file to /etc/nftables/cloudflare-ranges.conf
#
# then in /etc/nftables.conf:
#
# include "/etc/nftables/*.conf"
#
# table inet firewall {
#    set cloudflare_ipv4 {
#       type ipv4_addr
#       flags interval
#       elements = $cloudflare_ranges_ipv4
#    }
#    set cloudflare_ipv6 {
#       type ipv6_addr
#       flags interval
#       elements = $cloudflare_ranges_ipv6
#    }
#
#    chain input {
#       ...
#       tcp dport https ip  saddr 127.0.0.1 accept comment "allow https 127.0.0.1"
#       tcp dport https ip6 saddr ::1       accept comment "allow https ::1"
#       tcp dport https ip  saddr @cloudflare_ipv4 accept comment "allow cloudflare https ipv4"
#       tcp dport https ip6 saddr @cloudflare_ipv6 accept comment "allow cloudflare https ipv6"
#       ...
#    }
#
# }

CLOUDFLARE_IPv4=https://www.cloudflare.com/ips-v4
CLOUDFLARE_IPv6=https://www.cloudflare.com/ips-v6

DEST=/etc/nftables/cloudflare-ranges.conf
WRITE=0
NAME=cloudflare

OPTIND=1
while getopts "d:w" opt; do
case "$opt" in
  d) DEST=$OPTARG ;;
  w) WRITE=1 ;;
esac
done

set -e

IPv4=$(curl -4 -s $CLOUDFLARE_IPv4|tr '\n' ' '|sed -e 's/ /,\n  /g')
IPv6=$(curl -4 -s $CLOUDFLARE_IPv6|tr '\n' ' '|sed -e 's/ /,\n  /g')

CONF=$(cat << __EOF__
define cloudflare_ranges_ipv4 = {
  $IPv4
}

define cloudflare_ranges_ipv6 = {
  $IPv6
}
__EOF__
)

echo "$CONF"

if [ "$WRITE" != "1" ]; then
  exit 0
fi

mkdir -p "$(dirname "$DEST")"
echo "$CONF" > "$DEST"
