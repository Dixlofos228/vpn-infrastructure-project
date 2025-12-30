#!/bin/bash
set -euo pipefail

echo "[Monitoring] Installing Prometheus node exporter"

apt update
apt install -y prometheus-node-exporter

systemctl enable prometheus-node-exporter
systemctl start prometheus-node-exporter

echo "[Monitoring] Node exporter started"
