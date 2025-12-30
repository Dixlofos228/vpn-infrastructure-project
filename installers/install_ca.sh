#!/bin/bash
set -euo pipefail

echo "[CA] Installing CA server"

apt update
apt install -y easy-rsa

mkdir -p /opt/ca
cd /opt/ca

export EASYRSA_BATCH=1
easyrsa init-pki
easyrsa build-ca nopass

echo "[CA] CA server installed successfully"

