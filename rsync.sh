#!/bin/bash

# Backup of deployment of WordPress
DIR="/root/kubernetes/"
TAR_DIR="/root/kubernetes-projects"
IP="192.168.65.110"
USER="root"

## make sure passwordless auth is already set up with the target node

## Check if $DIR exists
if [[ -d $DIR ]]; then
    echo "$DIR is present"
else
    echo "$DIR is not present"
    echo "Creating $DIR"
    mkdir -p $DIR
    echo "Directory $DIR is created"
fi

## Check if remote connection is available
ping $IP -c 1 >> /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "Remote connection $IP is available"
else
    echo "Check the remote connection"
    exit 1
fi

## Prepare rsync command to backup
if [[ $? -eq 0 ]]; then
    echo "Copying files"
    rsync -arv $USER@$IP:$TAR_DIR $DIR
    if [[ $? -eq 0 ]]; then
        echo "Backup completed successfully"
    else
        echo "Failed to copy files"
        exit 1
    fi
else
    echo "Failed to check remote connection"
    exit 1
fi

