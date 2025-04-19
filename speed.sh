#!/bin/bash

# Disk to test (default: /tmp)
TEST_FILE="/tmp/testfile"
TEST_SIZE="1G"

echo "=== Disk Speed Test Script ==="
echo "Testing write speed with dd..."

# Write speed test
WRITE_SPEED=$(dd if=/dev/zero of=$TEST_FILE bs=1G count=1 oflag=direct 2>&1 | grep -o '[0-9.]* MB/s')

echo "Write Speed: $WRITE_SPEED"

echo "Testing read speed with dd (cached)..."

# Read speed (cached)
READ_SPEED=$(dd if=$TEST_FILE of=/dev/null bs=1G count=1 2>&1 | grep -o '[0-9.]* MB/s')

echo "Read Speed (cached): $READ_SPEED"

# Clean up
rm -f $TEST_FILE

echo "Test completed."

