#!/bin/sh

## init block ##
#~~|¨Head Script¨|~~#
source "./utils"

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
#~~|¨Install DE¨|~~#
while true; do
read -rep "Qual ambiente desktop você quer instalar? (KDE ou XFCE)" DE
if [[ $DE == "KDE" || $DE == "kde" ]]; then
  cd "$DIR_FILES/kde"
  sleep 0.5
  ./install.sh
  break
elif [[ $DE == "XFCE" || $DE == "xfce" ]]; then
  cd "$DIR_FILES/xfce"
  sleep 0.5
  ./install.sh
else
  pf "Opção inválida. Por favor, escolha um dos ambientes desktop listados." "error"
fi
done
## end block ##

## init block ##
#~~|¨Set Wallpaper¨|~~#
read -n1 -rep "Você gostaria de configurar wallpaper usando o feh? (s,n)" SETWALL
if [[ $SETWALL == "S" || $SETWALL == "s" ]]; then
  cd "$DIR_FILES/assets"
  sleep 0.5
  ./set-wallpaper.sh
fi
## end block ##

## init block ##
#~~|¨Clear Caches¨|~~#
pf "Limpando caches do sistema de páginas, inode e dentry."
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"

pf "Limpando o cache do pacman" 
sudo pacman -Sc --noconfirm
## end block ##

## init block ##
#~~|¨Setup Finally¨|~~#
pf "Atualizando o sistema"
sudo pacman -Syu --noconfirm

pf "Removendo todos os pacotes órfãos do seu sistema"
sudo pacman -Rs $(pacman -Qqdt)
## end block ##
