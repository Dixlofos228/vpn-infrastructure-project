#!/bin/bash
set -euo pipefail

echo "[Monitoring] Installing Prometheus Node Exporter"

# ---- install package depending on distro ----
if command -v apt >/dev/null 2>&1; then
    echo "[Monitoring] Detected apt-based system"
    apt update
    apt install -y prometheus-node-exporter
    SERVICE_NAME=prometheus-node-exporter

elif command -v pacman >/dev/null 2>&1; then
    echo "[Monitoring] Detected Arch Linux"
    pacman -Sy --noconfirm prometheus-node-exporter
    SERVICE_NAME=prometheus-node-exporter.service

else
    echo "[Monitoring] Unsupported Linux distribution"
    exit 1
fi

# ---- enable & start service ----
systemctl enable "$SERVICE_NAME"
systemctl restart "$SERVICE_NAME"

echo "[Monitoring] Node exporter is running"

