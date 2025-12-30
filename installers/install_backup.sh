#!/bin/bash
set -euo pipefail

echo "[BACKUP] Installing backup system"

apt update
apt install -y borgbackup

mkdir -p /backup/borg

echo "[BACKUP] Backup system ready"

