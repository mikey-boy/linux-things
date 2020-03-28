#!/bin/sh

if [ "$EUID" -ne 0 ];then 
	echo "[-] Please run as root"
	exit
fi

# Flush any existing rules
iptables -F
iptables -X

# Setting default filter policy
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allow unlimited traffic on loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow browser, ssh, and nfs to operate
iptables -A INPUT -p tcp --match conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --match multiport --dports 22,80,111,443 -j ACCEPT
