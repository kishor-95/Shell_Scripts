#!/bin/bash

wget -q --spider https://google.com

if [ $? -eq 0 ]; then
echo "Connectd to Internet"
else
echo "Offline you are offline"
fi
