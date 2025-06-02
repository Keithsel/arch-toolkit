#!/bin/bash

SOURCE="path/to/source"  # Replace with your actual source path
DESTINATION="/path/to/destination"  # Replace with your actual destination path
BACKUP_DATE=$(date +%Y-%m-%d)
LOG_FILE="$DESTINATION/backup_log_$BACKUP_DATE.txt"

if [ ! -d "$(dirname "$DESTINATION")" ]; then
    echo "Error: Backup destination not available."
    exit 1
fi

mkdir -p "$DESTINATION"

echo "Starting backup at $(date)" | tee -a "$LOG_FILE"
echo "Backing up from $SOURCE to $DESTINATION" | tee -a "$LOG_FILE"

sudo rsync -aXvhP --info=progress2 \
    --exclude-from="$(dirname "$0")/exclusions.txt" \
    "$SOURCE" "$DESTINATION/" | sudo tee -a "$LOG_FILE"

echo "Backup completed at $(date)" | sudo tee -a "$LOG_FILE"
echo "Backup size: $(sudo du -sh "$DESTINATION" | sudo cut -f1)" | sudo tee -a "$LOG_FILE"
