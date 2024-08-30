1. 
sudo apt update
sudo apt install spawn-fcgi

2.
Создайте файл /etc/systemd/system/spawn-fcgi.service

[Unit]
Description=PHP FastCGI Process Manager
After=network.target

[Service]
Type=simple
User=nginx
Group=nginx
EnvironmentFile=/etc/sysconfig/phpfastcgi
ExecStart=/usr/bin/spawn-fcgi -a ${SERVER_IP} -p ${SERVER_PORT} -u ${SERVER_USER} -g ${SERVER_GROUP} -P ${PIDFILE} -C ${SERVER_CHILDS} -f ${PHP_CGI}
PIDFile=/var/run/php_cgi.pid
Restart=on-failure

[Install]
WantedBy=multi-user.target

3.
Создайте файл конфигурации /etc/sysconfig/phpfastcgi
# /etc/sysconfig/phpfastcgi

PHP_CGI="/usr/bin/php-cgi"
SPAWNFCGI="/usr/bin/spawn-fcgi"
SERVER_IP="127.0.0.1"
SERVER_PORT="9000"
SERVER_USER="nginx"
SERVER_GROUP="nginx"
SERVER_CHILDS="5"
PIDFILE="/var/run/php_cgi.pid"

4.
sudo systemctl daemon-reload
sudo systemctl enable spawn-fcgi.service

5.
sudo systemctl start spawn-fcgi.service
sudo systemctl status spawn-fcgi.service

