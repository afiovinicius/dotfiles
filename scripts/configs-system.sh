#!/bin/sh

#~~|¨Head Script¨|~~#
source "./scripts/utils.sh"

#~~|¨Config Swap¨|~~#
pf "Configurando SWAP." "warn"
sudo sysctl -w vm.swappiness=10
sudo sysctl -a | grep -i swappiness

#~~|¨Config Pacman¨|~~#
pf "Iniciando configuração do pacman." "warn"
configure_pacman() {
  pf "Remover os comentários das linhas relevantes." "warn"
  sudo sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' "/etc/pacman.conf"
  sudo sed -i '/^ParallelDownloads = 10/a\ILoveCandy' "/etc/pacman.conf"
  pf "Salvar e atualizar a lista de mirrors." "warn"
  sudo pacman -Sy
  pf "Configuração do Pacman concluída!" "success"
}
configure_pacman

#~~|¨Config Systemctl¨|~~#
pf "Habilitando Bluetooth." "warn"
sudo systemctl enable bluetooth.service
pf "Habilitando e iniciando Reflector." "warn"
sudo systemctl enable reflector.service
sudo systemctl start reflector.service

#~~|¨Config Reflector¨|~~#
pf "Iniciando configuração do Reflector." "warn"
configure_reflector() {
  pf "Atualizando o mirror Brazil com Reflector..." "warn"
  sudo reflector --verbose --country BR --age 24 --p http --p https --sort rate --save /etc/pacman.d/mirrorlist
  sleep 0.5
  pf "Criando automação com Hook..." "warn"
  if [ ! -d "/etc/pacman.d/hooks" ]; then
    sudo mkdir /etc/pacman.d/hooks
    cd /etc/pacman.d/hooks
    sleep 0.5
    echo "[Trigger]" | sudo tee -a mirrorupgrade.hook
    echo "Operation = Upgrade" | sudo tee -a mirrorupgrade.hook
    echo "Type = Package" | sudo tee -a mirrorupgrade.hook
    echo "Target = pacman-mirrorlist" | sudo tee -a mirrorupgrade.hook
    echo "[Action]" | sudo tee -a mirrorupgrade.hook
    echo "Description = Updating pacman-mirrorlist with reflector and removing pacnew..." | sudo tee -a mirrorupgrade.hook
    echo "When = PostTransaction" | sudo tee -a mirrorupgrade.hook
    echo "Depends = reflector" | sudo tee -a mirrorupgrade.hook
    echo "Exec = /bin/sh -c \"sudo reflector --verbose --country BR --age 24 --p http --p https --sort rate --save /etc/pacman.d/mirrorlist; rm -f /etc/pacman.d/mirrorlist.pacnew\"" | sudo tee -a mirrorupgrade.hook
    pf "Configuração do Reflector concluída!" "success"
  fi
}
configure_reflector
