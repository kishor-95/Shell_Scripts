#!/bin/bash

echo " Used resource at $(date)"

echo "Disk usage of root(/) = $(df -h /)"

echo "Total Memory and Used memory = $(free -ht)"

echo " Top 5 Processes by memmory usage = $(ps -aux --sort=-%mem | head -n 6)"

