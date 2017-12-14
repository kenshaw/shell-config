# How to forward to 80 + 443 -> 8443 on localhost

Edit `/etc/ufw/before.rules` and add the following **BEFORE** the `*filter` rules:

```txt
*nat
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A PREROUTING -p tcp                 --dport  80 -j REDIRECT --to-port 8443
-A PREROUTING -p tcp                 --dport 443 -j REDIRECT --to-port 8443
-A OUTPUT     -p tcp --dst 127.0.0.1 --dport  80 -j REDIRECT --to-port 8443
-A OUTPUT     -p tcp --dst 127.0.0.1 --dport 443 -j REDIRECT --to-port 8443
COMMIT
```

Run the following and/or perform manually:

```sh
# disable ufw and clear all existing iptables
$ sudo ufw disable
$ sudo ~/src/shell-config/misc/clear-all-iptables.sh

# ensure that dest and source ports are BOTH ALLOWED
$ sudo ufw allow http
$ sudo ufw allow https
$ sudo ufw allow 8443

# change default forward policy and ufw sysctl policy
$ sudo perl -pi -e 's/DEFAULT_FORWARD_POLICY="DENY"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
$ sudo perl -pi -e 's|#net/ipv4/ip_forward=1|net/ipv4/ip_forward=1|' /etc/ufw/sysctl.conf

# reenable ufw
$ sudo ufw enable
```
