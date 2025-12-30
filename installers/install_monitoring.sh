#!/bin/bash
set -euo pipefail

echo "[MONITORING] Installing Prometheus and Grafana"

apt update
apt install -y prometheus grafana

systemctl enable prometheus grafana-server
systemctl start prometheus grafana-server

echo "[MONITORING] Monitoring installed"

