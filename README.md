# VPN Infrastructure Project

Инфраструктура: OpenVPN + Prometheus/Grafana + GCS бэкапы.

Документация: /docs
Артефакты: /artifacts
Скрипты: /scripts

Команды:
- gcloud compute ssh ca-server --zone=us-central1-a
- gcloud compute ssh vpn-server --zone=us-central1-b
- gcloud compute ssh monitoring-server --zone=us-central1-b
