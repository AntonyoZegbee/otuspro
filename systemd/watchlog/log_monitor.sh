#!/bin/bash

# Загружаем переменные из конфигурационного файла
source /etc/default/log_monitor

# Проверяем наличие ключевого слова в лог-файле
if grep -q "$KEYWORD" "$LOG_FILE"; then
    echo "Keyword '$KEYWORD' found in $LOG_FILE"
else
    echo "Keyword '$KEYWORD' not found in $LOG_FILE"
fi
