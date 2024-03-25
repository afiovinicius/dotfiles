#!/bin/sh

## init block ##
#~~|¨Head Script¨|~~#
source "./scripts/utils.sh"

BANNER="
  ___    __  _                ___              _     
 / _ \  / _|(_)              / _ \            | |    
/ /_\ \| |_  _   ___        / /_\ \ _ __  ___ | |__  
|  _  ||  _|| | / _ \   __  |  _  || '__|/ __|| '_ \ 
| | | || |  | || (_) | |__| | | | || |  | (__ | | | |
\_| |_/|_|  |_| \___/       \_| |_/|_|   \___||_| |_|
"

pf "Bem-vindo ao script de instalação! $BANNER"
## end block ##

## init block ##
#~~|¨Default Packages¨|~~#
pf "Você está prestes a instalar os seguintes pacotes:" "warn"
plist "${PKGS_DEFAULT[@]}"
pkg_i "${PKGS_DEFAULT[@]}"
## end block ##

## init block ##
#~~|¨Drivers¨|~~#
pf "Vamos iniciar a instalação dos drivers!" "warn"

while true; do
  read -rep "Qual o seu processador? (AMD ou Intel)" DVRS
  if [[ $DVRS == "AMD" || $DVRS == "amd" ]]; then
    pf "Instalando os drivers da $DVRS" "warn"
    sudo pacman -S --needed --noconfirm "${DRIVERS_AMD[@]}"
    pf "Instalação concluída!" "success"
    break
  elif [[ $DVRS == "INTEL" || $DVRS == "intel" ]]; then
    pf "Instalando os drivers da $DVRS" "warn"
    sudo pacman -S --needed --noconfirm "${DRIVERS_INTEL[@]}"
    pf "Instalação concluída!" "success"
    break
  else
    pf "Opção inválida. Por favor, escolha um das opções informadas." "error"
  fi
done
## end block ##

## init block ##
#~~|¨Xorg & Wayland¨|~~#
while true; do
  read -rep "Qual servidor de exibição você usa? (Xorg ou Wayland)" SE
  if [[ $SE == "XORG" || $SE == "xorg" ]]; then
    pf "Instalando $SE" "warn"
    sudo pacman -S --needed --noconfirm "${XORG[@]}"
    pf "Instalação concluída!" "success"
    break
  elif [[ $SE == "WAYLAND" || $SE == "wayland" ]]; then
    pf "Instalando $SE" "warn"
    sudo pacman -S --needed --noconfirm "${WAYLAND[@]}"
    pf "Instalação concluída!" "success"
    break
  else
    pf "Opção inválida. Por favor, escolha um das opções informadas." "error"
  fi
done
## end block ##

## init block ##
#~~|¨Config System¨|~~#
read -n1 -rep "Você gostaria de iniciar a configuração do sistema? (s,n)" ECOSETT
if [[ $ECOSETT == "S" || $ECOSETT == "s" ]]; then
  pf "Iniciando configurações..." "warn"
  sleep 0.5
  "./scripts/configs-system.sh"
  pf "Configuração concluída!" "success"
fi
## end block ##

## init block ##
#~~|¨Install DE¨|~~#
while true; do
  read -rep "Qual ambiente desktop você deseja instalar? (KDE)" DE
  if [[ $DE == "KDE" || $DE == "kde" ]]; then
    cd "$DIR_FILES/kde"
    sleep 0.5
    "./install.sh"
    break
  else
    pf "Opção inválida. Por favor, escolha um dos ambientes desktop listados." "error"
  fi
done
## end block ##

## init block ##
#~~|¨Set Wallpaper¨|~~#
read -n1 -rep "Você gostaria de configurar wallpaper usando o feh? (s,n)" SETWALL
if [[ $SETWALL == [Ss] ]]; then
  cd "$DIR_FILES/assets"
  sleep 0.5
  "./set-wallpaper.sh"
fi
## end block ##

## init block ##
#~~|¨Clear Caches¨|~~#
pf "Limpando caches do sistema de páginas, inode e dentry."
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"

pf "Limpando o cache do pacman." 
sudo pacman -Sc --noconfirm
## end block ##

## init block ##
#~~|¨Setup Finally¨|~~#
pf "Atualizando o sistema."
sudo pacman -Syu --noconfirm

pf "Removendo todos os pacotes órfãos do seu sistema."
sudo pacman -Rs $(pacman -Qqdt >/dev/null)
## end block ##

## init block ##
#~~|¨Congratulations¨|~~#
pf "Script foi finalizado com sucesso!!🎉" "success"

read -n1 -rep "Você gostaria de Reiniciar o sistema agora? (s,n)" SYSF
if [[ $SYSF == [Ss] ]]; then
  pf "Reiniciando o sistema!" "warn"
  reboot
fi
## end block ##
