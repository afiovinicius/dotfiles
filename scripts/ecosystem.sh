#!/bin/sh

## init block ##
#~~|¨Head Script¨|~~#
source "./utils.sh"
## end block ##

## init block ##
#~~|¨Accessories¨|~~#
pf "Esseas são as ferramentas de acessórios do sistema:" "warn"
plist "${ACCESSORIES[@]}"
pkg_i "${ACCESSORIES[@]}"
## end block ##

## init block ##
#~~|¨Development¨|~~#
pf "Esseas são as ferramentas para desenvolvedor:" "warn"
plist "${DEVELOPMENT[@]}"
pkg_i "${DEVELOPMENT[@]}"
## end block ##

## init block ##
#~~|¨Games¨|~~#
pf "Esseas são as ferramentas para jogos:" "warn"
plist "${GAMES[@]}"
pkg_i "${GAMES[@]}"
# https://wiki.archlinux.org/title/gaming
# https://github.com/lutris/docs/blob/master/WineDependencies.md#archendeavourosmanjaroother-arch-derivatives
# https://arch.d3sox.me/gaming/
## end block ##

## init block ##
#~~|¨Graphics¨|~~#
pf "Esseas são as ferramentas para design:" "warn"
plist "${GRAPHICS[@]}"
pkg_i "${GRAPHICS[@]}"
## end block ##

## init block ##
#~~|¨IOT¨|~~#
pf "Esseas são as ferramentas para internet:" "warn"
plist "${IOT[@]}"
pkg_i "${IOT[@]}"
## end block ##

## init block ##
#~~|¨Multimedia¨|~~#
pf "Esseas são as ferramentas para áudio visual:" "warn"
plist "${MEDIA[@]}"
pkg_i "${MEDIA[@]}"
## end block ##

## init block ##
#~~|¨Office¨|~~#
pf "Esseas são as ferramentas para escritório:" "warn"
plist "${OFFICE[@]}"
pkg_i "${OFFICE[@]}"
## end block ##

## init block ##
#~~|¨System¨|~~#
pf "Esseas são as ferramentas gerais do sistema:" "warn"
plist "${SETTIGNS[@]}"
pkg_i "${SETTIGNS[@]}"
## end block ##

## init block ##
#~~|¨AUR Packages¨|~~#
pf "Você está prestes a instalar os pacotes do AUR:" "warn"
plist "${PKGS_AUR[@]}"

read -n1 -rep "Deseja continuar com a instação? (s/n)" AURPKGS
if [[ $AURPKGS == [Ss] ]]; then
  if ! command -v yay &>/dev/null; then
    pf "Criando diretório do aur..." "warn"
    mkdir "$DIR_USER/aur" && cd "$DIR_USER/aur"
    pf "Diretório criado! Usuário no diretório $PWD" "success"
    pf "Clonando repo do yay e iniciando instalação..." "warn"
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -sic --skippgpcheck
    yay -S --needed --noconfirm "${PKGS_AUR[@]}"
    pf "Instalação concluída!" "success"
  else
    yay -S --needed --noconfirm "${PKGS_AUR[@]}"
  fi
fi
## end block ##

## init block ##
#~~|¨Flatpak¨|~~#
pf "Instalando Flatpak." "warn"
pkg_i "flatpak"
## end block ##

## init block ##
#~~|¨Config Ecosystem¨|~~#
read -n1 -rep "Você gostaria de iniciar a configuração do ecossistema? (s,n)" ECOSETT
if [[ $ECOSETT == "S" || $ECOSETT == "s" ]]; then
  pf "Iniciando configurações..." "warn"
  sleep 0.5
  "./configs-desktop.sh"
  pf "Configuração concluída!" "success"
fi
## end block ##
