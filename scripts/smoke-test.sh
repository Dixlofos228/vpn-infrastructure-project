#!/usr/bin/env bash
set -e

echo "Checking server availability..."
ping -c 1 8.8.8.8

echo "Checking CA certificate..."
test -f /etc/openvpn/ca.crt

echo "Checking OpenVPN service..."
systemctl is-active openvpn

echo "Smoke test OK"

