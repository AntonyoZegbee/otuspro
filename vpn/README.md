vagrant up

Проверяем работу на сервере 
vagrant ssh server
sudo systemctl status openvpn@server
sudo journalctl -xeu openvpn@server

Проверяем работу на клиенте
vagrant ssh client
sudo systemctl status openvpn@client
sudo journalctl -xeu openvpn@client



На клиенте  проверка тунеля

ping 10.10.10.1

Проверка скорости через iperf3

vagrant ssh server
sudo iperf3 -s

vagrant ssh client
sudo iperf3 -c 10.10.10.1 -t 40 -i 5

Проверка сетевого интерфейса VPN
ip a | grep tap

