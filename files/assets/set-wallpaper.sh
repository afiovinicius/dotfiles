#!/bin/sh

## init block ##
#~~|¨Head Script¨|~~#
source "../../utils"

DIR_IMGS="$DIR_NAV/wallpapers"
FILES=("$DIR_IMGS"/*)
NUM=1
## end block ##

## init block ##
#~~|¨Verify Feh¨|~~#
if ! command -v feh &>/dev/null; then
  read -n1 -rep "O feh não está instalado. Deseja instalá-lo agora? (s/n)" RES
  if [[ $RES =~ ^[Ss]$ ]]; then
    pf "Instalando o feh..." "warn"
    sudo pacman -S --noconfirm feh
    pf "Instalação concluída..." "success"
    sleep 1
  else
    exit 1
  fi
fi
## end block ##

## init block ##
#~~|¨Feh Config¨|~~#
pf "Lista de wallpapers:" "warn"
while true; do
  for archives in "${FILES[@]}"; do
    if [ -f "$archives" ]; then
      printf "%2d: ${archives##*/}\n" "$NUM"
      ((NUM++))
    fi
  done
  read -p "Selecione o número do wallpaper desejado: " SET
  if [[ $SET =~ ^[0-9]+$ ]]; then
    if (( SET > 0 && SET <= ${#FILES[@]} )); then
      DIR_CURRENT="${FILES[$((SET-1))]}"
      pf "Você selecionou: ${DIR_CURRENT##*/}." "warn"
      # feh --bg-fill "$DIR_CURRENT"
      pf "${DIR_CURRENT##*/} definido com sucesso." "success"
      break
    else
      pf "Número inválido. Por favor, selecione um número da lista." "error"
      NUM=1
    fi
  else
    pf "Entrada inválida. Por favor, insira um número." "error"
    NUM=1
  fi
done
## end block ##