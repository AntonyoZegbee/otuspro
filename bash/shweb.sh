#!/bin/bash

# Настройки
LOCKFILE="/tmp/cron_script.lock"
LOGFILE="/var/log/apache2/access.log"
ERRORLOG="/var/log/apache2/error.log"
LASTRUNFILE="/tmp/last_run_time.txt"
RECIPIENT="anton.sbl991@yandex.ru"
SUBJECT="Web Server Log Report"
TMPFILE="/tmp/email_report.txt"

# Проверка наличия файла блокировки
if [ -e "$LOCKFILE" ]; then
    echo "Скрипт уже выполняется."
    exit 1
fi

# Создаем файл блокировки
touch "$LOCKFILE"

# Проверка существования лог-файлов
if [ ! -f "$LOGFILE" ]; then
    echo "Log file $LOGFILE does not exist." | mail -s "$SUBJECT - Error" "$RECIPIENT"
    rm -f "$LOCKFILE"
    exit 1
fi

if [ ! -f "$ERRORLOG" ]; then
    echo "Error log file $ERRORLOG does not exist." | mail -s "$SUBJECT - Error" "$RECIPIENT"
    rm -f "$LOCKFILE"
    exit 1
fi

# Определяем временной диапазон
if [ -e "$LASTRUNFILE" ]; then
    LASTRUN=$(cat "$LASTRUNFILE")
else
    LASTRUN=$(date --date="1 hour ago" +"%d/%b/%Y:%H:%M:%S")
fi
CURRENTRUN=$(date +"%d/%b/%Y:%H:%M:%S")

# Записываем текущее время как время последнего запуска
echo "$CURRENTRUN" > "$LASTRUNFILE"

# Заголовок письма
echo "Log report for the period $LASTRUN to $CURRENTRUN" > "$TMPFILE"
echo "" >> "$TMPFILE"

# Список IP адресов с наибольшим количеством запросов
echo "Top IP addresses by request count:" >> "$TMPFILE"
awk -v last_run="$LASTRUN" -v curr_run="$CURRENTRUN" \
'$4 >= "["last_run && $4 <= "["curr_run {print $1}' "$LOGFILE" | \
sort | uniq -c | sort -rn | head -10 >> "$TMPFILE"
echo "" >> "$TMPFILE"

# Список запрашиваемых URL с наибольшим количеством запросов
echo "Top requested URLs by request count:" >> "$TMPFILE"
awk -v last_run="$LASTRUN" -v curr_run="$CURRENTRUN" \
'$4 >= "["last_run && $4 <= "["curr_run {print $7}' "$LOGFILE" | \
sort | uniq -c | sort -rn | head -10 >> "$TMPFILE"
echo "" >> "$TMPFILE"

# Ошибки веб-сервера/приложения с момента последнего запуска
echo "Web server/application errors:" >> "$TMPFILE"
awk -v last_run="$LASTRUN" -v curr_run="$CURRENTRUN" \
'$4 >= "["last_run && $4 <= "["curr_run' "$ERRORLOG" >> "$TMPFILE"
echo "" >> "$TMPFILE"

# Список всех кодов HTTP ответа с указанием их количества
echo "HTTP response codes:" >> "$TMPFILE"
awk -v last_run="$LASTRUN" -v curr_run="$CURRENTRUN" \
'$4 >= "["last_run && $4 <= "["curr_run {print $9}' "$LOGFILE" | \
sort | uniq -c | sort -rn >> "$TMPFILE"
echo "" >> "$TMPFILE"

# Проверка на наличие данных в отчете
if [ ! -s "$TMPFILE" ]; then
    echo "No log entries found for the period $LASTRUN to $CURRENTRUN." > "$TMPFILE"
fi

# Отправка письма
mail -s "$SUBJECT" "$RECIPIENT" < "$TMPFILE"

# Удаляем временные файлы
rm -f "$TMPFILE"
rm -f "$LOCKFILE"
