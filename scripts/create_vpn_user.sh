#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <client_name>"
    exit 1
fi

CLIENT_NAME="$1"

echo "[VPN] Creating VPN client: $CLIENT_NAME"

# ---- CA / easy-rsa configuration ----
CA_DIR="/opt/ca"
export EASYRSA_BATCH=1
export EASYRSA_PKI="$CA_DIR/pki"
export EASYRSA="/usr/share/easy-rsa"

cd "$CA_DIR"

# ---- generate client cert + key ----
easyrsa build-client-full "$CLIENT_NAME" nopass

# ---- install client files ----
CLIENT_DIR="/etc/openvpn/clients/$CLIENT_NAME"
mkdir -p "$CLIENT_DIR"

cp "$EASYRSA_PKI/issued/$CLIENT_NAME.crt" "$CLIENT_DIR/"
cp "$EASYRSA_PKI/private/$CLIENT_NAME.key" "$CLIENT_DIR/"
cp "$EASYRSA_PKI/ca.crt" "$CLIENT_DIR/"

chmod 600 "$CLIENT_DIR/$CLIENT_NAME.key"

echo "[VPN] Client $CLIENT_NAME created successfully"
echo "[VPN] Files:"
echo "  $CLIENT_DIR/$CLIENT_NAME.crt"
echo "  $CLIENT_DIR/$CLIENT_NAME.key"
echo "  $CLIENT_DIR/ca.crt"

