# Руководство администратора

## Серверы
- ca-server: 35.225.35.245 (us-central1-a)
- vpn-server: 136.111.191.184 (us-central1-b)
- monitoring-server: 34.9.86.244 (us-central1-b)

## Создание пользователя
gcloud compute ssh ca-server --zone=us-central1-a
sudo /usr/local/bin/create_client.sh username
gcloud compute scp ca-server:/etc/openvpn/clients/username/username.ovpn ./

## Мониторинг
- Prometheus: http://34.9.86.244:9090
- Grafana: http://34.9.86.244:3000 (admin/admin)

## Бэкапы
gs://vpn-backups-1772301317
