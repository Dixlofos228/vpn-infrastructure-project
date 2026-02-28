#!/bin/bash

BACKUP_BUCKET="gs://vpn-backups-1772301317"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="vpn-backup-${DATE}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR

log "🚀 Начинаем бэкап VPN сервера..."

# 1. Бэкап конфигурации OpenVPN
log "📦 Копируем конфигурацию OpenVPN..."
sudo tar -czf openvpn-config.tar.gz /etc/openvpn/server/ 2>/dev/null || true

# 2. Бэкап логов и статуса
log "📦 Копируем логи и статус подключений..."
sudo tar -czf logs.tar.gz /var/log/openvpn* 2>/dev/null || true

# 3. Сохраняем список активных клиентов
if [ -f "/var/log/openvpn-status.log" ]; then
    cp /var/log/openvpn-status.log ./status-${DATE}.log
    echo "Active clients: $(grep -c "Common Name" /var/log/openvpn-status.log 2>/dev/null || echo "0")" > status.txt
fi

# 4. Метаданные
cat > backup-info.txt << INFO
Backup Date: $(date)
Hostname: $(hostname)
IP: $(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
OpenVPN Version: $(openvpn --version | head -n1)
INFO

# 5. Создаем архив
tar -czf "${BACKUP_NAME}.tar.gz" *.tar.gz *.txt *.log 2>/dev/null

# 6. Загружаем в Cloud Storage
log "☁️ Загружаем в Cloud Storage..."
gsutil cp "${BACKUP_NAME}.tar.gz" "${BACKUP_BUCKET}/vpn-server/"

if [ $? -eq 0 ]; then
    log "✅ Бэкап успешно загружен"
else
    log "❌ Ошибка загрузки"
fi

cd /
rm -rf $TEMP_DIR
log "✅ Бэкап завершен"
