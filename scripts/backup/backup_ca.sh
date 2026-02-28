#!/bin/bash

# Загружаем имя бакета
BACKUP_BUCKET="gs://vpn-backups-1772301317"
DATE=$(date +%Y%m%d_%H%M%S)
HOSTNAME=$(hostname)
BACKUP_NAME="ca-backup-${DATE}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR

log "🚀 Начинаем бэкап CA сервера..."

# 1. Бэкап CA (критично!)
log "📦 Копируем CA сертификаты и ключи..."
sudo tar -czf ca-backup.tar.gz /etc/openvpn/ca /etc/openvpn/easy-rsa/pki 2>/dev/null || true

# 2. Бэкап клиентских сертификатов
log "📦 Копируем клиентские сертификаты..."
sudo tar -czf clients-backup.tar.gz /etc/openvpn/clients 2>/dev/null || true

# 3. Метаданные
cat > backup-info.txt << INFO
Backup Date: $(date)
Hostname: $(hostname)
IP: $(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
CA Fingerprint: $(openssl x509 -in /etc/openvpn/ca/ca.crt -noout -fingerprint -sha256 2>/dev/null | cut -d'=' -f2)
INFO

# 4. Создаем единый архив
tar -czf "${BACKUP_NAME}.tar.gz" *.tar.gz backup-info.txt 2>/dev/null

# 5. Загружаем в Cloud Storage
log "☁️ Загружаем в Cloud Storage..."
gsutil cp "${BACKUP_NAME}.tar.gz" "${BACKUP_BUCKET}/ca-server/"

if [ $? -eq 0 ]; then
    log "✅ Бэкап успешно загружен: ${BACKUP_BUCKET}/ca-server/${BACKUP_NAME}.tar.gz"
else
    log "❌ Ошибка загрузки бэкапа"
fi

cd /
rm -rf $TEMP_DIR
log "✅ Бэкап завершен"
