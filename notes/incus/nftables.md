Fix issues with default `nftables.conf`:

```nftables
destroy table inet filter
table inet filter {
  chain input {
    iifname incusbr0 counter accept
    oifname incusbr0 ct state related,established counter accept

    type filter hook input priority filter
    policy drop
    ...
```
