1.Создайте файл /etc/systemd/system/nginx@.service

[Unit]
Description=Nginx Web Server Instance %i
After=network.target

[Service]
Type=forking
ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx-%i.conf
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx-%i.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PIDFile=/run/nginx-%i.pid

[Install]
WantedBy=multi-user.target

2.Для каждого инстанса создайте отдельные конфигурационные файлы в /etc/nginx/ с именами nginx-instance_name.conf
/etc/nginx/nginx-instance1.conf
/etc/nginx/nginx-instance2.conf

worker_processes  1;

events {
    worker_connections  1024;
}

http {
    server {
        listen 8081;  # Укажите уникальный порт для каждого инстанса
        server_name localhost;

        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
        }
    }
}


sudo systemctl start nginx@instance1
sudo systemctl start nginx@instance2

sudo systemctl status nginx@instance1
sudo systemctl status nginx@instance2

sudo systemctl restart nginx@instance1
sudo systemctl stop nginx@instance2

sudo systemctl enable nginx@instance1
sudo systemctl enable nginx@instance2
