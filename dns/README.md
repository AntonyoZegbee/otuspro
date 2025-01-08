vagrant up

запустить машины, почему то не стартуют сами

vagrant up ns01
vagrant up ns02
vagrant up client1
vagrant up client2

client1
dig @192.168.50.10 web1.dns.lab
dig @192.168.50.10 www.newdns.lab


client2
dig @192.168.50.11 web1.dns.lab
dig @192.168.50.11 web2.dns.lab

ping -c 4 192.168.50.10
ping -c 4 192.168.50.11
