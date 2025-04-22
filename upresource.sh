echo -e "\nDisk usage of root(/):"
df -h /

echo -e "\nTotal Memory and Used memory:"
free -ht

echo -e "\nTop 5 Processes by memory usage:"
ps aux --sort=-%mem | head -n 6

