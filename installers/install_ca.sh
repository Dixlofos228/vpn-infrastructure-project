#!/bin/bash
set -euo pipefail

echo "[CA] Installing Certificate Authority"

# ---- install dependencies ----
if command -v apt >/dev/null 2>&1; then
    echo "[CA] Detected apt-based system"
    apt update
    apt install -y easy-rsa openssl

elif command -v pacman >/dev/null 2>&1; then
    echo "[CA] Detected Arch Linux"
    pacman -Sy --noconfirm easy-rsa openssl

else
    echo "[CA] Unsupported Linux distribution"
    exit 1
fi

# ---- CA setup ----
CA_DIR=/opt/ca
export EASYRSA_BATCH=1
export EASYRSA_PKI="$CA_DIR/pki"

# Arch / universal path
export EASYRSA="/usr/share/easy-rsa"

mkdir -p "$CA_DIR"
cd "$CA_DIR"

# init & build CA
easyrsa init-pki
easyrsa build-ca nopass

# ---- install CA cert ----
mkdir -p /etc/ca
cp "$EASYRSA_PKI/ca.crt" /etc/ca/

echo "[CA] CA initialized successfully"

