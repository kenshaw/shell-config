```
table inet filter
delete table inet filter
table inet filter {
  chain output {
    type filter hook output priority 100; policy accept;
  }
  chain input {
    type filter hook input priority filter
    policy drop

    ct state invalid drop comment "early drop of invalid connections"
    ct state {established, related} accept comment "allow tracked connections"
    iifname lo accept comment "allow from loopback"
    ip protocol icmp accept comment "allow icmp"
    meta l4proto ipv6-icmp accept comment "allow icmp v6"
    ip saddr 100.64.0.0/24 tcp dport ssh accept comment "allow sshd"
    tcp dport https accept comment "allow https"
    udp dport 3478 accept comment "tailscale derp"
    udp dport 41641 accept comment "tailscale"
    pkttype host limit rate 5/second counter reject with icmpx type admin-prohibited
    counter
  }
  chain forward {
    type filter hook forward priority filter
    policy drop
    iifname "tailscale0" oifname "enp6s0" accept
    iifname "enp6s0" oifname "tailscale0" ct state related,established accept
  }
}
```
