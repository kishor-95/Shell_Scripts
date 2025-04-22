#!/bin/bash

# Ask user for file size to search (e.g., 100M)
read -p "Enter minimum file size to search (e.g., 100M, 1G): " SIZE

# Ask for the directory to search
read -p "Enter directory to search in (default: /): " DIR
DIR=${DIR:-/}  # default to / if nothing entered

echo "Searching for files larger than $SIZE in $DIR..."
find "$DIR" -type f -size +"$SIZE" -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'

echo "------------------------------------------------------"

# Ask for a specific filename to search
read -p "Enter filename to search (e.g., backup.zip): " FILENAME

echo "Searching for $FILENAME in $DIR..."
FOUND=$(find "$DIR" -type f -name "$FILENAME")

if [[ -n "$FOUND" ]]; then
    echo "✅ File found:"
    echo "$FOUND"
else
    echo "❌ File not found."
fi

