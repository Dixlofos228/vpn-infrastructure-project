#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="/etc/ca-setup"
EASYRSA_DIR="$INSTALL_DIR/easyrsa"
PKI_DIR="$EASYRSA_DIR/pki"
BACKUP_DIR="/var/backups/ca-backups"
CA_CERT="$PKI_DIR/ca.crt"
CA_KEY="$PKI_DIR/private/ca.key"

log() { echo "[INFO] $*"; }

log "Создаю директории"
sudo mkdir -p "$INSTALL_DIR"
sudo mkdir -p "$EASYRSA_DIR"
sudo mkdir -p "$BACKUP_DIR"

log "Копирую EasyRSA"
sudo cp -r /etc/easy-rsa/* "$EASYRSA_DIR/" || true

cd "$EASYRSA_DIR"

if [ ! -f "$CA_CERT" ]; then
    log "PKI не найдена, создаю..."
    easyrsa init-pki

    log "Создаю корневой сертификат CA"
    EASYRSA_BATCH=1 easyrsa build-ca nopass

    log "Создаю резервную копию PKI"
    sudo tar czf "$BACKUP_DIR/backup-$(date +%F_%H-%M-%S).tar.gz" -C "$PKI_DIR" .
else
    log "CA уже существует, пропускаю создание."
fi

log "Готово, Корневой CA: $CA_CERT"

