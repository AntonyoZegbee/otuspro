#!/bin/bash
# Заголовок
echo "PID    STAT    COMMAND"

# Перебираем все директории в /proc, которые являются числами (PID процессов)
for pid in $(ls /proc | grep -E '^[0-9]+$'); do
    # Проверяем, что файл /proc/[pid]/stat существует
    if [ -f /proc/$pid/stat ]; then
        # Получаем данные из /proc/[pid]/stat
        stat=$(cat /proc/$pid/stat)
        
        # Извлекаем PID, статус и команду
        pid=$(echo "$stat" | awk '{print $1}')
        state=$(echo "$stat" | awk '{print $3}')
        command=$(echo "$stat" | awk '{print $2}' | tr -d '()')

        # Выводим результат
        printf "%-7s %-7s %s\n" "$pid" "$state" "$command"
    fi
done

