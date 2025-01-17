#!/bin/sh

#~~|¨Head Script¨|~~#
source "./scripts/utils.sh"

#~~|¨Accessories¨|~~#
pf "Essas são as ferramentas de acessórios do sistema:" "warn"
plist "${ACCESSORIES[@]}"
pkg_i "${ACCESSORIES[@]}"

#~~|¨Development¨|~~#
pf "Essas são as ferramentas para desenvolvedor:" "warn"
plist "${DEVELOPMENT[@]}"
pkg_i "${DEVELOPMENT[@]}"

#~~|¨Games¨|~~#
pf "Essas são as ferramentas para jogos:" "warn"
plist "${GAMES[@]}"
pkg_i "${GAMES[@]}"
# https://wiki.archlinux.org/title/gaming
# https://github.com/lutris/docs/blob/master/WineDependencies.md#archendeavourosmanjaroother-arch-derivatives
# https://arch.d3sox.me/gaming/

#~~|¨Graphics¨|~~#
pf "Essas são as ferramentas para design:" "warn"
plist "${GRAPHICS[@]}"
pkg_i "${GRAPHICS[@]}"

#~~|¨IOT¨|~~#
pf "Essas são as ferramentas para internet:" "warn"
plist "${IOT[@]}"
pkg_i "${IOT[@]}"

#~~|¨Multimedia¨|~~#
pf "Essas são as ferramentas para áudio visual:" "warn"
plist "${MEDIA[@]}"
pkg_i "${MEDIA[@]}"

#~~|¨Office¨|~~#
pf "Essas são as ferramentas para escritório:" "warn"
plist "${OFFICE[@]}"
pkg_i "${OFFICE[@]}"

#~~|¨System¨|~~#
pf "Essas são as ferramentas gerais do sistema:" "warn"
plist "${SETTIGNS[@]}"
pkg_i "${SETTIGNS[@]}"

#~~|¨AUR Packages¨|~~#
pf "Você está prestes a instalar os pacotes do AUR:" "warn"
plist "${PKGS_AUR[@]}"
read -n1 -rep "Deseja continuar com a instação? (s/n)" AURPKGS
if [[ $AURPKGS == [Ss] ]]; then
  if ! command -v yay &>/dev/null; then
    pf "Criando diretório do aur..." "warn"
    mkdir -p "$HOME/aur"
    pf "Diretório criado!" "success"
    pf "Clonando repo do yay e iniciando instalação..." "warn"
    git clone https://aur.archlinux.org/yay.git "$HOME/aur/yay"
    makepkg -C -C "$HOME/aur/yay" -sic --skippgpcheck
    yay -S --needed --noconfirm "${PKGS_AUR[@]}"
    pf "Instalação concluída!" "success"
  else
    yay -S --needed --noconfirm "${PKGS_AUR[@]}"
  fi
fi

#~~|¨Flatpak¨|~~#
pf "Instalando Flatpak." "warn"
pkg_i "flatpak"

#~~|¨Config Ecosystem¨|~~#
read -n1 -rep "Você gostaria de iniciar a configuração do ecossistema? (s,n)" ECOSETT
if [[ $ECOSETT == "S" || $ECOSETT == "s" ]]; then
  pf "Iniciando configurações..." "warn"
  sleep 0.5
  "./scripts/configs-desktop.sh"
  pf "Configuração concluída!" "success"
fi