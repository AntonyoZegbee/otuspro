vagrant up

На каждом маршрутизаторе router1, router2, router3
sudo vtysh

Ассиметричный роутинг

Трафик от router1 до router3 будет идти через router2, а обратный трафик — напрямую
Интерфейс enp0s8 (к router2) будет иметь более низкую стоимость (10), чем enp0s9 (к router3) с стоимостью 50.
Поэтому трафик из router1 в router3 будет идти через router2


На router1

Интерфейс enp0s8 (к router2) будет иметь более низкую стоимость (10), чем enp0s9 (к router1) с стоимостью 50.
Обратный трафик из router3 в router1 будет идти через router2
/
configure terminal

interface enp0s8
 description r1-r2
 ip ospf cost 10

interface enp0s9
 description r1-r3
 ip ospf cost 50

exit
write memory
/
На router3
/configure terminal

interface enp0s8
 description r3-r2
 ip ospf cost 10

interface enp0s9
 description r3-r1
 ip ospf cost 50

exit
write memory
/




На router1
traceroute 192.168.30.1

На router3
traceroute 192.168.10.1







Симметричный роутинг с дорогим линком


На router1
/
configure terminal

interface enp0s8
 description r1-r2
 ip ospf cost 10

interface enp0s9
 description r1-r3
 ip ospf cost 100

exit
write memory
/


На router3
/
configure terminal

interface enp0s8
 description r3-r2
 ip ospf cost 10

interface enp0s9
 description r3-r1
 ip ospf cost 100

exit
write memory
/


На router2
/
configure terminal

interface enp0s8
 description r2-r1
 ip ospf cost 10

interface enp0s9
 description r2-r3
 ip ospf cost 10

exit
write memory
/


Основной маршрут будет через router2 для обоих направлений, так как стоимость между router1 и router3 
напрямую (через enp0s9) теперь выше (100)

Проверка
router1
traceroute 192.168.30.1

router3
traceroute 192.168.10.1


Проверка маршрутов OSPF
show ip route ospf


