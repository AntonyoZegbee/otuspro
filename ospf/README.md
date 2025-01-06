
Команда для запуска

vagrant up


Настройка /etc/frr/daemons на каждой машине
zebra=yes
ospfd=yes
bgpd=no

Проверка прав
sudo chown frr:frr /etc/frr/daemons
sudo chmod 640 /etc/frr/daemons

Перезапуск службы FRR:
sudo systemctl restart frr
sudo systemctl enable frr

sudo systemctl status frr
sudo systemctl status ospfd

Проверка соседей OSPF
show ip ospf neighbor
show ip route ospf
show ip ospf interface

Проверка доступности
ping 192.168.30.1
ping 192.168.40.1

Трассировка маршрутов:
traceroute 192.168.30.1
traceroute 192.168.40.1



Отключаем блокировку асимметричной маршрутизации

sudo sysctl -w net.ipv4.conf.all.rp_filter=0
sudo sysctl -p


