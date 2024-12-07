Описание
Целью данной конфигурации было развернуть виртуальную сеть с маршрутизаторами и серверами, обеспечив взаимодействие между офисами Office1 и Office2, а также их доступ в интернет.

Сеть включает: 
- inetRouter: подключение к интернету и NAT для внутренней сети. 
- centralRouter: маршрутизатор центрального офиса, соединяющий 
- Office1, Office2 и интернет. office1Router, office2Router: маршрутизаторы офисов, обеспечивающие связь серверов с центральным 
маршрутизатором.
- centralServer, office1Server, office2Server: серверы, подключенные к своим маршрутизаторам.


vagrant up

Включили IP forwarding на всех маршрутизаторах:
sysctl -w net.ipv4.ip_forward=1

Настроили маршруты на centralRouter для соединения офисов: 
sudo ip route add 192.168.1.0/25 via 192.168.1.1
sudo ip route add 192.168.2.0/26 via 192.168.2.1

Настроили маршруты на office1Router и office2Router для связи с центральным маршрутизатором:

На office1Router
sudo ip route add 192.168.1.0/25 via 192.168.2.1
На office2Router
sudo ip route add 192.168.2.0/26 via 192.168.1.1

Настройка NAT inetRouter:
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

Убрали конфликтующие маршруты через NAT на серверах office1Server и office2Server

На office1Server 
sudo ip route del default via 10.0.2.2 
sudo ip route add default via 192.168.2.1 
На office2Server 
sudo ip route del default via 10.0.2.2
sudo ip route add default via 192.168.1.1





[vagrant@office1Server ~]$ ping 192.168.1.3
PING 192.168.1.3 (192.168.1.3) 56(84) bytes of data.
64 bytes from 192.168.1.3: icmp_seq=1 ttl=63 time=2.38 ms
64 bytes from 192.168.1.3: icmp_seq=2 ttl=63 time=1.51 ms
64 bytes from 192.168.1.3: icmp_seq=3 ttl=63 time=1.55 ms
64 bytes from 192.168.1.3: icmp_seq=4 ttl=63 time=1.41 ms
^C
--- 192.168.1.3 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3008ms
rtt min/avg/max/mdev = 1.413/1.716/2.384/0.390 ms


[vagrant@office2Server ~]$ ping 192.168.2.3
PING 192.168.2.3 (192.168.2.3) 56(84) bytes of data.
64 bytes from 192.168.2.3: icmp_seq=1 ttl=63 time=1.88 ms
64 bytes from 192.168.2.3: icmp_seq=2 ttl=63 time=1.73 ms
64 bytes from 192.168.2.3: icmp_seq=3 ttl=63 time=1.36 ms
64 bytes from 192.168.2.3: icmp_seq=4 ttl=63 time=1.74 ms
^C
--- 192.168.2.3 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3012ms
rtt min/avg/max/mdev = 1.360/1.679/1.885/0.200 ms
