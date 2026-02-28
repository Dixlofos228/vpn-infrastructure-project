# Инфраструктура

Сеть: vpn-network (10.0.0.0/24)
Firewall: SSH (с 186.54.249.236), OpenVPN (udp:1194), внутренний трафик

Серверы:
- ca-server (10.0.0.2) - CA сертификаты
- vpn-server (10.0.0.3) - OpenVPN + NAT
- monitoring-server (10.0.0.4) - Prometheus + Grafana

Бэкапы: gs://vpn-backups-1772301317 (30 дней, версионирование)
