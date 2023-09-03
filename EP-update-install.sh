#!/bin/bash

# Utworzenie i zamontowanie pliku wymiany
sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Konfiguracja parametrów systemowych i aktualizacja
echo -e 'vm.swappiness=10\nvm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

# Aktualizacja serwerów DNS
echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1" | sudo tee /etc/resolv.conf

# Dodanie informacji o stanie systemu do pliku .bashrc
echo -e '\ncpu_usage=$(top -bn1 | grep load | awk "{print \$3}")\nram_usage=$(free | awk "/Mem:/ { print \$3/\$2 * 100.0 }")\ndisk_usage=$(df -h / | awk "/\// {print \$(NF-1)})\nexternal_ip=$(curl -s https://checkip.amazonaws.com)\ninternal_ip=$(hostname -I | awk "{print \$1}")\n\n===== System Status =====\nCPU Usage: \$cpu_usage%\nRAM Usage: \$ram_usage%\nDisk Usage: \$disk_usage\nExternal IP: \$external_ip\nInternal IP: \$internal_ip\n=========================\n' >> ~/.bashrc

# Aktualizacja i czyszczenie systemu
sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean && sudo systemctl restart systemd-journald

# Instalacja EasyPanel
curl -sSL https://get.easypanel.io | sh

# Restart serwera
sudo reboot
