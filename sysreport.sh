#!/bin/bash
echo "System Report - $(date)"

echo " Hostname:$(hostname)"
echo " IP Address:$( ip a | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1
)"
echo " OS Version:$(cat /etc/redhat-release)"
echo " Uptime:$(uptime -p)"
echo " Logged-in users:$(who)"
