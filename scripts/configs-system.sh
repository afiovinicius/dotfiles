#!/bin/sh

#~~|¨Head Script¨|~~#
source "./scripts/utils.sh"

#~~|¨Config FSTAB¨|~~#
pf "Otimizando fstab para vida útil do SSD..." "warn"
sudo sed -i 's/relatime/noatime/g' /etc/fstab
pf "fstab configurado!" "success"

#~~|¨Config Swap & ZRAM¨|~~#
pf "Configurando ZRAM e Parâmetros de Memória." "warn"
configure_zram() {
  # 1. Configurando o zram-generator
  if [ ! -f "/etc/systemd/zram-generator.conf" ]; then
    pf "Criando configuração do ZRAM..." "warn"
    echo "[zram0]" | sudo tee /etc/systemd/zram-generator.conf
    # Define o tamanho do zram para metade da sua RAM disponível e usa o algoritmo zstd
    echo "zram-size=ram/2" | sudo tee -a /etc/systemd/zram-generator.conf
    echo "compression-algorithm=zstd" | sudo tee -a /etc/systemd/zram-generator.conf
    echo "swap-priority=100" | sudo tee -a /etc/systemd/zram-generator.conf
    echo "fs-type=swap" | sudo tee -a /etc/systemd/zram-generator.conf
  fi

  # Recarrega o systemd e inicia o ZRAM
  sudo systemctl daemon-reload
  sudo systemctl start /dev/zram0
  sudo swapoff /dev/zram0
  sudo systemctl restart systemd-zram-setup@zram0.service

  # 2. Ajustando parâmetros do Sysctl para ZRAM
  pf "Ajustando o Swappiness e gerenciamento de memória..." "warn"
  # O Swappiness deve ser alto (ex: 150) para maximizar o uso do ZRAM comprimido
  sudo sysctl -w vm.swappiness=150
  sudo sysctl -w vm.watermark_boost_factor=0
  sudo sysctl -w vm.watermark_scale_factor=125
  sudo sysctl -w vm.page-cluster=0

  # Salvando as configurações permanentemente
  echo "vm.swappiness=150" | sudo tee /etc/sysctl.d/99-zram.conf
  echo "vm.watermark_boost_factor=0" | sudo tee -a /etc/sysctl.d/99-zram.conf
  echo "vm.watermark_scale_factor=125" | sudo tee -a /etc/sysctl.d/99-zram.conf
  echo "vm.page-cluster=0" | sudo tee -a /etc/sysctl.d/99-zram.conf

  sudo sysctl --system
  zramctl && echo "---" && swapon --show

  pf "Configuração do ZRAM concluída!" "success"
}
configure_zram

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
pf "Habilitando e iniciando gerenciamento de bateria." "warn"
sudo systemctl enable --now power-profiles-daemon.service
sudo systemctl enable --now power-profiles-daemon
sudo systemctl start power-profiles-daemon.service
sudo systemctl start power-profiles-daemon

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
