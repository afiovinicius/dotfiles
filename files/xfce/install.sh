#!/bin/sh

## init block ##
#~~|¨Head Script¨|~~#
source "../../scripts/utils.sh"
## end block ##

## init block ##
#~~|¨Install XFCE¨|~~#
read -n1 -rep "Deseja iniciar instalação do xfce? (s/n)" INIT
if [[ $INIT =~ ^[Ss]$ ]]; then
  pf "Instalando XFCE4" "warn"
  sudo pacman -S --needed --noconfirm xfce4 xfce4-goodies
  pf "Instalação concluída!" "success"
else
  exit
fi
# https://docs.xfce.org/#core_modules
## end block ##

## init block ##
#~~|¨Systemd Tools¨|~~#
pf "Essas são as ferramentas do ambiente XFCE:" "warn"
plist "${PKGS_XFCE[@]}"
pkg_i "${PKGS_XFCE[@]}"
## end block ##

## init block ##
#~~|¨Systemd Enable¨|~~#
pf "Definindo interface na próxima inicialização." "warn"
sudo systemctl set-default graphical.target
pf "Habilitando fstrim para melhor desempenho do SSD." "warn"
sudo systemctl enable fstrim.timer
pf "Habilitando NetworkManager." "warn"
sudo systemctl enable NetworkManager
pf "Habilitando Pipewire." "warn"
sudo systemctl enable pipewire-pulse.service
sudo systemctl start pipewire-pulse.service
## end block ##

## init block ##
#~~|¨Ecosystem¨|~~#
read -n1 -rep "Você gostaria de iniciar a instalação do ecossistema? (s,n)" ECOSYS
if [[ $ECOSYS == "S" || $ECOSYS == "s" ]]; then
  pf "Instalando..." "warn"
  cd "../../scripts/"
  sleep 0.5
  "./ecosystem.sh"
  pf "Ecossistema instalado e configurado!" "success"
fi
## end block ##
