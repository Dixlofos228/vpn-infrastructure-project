# Система резервного копирования VPN инфраструктуры

## Компоненты системы

### 1. Cloud Storage бакет
- **Имя**: `gs://vpn-backups-1772301317`
- **Регион**: us-central1
- **Хранение**: 30 дней (политика жизненного цикла)
- **Версионирование**: Включено

### 2. Автоматические снапшоты дисков
- **CA сервер**: ежедневно в 02:00 UTC
- **VPN сервер**: ежедневно в 02:30 UTC
- **Monitoring сервер**: ежедневно в 03:00 UTC

### 3. Скрипты бэкапа конфигураций
- **CA сервер**: `/usr/local/bin/backup_ca.sh`
  - Бэкапит: CA сертификаты, ключи, клиентские сертификаты
  - Расписание: 0 2 * * * (ежедневно в 02:00 UTC)
  
- **VPN сервер**: `/usr/local/bin/backup_vpn.sh`
  - Бэкапит: конфигурацию OpenVPN, логи, статус подключений
  - Расписание: 30 2 * * * (ежедневно в 02:30 UTC)

### 4. Сервисный аккаунт
- **Имя**: `backup-sa@online-boutique-final.iam.gserviceaccount.com`
- **Права**: objectAdmin на бакет
- **Ключ**: сохранен в `/root/.config/gcloud/application_default_credentials.json` на серверах

## Существующие бэкапы (на $(date))

### VPN сервер:
gs://vpn-backups-1772301317/vpn-server/vpn-backup-20260228_180804.tar.gz
gs://vpn-backups-1772301317/vpn-server/vpn-backup-20260228_181102.tar.gz

### CA сервер:
gs://vpn-backups-1772301317/ca-server/ca-backup-20260228_185331.tar.gz


## Процедура восстановления

### Восстановление из снапшота диска
```bash
# Найти последний снапшот
gcloud compute snapshots list --filter="name~'ca-server'"

# Создать диск из снапшота
gcloud compute disks create ca-server-restored \
    --source-snapshot=SNAPSHOT_NAME \
    --zone=us-central1-a

### Восстановление конфигураций из бэкапа
```bash
# Скачать бэкап
gsutil cp gs://vpn-backups-1772301317/ca-server/ca-backup-20260228_185331.tar.gz ./

# Распаковать
tar -xzf ca-backup-20260228_185331.tar.gz

# Восстановить файлы
sudo tar -xzf ca-backup.tar.gz -C /
