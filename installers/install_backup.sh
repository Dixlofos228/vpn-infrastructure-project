#!/bin/bash
set -euo pipefail

echo "[Backup] Installing backup system"

# ---- install borgbackup depending on distro ----
if command -v apt >/dev/null 2>&1; then
    echo "[Backup] Detected apt-based system"
    apt update
    apt install -y borgbackup

elif command -v pacman >/dev/null 2>&1; then
    echo "[Backup] Detected Arch Linux"
    pacman -Sy --noconfirm borg

else
    echo "[Backup] Unsupported Linux distribution"
    exit 1
fi

# ---- directories ----
mkdir -p /backup/borg
mkdir -p /var/log

# ---- install backup script ----
install -m 755 scripts/backup-system.sh /usr/local/bin/backup-system.sh

# ---- install systemd units ----
install -m 644 artifacts/systemd/backup-system.service /etc/systemd/system/backup-system.service
install -m 644 artifacts/systemd/backup-system.timer /etc/systemd/system/backup-system.timer

# ---- systemd reload & enable ----
systemctl daemon-reload
systemctl enable --now backup-system.timer

echo "[Backup] Backup system installed successfully"

