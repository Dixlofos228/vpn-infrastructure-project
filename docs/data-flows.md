# Потоки данных

- Клиент → VPN-сервер: UDP 1194
- VPN-сервер → CA: подпись сертификатов
- Promtail → Loki: TCP 3100
- Prometheus → exporters: TCP 9100
- Grafana → Prometheus/Loki: TCP 3000
- Backup-host → VM: SSH (22)
