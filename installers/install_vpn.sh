#!/bin/bash
set -euo pipefail

echo "[VPN] Installing VPN server"

apt update
apt install -y openvpn easy-rsa

systemctl enable openvpn
systemctl start openvpn

echo "[VPN] VPN server installed"

