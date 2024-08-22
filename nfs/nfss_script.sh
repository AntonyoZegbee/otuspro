#!/bin/bash
# Обновляем систему и устанавливаем NFS-сервер
apt-get update apt-get install -y nfs-kernel-server
# Создаем директорию для экспорта и устанавливаем необходимые права
mkdir -p /srv/share/upload chown -R nobody:nogroup /srv/share chmod 0777 /srv/share/upload
# Настраиваем экспорт директории
echo "/srv/share 192.168.50.11/32(rw,sync,root_squash)" > /etc/exports
# Применяем изменения экспорта
exportfs -r
# Перезапускаем NFS-сервис
systemctl restart nfs-kernel-server
