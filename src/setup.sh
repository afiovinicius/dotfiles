#!/bin/sh

#~~|¨Head Script¨|~~#
source "./scripts/utils.sh"

pf "Bem-vindo ao script de instalação! $BANNER"
  
#~~|¨Default Packages¨|~~#
pf "Você está prestes a instalar os seguintes pacotes:" "warn"
plist "${PKGS_DEFAULT[@]}"
pkg_i "${PKGS_DEFAULT[@]}" 
  
#~~|¨Drivers CPU¨|~~#
pf "Vamos iniciar a instalação dos drivers para CPU!" "warn"
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
  
#~~|¨Xorg & Wayland¨|~~#
pf "Escolha o seu servidor de exibição!" "warn"
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

#~~|¨Drivers GPU¨|~~#
pf "Vamos iniciar a instalação dos drivers para GPU!" "warn"
while true; do
  read -rep "Sua placa de vídeo é de que tipo? (NVIDIA, AMD ou Intel)" DVRS
  if [[ $DVRS == "AMD" || $DVRS == "amd" ]]; then
    pf "Instalando os drivers da $DVRS" "warn"
    sudo pacman -S --needed --noconfirm "${GPU_AMD[@]}"
    pf "Instalação concluída!" "success"
    break
  elif [[ $DVRS == "INTEL" || $DVRS == "intel" ]]; then
    pf "Instalando os drivers da $DVRS" "warn"
    sudo pacman -S --needed --noconfirm "${GPU_INTEL[@]}"
    pf "Instalação concluída!" "success"
    break
  elif [[ $DVRS == "NVIDIA" || $DVRS == "nvidia" ]]; then
    pf "Instalando os drivers da $DVRS" "warn"
    sudo pacman -S --needed --noconfirm "${GPU_NVIDIA[@]}"
    pf "Instalação concluída!" "success"
    break  
  else
    pf "Opção inválida. Por favor, escolha um das opções informadas." "error"
  fi
done
  
#~~|¨Config System¨|~~#
read -n1 -rep "Você gostaria de iniciar a configuração do sistema? (s,n)" ECOSETT
if [[ $ECOSETT == "S" || $ECOSETT == "s" ]]; then
  pf "Iniciando configurações..." "warn"
  "./scripts/configs-system.sh"
  pf "Configuração concluída!" "success"
fi
  
#~~|¨Install Desktop Environment¨|~~#
while true; do
  read -rep "Qual ambiente desktop você deseja instalar? (KDE ou Hyprland)" DE
  if [[ $DE == "KDE" || $DE == "kde" ]]; then
    "./files/kde/install.sh"
    break
  elif [[ $DE == "HYPRLAND" || $DE == "hyprland" ]]; then
    "./files/hyprland/install.sh"
    break
  else
    pf "Opção inválida. Por favor, escolha um dos ambientes desktop listados." "error"
  fi
done

#~~|¨Setup Finally¨|~~#
pf "Atualizando o sistema."
sudo pacman -Syu --noconfirm

#~~|¨Clear Caches¨|~~#
# pf "Limpando caches do sistema."
# "../scripts/clear-caches.sh"

#~~|¨Congratulations¨|~~#
pf "Script foi finalizado com sucesso!!🎉" "success"
read -n1 -rep "Você gostaria de Reiniciar o sistema agora? (s,n)" SYSF
if [[ $SYSF == [Ss] ]]; then
  pf "Reiniciando o sistema!" "warn"
  reboot
fi
