#!/usr/bin/env bash
set -euo pipefail

# ===== CONFIG =====
export BORG_REPO="/backup/borg"
export BORG_PASSPHRASE="9000"

LOGFILE="/var/log/backup.log"
TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
BACKUP_NAME="system-${TIMESTAMP}"

# ===== LOGGING =====
exec >> "$LOGFILE" 2>&1
echo "===== BACKUP START ${TIMESTAMP} ====="

# ===== BACKUP =====
borg create \
  --stats \
  --compression lz4 \
  "$BORG_REPO::$BACKUP_NAME" \
  /etc \
  /usr/local/bin \
  /var/lib \
  /root

# ===== PRUNE =====
borg prune \
  --keep-daily=7 \
  --keep-weekly=4 \
  --keep-monthly=6

echo "BACKUP OK ${TIMESTAMP}"
echo "===== BACKUP END ====="

