#!/bin/bash
# Обновляем систему и устанавливаем NFS-клиент
apt-get update apt-get install -y nfs-common
# Добавляем запись в /etc/fstab для автоматического монтирования NFS-директории
echo "192.168.50.10:/srv/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0" >> /etc/fstab
# Применяем изменения и запускаем монтирование
systemctl daemon-reload systemctl restart remote-fs.target
# Создаем директорию для монтирования, если она не существует
mkdir -p /mnt/upload
# Монтируем директорию вручную для проверки
mount /mnt
