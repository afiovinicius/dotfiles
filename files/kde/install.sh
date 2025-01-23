#!/bin/sh

#~~|¨Head Script¨|~~#
source "./scripts/utils.sh"

#~~|¨Install KDE¨|~~#
read -n1 -rep "Deseja iniciar instalação do kde? (s/n)" INIT
if [[ $INIT =~ ^[Ss]$ ]]; then
  pf "Instalando KDE Plasma" "warn"
  sudo pacman -S --needed --noconfirm plasma plasma-desktop sddm
  pf "Instalação concluída!" "success"
else
  exit
fi

#~~|¨Systemd Tools¨|~~#
pf "Essas são as ferramentas do ambiente KDE:" "warn"
plist "${PKGS_KDE[@]}"
pkg_i "${PKGS_KDE[@]}"

#~~|¨Systemd Enable¨|~~#
pf "Definindo interface na próxima inicialização." "warn"
sudo systemctl set-default graphical.target
pf "Habilitando fstrim para melhor desempenho do SSD." "warn"
sudo systemctl enable fstrim.timer
pf "Habilitando NetworkManager." "warn"
sudo systemctl enable NetworkManager
pf "Habilitando sddm." "warn"
sudo systemctl enable sddm

#~~|¨Config NumLock |~~#
pf "Iniciando configuração para ativar NumLock." "warn"
configure_numlock() {
  if [ ! -f "$HOME/.config/kcminputrc" ]; then
      echo "[Keyboard]" > "$HOME/.config/kcminputrc"
  fi
  if grep -q "NumLock" "$HOME/.config/kcminputrc"; then
    sed -i 's/^NumLock=.*/NumLock=1/' "$HOME/.config/kcminputrc"
  else
      echo -e "\n[Keyboard]" >> "$HOME/.config/kcminputrc"
      echo "NumLock=1" >> "$HOME/.config/kcminputrc"
  fi
  pf "Configuração do NumLock aplicada no KDE Plasma." "success"
}
configure_numlock

#~~|¨Ecosystem¨|~~#
read -n1 -rep "Você gostaria de iniciar a instalação do ecossistema? (s,n)" ECOSYS
if [[ $ECOSYS == "S" || $ECOSYS == "s" ]]; then
  pf "Instalando..." "warn"
  "./scripts/ecosystem.sh"
  pf "Ecossistema instalado e configurado!" "success"
fi