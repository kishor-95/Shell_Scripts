#!/bin/bash

set -e

## Setting up requirements 

SOURCE="/var/log"
DEST="/backup"
TIME="$(date +%Y-%m-%d_%H:%M:%S)"
BACKUP_FILE_NAME="backup_$TIME.tar.gz"

## Checking the path are aviables

if [ -d $DEST ]; then
	echo "Given $DEST is present"
else
	echo "Given $DEST is not present"
	read -p "You want to create $DEST:  " response
	if [[ $response == Yes || $response == Y ]]; then
		echo "Creating $DEST Directory"
		sudo mkdir -p $DEST
		echo "$DEST directory created suceesfull"
	else
		echo "Error"
		exit 1
	fi
fi


## creating backup file

sudo tar -czf "$DEST/$BACKUP_FILE_NAME" -C "$(dirname $SOURCE)" "$(basename $SOURCE)"

## Checking Size of  backup file
echo "Checking the size of $BACKUP_FILE_SIZE:"
BACKUP_SIZE=$(du -sh "$DEST/$BACKUP_FILE_NAME" | cut -f1)
echo "Backup completed: $BACKUP_FILE_NAME (Size: $BACKUP_SIZE)" | sudo tee -a /var/log/backup.log

## delete backups older than 7 days: 
sudo find $DEST -name "backup_*.tar.gz" -mtime +7 -delete
