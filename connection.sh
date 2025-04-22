#!/bin/bash

wget -q --spider https://google.com

if [ $? -eq 0 ]; then
echo "Online"
else
echo "Offline"
fi
