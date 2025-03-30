#!/bin/bash

# Variables
LOCAL_DIR="/home/ubuntu/wisecow"
S3_BUCKET="wisecow"
S3_FOLDER="Backups"
TIMESTAMP=$(date +'%Y%m%d%H%M%S')
BACKUP_NAME="backup_$TIMESTAMP.tar.gz"
LOG_FILE="$LOCAL_DIR/logs/backup.log"
BACKUP_PATH="/tmp/$BACKUP_NAME"

# Create a backup file
echo "Starting backup at $(date)" >> "$LOG_FILE"
tar -czf "$BACKUP_PATH" -C "$LOCAL_DIR" . >> "$LOG_FILE" 2>&1

# Upload the backup file to S3
aws s3 cp "$BACKUP_PATH" "s3://$S3_BUCKET/$S3_FOLDER/$BACKUP_NAME" >> "$LOG_FILE" 2>&1

# Log the result and clean up
if [ $? -eq 0 ]; then
    echo "Backup and upload successful at $(date)" >> "$LOG_FILE"
else
    echo "Error during backup or upload at $(date)" >> "$LOG_FILE"
fi

rm "$BACKUP_PATH"
