#!/bin/sh

## init block ##
#~~|¨Head Script¨|~~#
source "../../scripts/utils.sh"
## end block ##

## init block ##
#~~|¨Install KDE¨|~~#
read -n1 -rep "Deseja iniciar instalação do kde? (s/n)" INIT
if [[ $INIT =~ ^[Ss]$ ]]; then
  pf "Instalando KDE Plasma" "warn"
  sudo pacman -S --needed --noconfirm plasma plasma-desktop sddm
  pf "Instalação concluída!" "success"
else
  exit
fi
## end block ##

## init block ##
#~~|¨Systemd Enable¨|~~#
pf "Definindo interface na próxima inicialização." "warn"
sudo systemctl set-default graphical.target
pf "Habilitando fstrim para melhor desempenho do SSD." "warn"
sudo systemctl enable fstrim.timer
pf "Habilitando NetworkManager." "warn"
sudo systemctl enable NetworkManager
pf "Habilitando sddm." "warn"
sudo systemctl enable sddm
## end block ##

## init block ##
#~~|¨Ecosystem¨|~~#
read -n1 -rep "Você gostaria de iniciar a instalação do ecossistema? (s,n)" ECOSYS
if [[ $ECOSYS == "S" || $ECOSYS == "s" ]]; then
  pf "Instalando..." "warn"
  cd "../../scripts/"
  sleep 0.5
  "./ecosysteco.sh"
  pf "Ecossistema instalado e configurado!" "success"
fi
## end block ##