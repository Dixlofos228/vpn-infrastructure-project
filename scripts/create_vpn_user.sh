#!/usr/bin/env bash
set -euo pipefail

USER_NAME="$1"

if [[ -z "$USER_NAME" ]]; then
  echo "Usage: $0 <username>"
  exit 1
fi

export EASYRSA_BATCH=1

cd /etc/openvpn/easy-rsa

./easyrsa gen-req "$USER_NAME" nopass
./easyrsa sign-req client "$USER_NAME"

echo "User $USER_NAME created"

