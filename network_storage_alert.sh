#!/bin/bash

echo -e "\n📅 Date: $(date)"
echo -e "🔌 Hostname: $(hostname)"
echo -e "🌐 IP Address: $(hostname -I | awk '{print $1}')"

# Network check
ping -c 2 google.com &> /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Network: Connected"
else
    echo "❌ Network: Disconnected"
fi

# Ping latency
echo -e "\n📶 Ping Latency to google.com:"
ping -c 2 google.com | tail -2 | head -1

# Disk usage alert
echo -e "\n💽 Checking Disk Usage:"
disk_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

echo "Current Root Partition Usage: $disk_usage%"
if [ $disk_usage -gt 80 ]; then
    echo "🚨 ALERT: Disk usage above 80%!"
else
    echo "✅ Disk usage is under control."
fi

