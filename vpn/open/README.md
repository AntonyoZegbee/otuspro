vagrant up

vagrant ssh server
sudo systemctl status openvpn@server

vagrant ssh client
sudo systemctl status openvpn@client
ping -c 4 10.10.10.1

iperf3 -c 10.10.10.1 -t 40 -i 5


