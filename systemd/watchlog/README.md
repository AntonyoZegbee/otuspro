1.Создайте файл /etc/default/log_monitor

LOG_FILE="/var/log/my_log.log"
KEYWORD="ERROR"

2.Создайте файл /usr/local/bin/log_monitor.sh

#!/bin/bash

# Загружаем переменные из конфигурационного файла
source /etc/default/log_monitor

# Проверяем наличие ключевого слова в лог-файле
if grep -q "$KEYWORD" "$LOG_FILE"; then
    echo "Keyword '$KEYWORD' found in $LOG_FILE"
else
    echo "Keyword '$KEYWORD' not found in $LOG_FILE"
fi

Дайте права 
sudo chmod +x /usr/local/bin/log_monitor.sh

3.Создайте файл /etc/systemd/system/log-monitor.service

[Unit]
Description=Log Monitor Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/log_monitor.sh

[Install]
WantedBy=multi-user.target

4.Создайте файл /etc/systemd/system/log-monitor.timer

[Unit]
Description=Run Log Monitor every 30 seconds

[Timer]
OnBootSec=30
OnUnitActiveSec=30
Unit=log-monitor.service

[Install]
WantedBy=timers.target

5.
sudo systemctl daemon-reload
sudo systemctl enable log-monitor.timer
sudo systemctl start log-monitor.timer

6.Проверка

sudo systemctl status log-monitor.timer
sudo systemctl status log-monitor.service


