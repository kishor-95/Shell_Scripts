#!/bin/bash

#####################################################################################
# Authore: Kishor
# Version: v1
#####################################################################################

# CPU Performance Test Script
# Tests CPU performance using various methods

# Check for debug flag
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

echo "=== CPU Performance Test - $TIMESTAMP ==="
echo "----------------------------------------"

# Get CPU information
echo -e "\n${YELLOW}CPU Information:${NC}"
cpu_info=$(lscpu | grep -E "Model name|Architecture|CPU\(s\)|Thread|Core")
echo "$cpu_info"
echo "Number of CPU cores: $(nproc)"

# Function to perform a simple benchmark (Fibonacci calculation)
fibonacci_benchmark() {
    local n=40  # Adjust this number for longer/shorter tests
    local start_time=$(date +%s.%N)
    local a=0
    local b=1
    local i
    
    for ((i=0; i<n; i++)); do
        local temp=$a
        a=$b
        b=$((temp + b))
    done
    
    local end_time=$(date +%s.%N)
    local elapsed=$(echo "$end_time - $start_time" | bc)
    echo "Fibonacci($n) calculation took: $elapsed seconds"
}

# 1. Basic CPU Benchmark
echo -e "\n${YELLOW}Basic CPU Benchmark:${NC}"
echo "Running single-threaded Fibonacci calculation..."
fibonacci_benchmark

# 2. Multi-core stress test using 'stress' (if installed)
echo -e "\n${YELLOW}Multi-core Stress Test:${NC}"
if command -v stress >/dev/null 2>&1; then
    echo "Running stress test for 30 seconds on all cores..."
    echo "Monitoring CPU usage in parallel..."
    
    # Start stress in background (30 seconds, all cores)
    stress --cpu $(nproc) --timeout 30s &>/dev/null &
    stress_pid=$!
    
    # Monitor CPU usage during test
    for i in {1..6}; do
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
        echo "CPU Usage (Sample $i/6): $cpu_usage%"
        sleep 5
    done
    
    # Wait for stress to complete
    wait $stress_pid
    echo -e "${GREEN}Stress test completed${NC}"
else
    echo -e "${RED}Note: 'stress' tool not found. Install it with 'sudo apt install stress' (Ubuntu/Debian)${NC}"
    echo "Skipping multi-core stress test"
fi

# 3. Simple arithmetic benchmark
echo -e "\n${YELLOW}Arithmetic Performance Test:${NC}"
echo "Performing 1 million arithmetic operations..."
start_time=$(date +%s.%N)
for ((i=0; i<1000000; i++)); do
    result=$((i * i / 2 + 3))
done
end_time=$(date +%s.%N)
elapsed=$(echo "$end_time - $start_time" | bc)
echo "1M arithmetic operations took: $elapsed seconds"

# 4. System load average
echo -e "\n${YELLOW}System Load Average:${NC}"
load_avg=$(uptime | awk -F'load average:' '{print $2}')
echo "Current load averages (1/5/15 min): $load_avg"

echo -e "\n=== CPU Performance Test Complete ==="
