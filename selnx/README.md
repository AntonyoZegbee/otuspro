В ходе выполнения задания мы развернули и построили веб-сервер Nginx на машине с CentOS 7, используя нестандартный порт 4881. 
Также мы построили SELinux, чтобы разрешить работу Nginx на этом порту, используя три разных канала. Ниже приведено подробное описание выполненных
1. Установка Nginx и нестандартная настройка
1.1. Установка EPEL и Nginx :
Для установки Nginx, доступной в репозитории EPEL, мы сначала установили репозитории:
sudo yum install -y epel-release
Затем установил Nginx:
sudo yum install -y nginx
1.2. Настройка нестандартного порта для Nginx :
Открыли файл конфигурации /etc/nginx/nginx.confдля редактирования
В файле заменены символы listen 80;:
nginx
listen 4881;
После этого перезапустили Nginx:
sudo systemctl restart nginx
Проверили, что Nginx слушает порт 4881:
sudo ss -tlpn | grep 4881
2.1. Способ 1: Использование переключателяsetsebool :
Проверили текущий статус SELinux, чтобы убедиться, что он находится в режимеEnforcing:
getenforce
Для разрешения Nginx подключиться к сети мы используем команду:
sudo systemctl restart nginx
2.2. Способ 2: Добавление нестандартного порта типаhttp_port_t :
SELinux использует контексты безопасности для управления доступом к портам. Мы проверили, какие порты уже разрешены для HTTP-трафика:
sudo semanage port -l | grep http
Добавили порт 4881 в разрешенные порты для HTTP:
sudo semanage port -a -t http_port_t -p tcp 4881
Если порт уже существует, используйте модификацию порта:
sudo semanage port -m -t http_port_t -p tcp 4881
sudo systemctl restart nginx
sudo systemctl status nginx
2.3. Способ 3: Создание и установка модуля SELinux :
Если детали не решают проблему, воспользуйтесь инструментомaudit2allowдля
Запустили команду для анализа журналов SELinux и создания модуля:
sudo grep nginx /var/log/audit/audit.log | audit2allow -M nginx_custom
Установили сгенерированный модуль:
sudo semodule -i nginx_custom.pp
После этого перезапустили Nginx:
sudo systemctl restart nginx
3
3.1. Проверка черезcurl :
Чтобы убедиться, что Nginx корректно работает на порту 4881, выполните команду:
curl http://localhost:4881
3.2. Проверка через браузер :
по адресу http://192.168.1.160:4881
