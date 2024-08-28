 Переименования Volume Group (VG) в Ubuntu 22.04 с использованием LVM

vgs
vgrename ubuntu-vg ubuntu-otus

Volume group "ubuntu-vg" successfully renamed to "ubuntu-otus"   - подтверждение успешного переименования

Обновите конфигурацию GRUB
nano /boot/grub/grub.cfg
заменить все ubuntu-vg на ubuntu--otus

grep -r 'ubuntu--vg' /etc/    - Проверьте все файлы
sudo nano /etc/crypttab
sudo nano /etc/initramfs-tools/conf.d/resume   - Проверьте ссылки на старое имя VG

update-grub

sudo update-initramfs -u

reboot

vgs
