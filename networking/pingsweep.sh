#!/bin/sh

# Simple script to check active hosts in /24 CIDR range
# Runs concurrently, attempts 5 ICMP packets before timing out

IPADDR=8.8.8

echo "Active Hosts:"
seq 0 255 | xargs -n 1 --max-procs=255 -I i ping -c5 -W1 $IPADDR.i | grep "bytes from" | cut -d" " -f4 | cut -d: -f1 | sort -u 

