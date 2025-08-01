#!/bin/bash
#
# weekly-borg-backup.sh
# 
# This script performs a weekly backup of a specified directory to a remote
# repository using Borg backup, with healthchecks.io integration for monitoring.
#
# Usage: ./weekly-borg-backup.sh
# Recommended: Set this up as a cron job to run weekly
#   0 2 * * 0 /path/to/weekly-borg-backup.sh > /path/to/backup.log 2>&1
#

set -e # Exit immediately if a command exits with a non-zero status


CONFIGFILE="./backup.conf"
if [ -f "$CONFIGFILE" ]; then
  source "$CONFIGFILE"
else
  echo "Configuration file $CONFIGFILE not found. Exiting."
  exit 1
fi

# Borg repository
export BORG_REPO="ssh://${REMOTE_USER}@${REMOTE_HOST}:23/${REMOTE_PATH}"

# Password for the Borg repository (you should set this as an environment variable)
export BORG_PASSPHRASE="$BORG_PASSPHRASE"
# Alternatively, use a password file:
#export BORG_PASSCOMMAND="cat $HOME/.borg-passphrase"

# Set PATH if needed (useful in cron)
export PATH="$PATH:/usr/local/bin:/usr/bin"

# Log file for backup operations
#LOG_FILE="/var/log/borg-backup.log"
# ============================================================================

# Start logging
echo "=== Backup started at $(date) ===" | tee -a "$LOG_FILE"

# Signal start to healthchecks.io (optional - adds /start to URL)
#curl -fsS -m 10 --retry 5 "${HEALTHCHECKS_URL}/start" > /dev/null || true

# Generate archive name
DATE=$(date +%Y-%m-%d)
ARCHIVE_NAME="backup_${DATE}"

# Check if SSH connection works
echo "Testing SSH connection..." | tee -a "$LOG_FILE"
if ! ssh -q "${REMOTE_USER}@${REMOTE_HOST}" exit; then
  echo "ERROR: Cannot connect to remote host via SSH." | tee -a "$LOG_FILE"
  #curl -fsS -m 10 --retry 5 --data-raw "ERROR: SSH connection failed" "${HEALTHCHECKS_URL}/fail" > /dev/null || true
  exit 1
fi

# Function to handle failures
backup_failed() {
  echo "Backup failed at $(date)" | tee -a "$LOG_FILE"
  #curl -fsS -m 10 --retry 5 --data-raw "Backup failed: $1" "${HEALTHCHECKS_URL}/fail" > /dev/null || true
  exit 1
}

# Create backup
echo "Creating backup archive..." | tee -a "$LOG_FILE"
borg create \
  --verbose \
  --filter AME \
  --list \
  --stats \
  --compression "$COMPRESSION" \
  --exclude-caches \
  --exclude "*/node_modules" \
  --exclude "*/tmp/*" \
  --exclude "*/cache/*" \
  --exclude "*/DS_Store" \
  "::${ARCHIVE_NAME}" \
  "$SOURCE_DIR" 2>&1 | tee -a "$LOG_FILE" || backup_failed "Archive creation"

# Prune old backups according to retention policy
echo "Pruning old backups..." | tee -a "$LOG_FILE"
borg prune \
  --verbose \
  --list \
  --keep-weekly="$KEEP_WEEKLY" \
  --keep-monthly="$KEEP_MONTHLY" \
  --prefix "backup_" 2>&1 | tee -a "$LOG_FILE" || backup_failed "Pruning old backups"

# Check repository consistency
echo "Checking repository consistency..." | tee -a "$LOG_FILE"
borg check \
  --verbose 2>&1 | tee -a "$LOG_FILE" || backup_failed "Repository check"

# Display information about the repository
echo "Repository info:" | tee -a "$LOG_FILE"
borg info 2>&1 | tee -a "$LOG_FILE" || true

# Calculate and display repo size
echo "Repository size:" | tee -a "$LOG_FILE"
ssh "${REMOTE_USER}@${REMOTE_HOST}" "du -sh ${REMOTE_PATH}" 2>&1 | tee -a "$LOG_FILE" || true

# Completion message
FINISH_TIME=$(date)
echo "=== Backup completed successfully at ${FINISH_TIME} ===" | tee -a "$LOG_FILE"

# Signal successful completion to healthchecks.io
#curl -fsS -m 10 --retry 5 --data-raw "Backup completed at ${FINISH_TIME}" "${HEALTHCHECKS_URL}" > /dev/null || true

exit 0
