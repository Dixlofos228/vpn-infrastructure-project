#!/bin/bash
set -euo pipefail

echo "[Backup] Installing backup system"

apt update
apt install -y borgbackup

mkdir -p /backup/borg
mkdir -p /var/log

cp scripts/backup-system.sh /usr/local/bin/backup-system.sh
chmod +x /usr/local/bin/backup-system.sh

cp artifacts/systemd/backup-system.service /etc/systemd/system/
cp artifacts/systemd/backup-system.timer /etc/systemd/system/

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now backup-system.timer

echo "[Backup] Backup system installed"
