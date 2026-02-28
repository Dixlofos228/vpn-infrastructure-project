# Руководство пользователя VPN

## Параметры подключения
- Сервер: 136.111.191.184
- Порт: 1194 (UDP)
- Протокол: OpenVPN

## Установка
**Windows**: https://openvpn.net/community-downloads/
**macOS**: brew install tunnelblick или https://tunnelblick.net/
**Linux**: sudo apt install openvpn (Ubuntu) / sudo pacman -S openvpn (Arch)

## Подключение
sudo openvpn --config client.ovpn

## Проверка
curl ifconfig.me (должен показать 136.111.191.184)
