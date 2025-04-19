#!/bin/bash

# Health Check Script for Local Machine
# Run with sudo for full functionality where required
#check for debug flag

if [ "$1" == "--debug" ]; then
    set -x  # Enable debug mode
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get timestamp

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "=== System Health Check - $TIMESTAMP ==="
echo "----------------------------------------"

# 1. Check CPU Usage
echo -e "\n${YELLOW}CPU Usage:${NC}"
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
echo "Current CPU Usage: $cpu_usage%"
if (( $(echo "$cpu_usage > 80" | bc -l) )); then
    echo -e "${RED}WARNING: High CPU usage detected${NC}"
elif (( $(echo "$cpu_usage > 50" | bc -l) )); then
    echo -e "${YELLOW}NOTICE: Moderate CPU usage${NC}"
else
    echo -e "${GREEN}CPU usage is normal${NC}"
fi

# 2. Check Memory Usage
echo -e "\n${YELLOW}Memory Usage:${NC}"
free -h | grep -E "Mem:|Swap:" | awk '{print $1 " " $2 " total, " $3 " used, " $4 " free"}'
mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
echo "Memory Usage Percentage: $(printf "%.1f" $mem_usage)%"
if (( $(echo "$mem_usage > 80" | bc -l) )); then
    echo -e "${RED}WARNING: High memory usage detected${NC}"
fi

# 3. Check Disk Space
echo -e "\n${YELLOW}Disk Space:${NC}"
df -h | grep -E "^/dev/"
disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
echo "Root Disk Usage: $disk_usage%"
if [ $disk_usage -gt 90 ]; then
    echo -e "${RED}WARNING: Disk space critically low${NC}"
elif [ $disk_usage -gt 75 ]; then
    echo -e "${YELLOW}NOTICE: Disk space running low${NC}"
else
    echo -e "${GREEN}Disk space is adequate${NC}"
fi

# 4. Check Running Processes
echo -e "\n${YELLOW}System Processes:${NC}"
process_count=$(ps -ef | wc -l)
echo "Total running processes: $((process_count - 1))"
# Check for zombie processes
zombie_count=$(ps -ef | grep defunct | grep -v grep | wc -l)
echo "Zombie processes: $zombie_count"
if [ $zombie_count -gt 0 ]; then
    echo -e "${RED}WARNING: Zombie processes detected${NC}"
fi

# 5. Check Network Connectivity
echo -e "\n${YELLOW}Network Status:${NC}"
# Check internet connectivity
ping -c 4 8.8.8.8 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Internet connection: Active${NC}"
else
    echo -e "${RED}Internet connection: Failed${NC}"
fi

# Check active network interfaces
ip -br a | grep UP | awk '{print "Active interface: " $1 " - " $3}'

# 6. Check System Uptime
echo -e "\n${YELLOW}System Uptime:${NC}"
uptime -p

echo -e "\n=== Health Check Complete ==="
