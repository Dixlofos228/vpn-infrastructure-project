#!/bin/bash
set -euo pipefail

echo "[VPN] Installing OpenVPN server"

apt update
apt install -y openvpn easy-rsa

mkdir -p /etc/openvpn/server
mkdir -p /var/log/openvpn

cp artifacts/config-examples/openvpn-server.conf /etc/openvpn/server/server.conf

systemctl enable openvpn@server
systemctl start openvpn@server

echo "[VPN] OpenVPN server installed and started"
