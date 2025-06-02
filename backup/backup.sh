#!/bin/bash

set -e

SOURCE="path/to/source"  # Replace with your actual source directory
DESTINATION="path/to/destination"  # Replace with your actual destination directory
BACKUP_DATE=$(date +%Y-%m-%d)
LOG_FILE="$DESTINATION/backup_log_$BACKUP_DATE.txt"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$SOURCE" == "path/to/source" ]]; then
    echo "Error: Please set your source directory in the script."
    echo "Edit the SOURCE variable in $SCRIPT_DIR/backup.sh"
    exit 1
fi

if [[ "$DESTINATION" == "path/to/destination" ]]; then
    echo "Error: Please set your destination directory in the script."
    echo "Edit the DESTINATION variable in $SCRIPT_DIR/backup.sh"
    exit 1
fi

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
