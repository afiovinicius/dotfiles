#!/bin/sh

#~~|¨Head Script¨|~~#
source "./scripts/utils.sh"

#~~|¨Install Hyprland¨|~~#
read -n1 -rep "Deseja iniciar instalação do hyprland? (s/n)" INIT
if [[ $INIT =~ ^[Ss]$ ]]; then
  pf "Instalando hyprland..." "warn"
  sudo pacman -S --needed --noconfirm hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-wlr sddm
  pf "Instalação concluída!" "success"
else
  exit
fi

#~~|¨Systemd Tools¨|~~#
pf "Essas são as ferramentas do ambiente hyprland:" "warn"
plist "${PKGS_HYPR[@]}"
pkg_i "${PKGS_HYPR[@]}"

#~~|¨Systemd Enable¨|~~#
pf "Definindo interface na próxima inicialização." "warn"
sudo systemctl set-default graphical.target
pf "Habilitando fstrim para melhor desempenho do SSD." "warn"
sudo systemctl enable fstrim.timer
pf "Habilitando NetworkManager." "warn"
sudo systemctl enable NetworkManager
pf "Habilitando Polkit." "warn"
sudo systemctl enable polkit.service
pf "Habilitando sddm." "warn"
sudo systemctl enable sddm

#~~|¨Ecosystem¨|~~#
read -n1 -rep "Você gostaria de iniciar a instalação do ecossistema? (s,n)" ECOSYS
if [[ $ECOSYS == "S" || $ECOSYS == "s" ]]; then
  pf "Instalando..." "warn"
  "./scripts/ecosystem.sh"
  pf "Ecossistema instalado e configurado!" "success"
fi