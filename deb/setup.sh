#!/bin/bash

# Обновление системы и установка необходимых пакетов
sudo apt-get update
sudo apt-get install -y wget dpkg-dev build-essential devscripts debhelper dh-make cmake gcc git nano nginx

# Сборка пакета Nginx с модулем ngx_brotli
mkdir -p ~/debbuild && cd ~/debbuild
apt-get source nginx
sudo apt-get build-dep -y nginx

# Клонирование репозитория ngx_brotli
git clone --recurse-submodules https://github.com/google/ngx_brotli.git

# Внесение изменений в debian/rules
cd nginx-*
sed -i '/\.\/configure/i \    --add-module=/home/vagrant/debbuild/ngx_brotli \\' debian/rules

# Сборка пакета
debuild -us -uc -b

# Создание и настройка локального репозитория
sudo mkdir -p /usr/share/nginx/html/repo
sudo cp ../*.deb /usr/share/nginx/html/repo/
cd /usr/share/nginx/html/repo
sudo dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

# Настройка Nginx для отображения содержимого репозитория
sudo sed -i '/server {/a \    autoindex on;' /etc/nginx/sites-available/default
sudo systemctl restart nginx

# Добавление репозитория на локальной машине
echo "deb [trusted=yes] http://localhost/repo ./" | sudo tee /etc/apt/sources.list.d/otus.list
sudo apt-get update

# Установка пакета Nginx из репозитория
sudo apt-get install -y nginx
