vagrant up

Проверяем работу на сервере 

vagrant up server_tap
vagrant up client_tap

sudo systemctl restart openvpn@server_tap
sudo systemctl status openvpn@server_tap

sudo systemctl restart openvpn@client_tap
sudo systemctl status openvpn@client_tap

ip a | grep tap
ping 10.10.10.1

iperf3 -s &

iperf3 -c 10.10.10.1 -t 40 -i 5




vagrant up server_tun
vagrant up client_tun

sudo systemctl restart openvpn@server-tun
sudo systemctl status openvpn@server-tun

sudo systemctl restart openvpn@client-tun
sudo systemctl status openvpn@client-tun

ip a | grep tun

ping 10.10.20.1

ping 10.10.20.2

iperf3 -s

iperf3 -c 10.10.20.1 -t 40 -i 5

