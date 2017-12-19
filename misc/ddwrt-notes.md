# dd-wrt notes

## dnsmasq

### Under DD-WRT -> Setup:

1. Set "DHCP Type" as "DHCP Server"
2. Enable "DHCP Server"
3. Set "Client Lease Time" as "120"
4. Set "Static DNS N" appropriately
5. Check "Use DNSMasq for DHCP"
6. Check "Use DNSMasq for DNS"
7. Check "DHCP-Authoritative"

### Under DD-WRT -> Services:

1. Enable "DNSMasq"

2. Enable "Local DNS"

3. Disable "Query DNS in Strict Order"

4. Set "Additional DNSMasq Options" to:

```txt
local=/lan/
domain=lan
expand-hosts
all-servers
cache-size=10000
```

### Under DD-WRT -> Admin -> Commands

1. Save following as firewall script:

```sh
echo "nameserver 80.67.169.40
nameserver 198.101.242.72
nameserver 84.200.70.40
nameserver 84.200.69.80
nameserver 23.253.163.53
nameserver 74.82.42.42
nameserver 74.113.60.185
" > /tmp/resolv.dnsmasq
sleep 1
killall -HUP dnsmasq
```

 - see: https://wiki.ipfire.org/dns/public-servers
 - see: https://www.dd-wrt.com/wiki/index.php/DNSMasq_using_alternative_DNS-Servers

### Save and Reboot (for each step)

1. Click "Save" button
2. Click "Apply Settings" button
3. Click "Reboot Router" button

### Other DNSMasq options

See: http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html
