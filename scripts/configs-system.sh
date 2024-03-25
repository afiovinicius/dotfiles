#!/bin/sh

## init block ##
#~~|¨Head Script¨|~~#
source "./utils.sh"
## end block ##

## init block ##
#~~|¨Config Swap¨|~~#
pf "Configurando SWAP." "warn"
sudo sysctl -w vm.swappiness=10
sudo sysctl -a | grep -i swappiness
## end block ##

## init block ##
#~~|¨Config Pacman¨|~~#
pf "Iniciando configuração do pacman para melhor desempenho." "warn"
configure_pacman() {
  pf "Remover os comentários das linhas relevantes." "warn"
  sed -i 's/^#\[multilib\]/#Include = \/etc\/pacman.d\/mirrorlist/' "$PACMAN_CONF"
  sed -i 's/^#Color/' "$PACMAN_CONF"
  sed -i 's/^#ParallelDownloads = 5/' "$PACMAN_CONF"
  pf "Definindo o número de downloads paralelos e adicionando efeito pac man progress." "warn"
  echo "ParallelDownloads = 10" >> "$PACMAN_CONF"
  echo "ILoveCandy" >> "$PACMAN_CONF"
  pf "Salvar e atualizar a lista de mirrors." "warn"
  sudo pacman -Sy
  pf "Configuração do Pacman concluída!" "success"
}
configure_pacman
## end block ##

## init block ##
#~~|¨Config Systemctl¨|~~#
pf "Habilitando e iniciando protocolos." "warn"
sudo systemctl enable httpd
sudo systemctl start httpd
pf "Habilitando Bluetooth." "warn"
sudo systemctl enable bluetooth.service
pf "Habilitando e iniciando Reflector." "warn"
sudo systemctl enable reflector.service
sudo systemctl start reflector.service
## end block ##

## init block ##
#~~|¨Config Reflector¨|~~#
pf "Iniciando configuração do Reflector." "warn"
configure_reflector() {
  pf "Atualizando o mirror Brazil com Reflector..." "warn"
  sudo reflector --country Brazil --age 24 --p http --p https --sort rate --save /etc/pacman.d/mirrorlist
  sleep 0.5
  pf "Criando automação com Hook..." "warn"
  cd "/etc/pacman.d" && sudo mkdir hooks && cd hooks
  sleep 0.5
  echo "[Trigger]" >> mirrorupgrade.hook
  echo "Operation = Upgrade" >> mirrorupgrade.hook
  echo "Type = Package" >> mirrorupgrade.hook
  echo "Target = pacman-mirrorlist" >> mirrorupgrade.hook
  echo "[Action]" >> mirrorupgrade.hook
  echo "Description = Updating pacman-mirrorlist with reflector and removing pacnew..." >> mirrorupgrade.hook
  echo "When = PostTransaction" >> mirrorupgrade.hook
  echo "Depends = reflector" >> mirrorupgrade.hook
  echo "Exec = /bin/sh -c \"sudo reflector --country Brazil --age 24 --p http --p https --sort rate --save /etc/pacman.d/mirrorlist; rm -f /etc/pacman.d/mirrorlist.pacnew\"" >> mirrorupgrade.hook
  pf "Configuração do Reflector concluída!" "success"
}
configure_reflector
## end block ##

