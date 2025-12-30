#!/bin/bash
set -euo pipefail

echo "[CA] Installing Certificate Authority"

apt update
apt install -y easy-rsa

CA_DIR=/opt/ca
EASYRSA_BATCH=1

mkdir -p "$CA_DIR"
cd "$CA_DIR"

easyrsa init-pki
easyrsa build-ca nopass

mkdir -p /etc/ca
cp pki/ca.crt /etc/ca/

echo "[CA] CA initialized successfully"
