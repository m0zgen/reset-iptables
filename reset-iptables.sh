#!/bin/bash
# Author: Yevgeniy Goncharov aka xck, http://sys-admin.kz

#stat=$(/sbin/iptables -L -v -n);

echo -e "\nBackup IPTABLES"
/bin/cp /etc/sysconfig/iptables /etc/sysconfig/iptables_$(date +%Y%m%d).bak

echo -e "\nStop IPTABLES"
/sbin/service iptables stop

echo -e "\nFlush IPTABLES!"

IPTABLES="$(which iptables)"

# RESET DEFAULT POLICIES
$IPTABLES -P INPUT ACCEPT
$IPTABLES -P FORWARD ACCEPT
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -t nat -P PREROUTING ACCEPT
$IPTABLES -t nat -P POSTROUTING ACCEPT
$IPTABLES -t nat -P OUTPUT ACCEPT
$IPTABLES -t mangle -P PREROUTING ACCEPT
$IPTABLES -t mangle -P OUTPUT ACCEPT

# FLUSH ALL RULES, ERASE NON-DEFAULT CHAINS
$IPTABLES -F
$IPTABLES -X
$IPTABLES -t nat -F
$IPTABLES -t nat -X
$IPTABLES -t mangle -F
$IPTABLES -t mangle -X

echo -e "\nStart IPTABLES"
/sbin/service iptables start

/sbin/service iptables save
/sbin/service iptables reload

echo -e "\n$(/sbin/iptables -L -v -n)\n"
echo "Done!"