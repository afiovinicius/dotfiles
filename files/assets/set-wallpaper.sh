#!/bin/sh

## init block ##
#~~|¨Head Script¨|~~#
source "../../scripts/utils.sh"

DIR_IMGS="$DIR_NAV/wallpapers"
FILES=("$DIR_IMGS"/*)
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
  plist "${FILES[@]}"
  read -p "Selecione o número do wallpaper desejado: " SET
  if [[ $SET =~ ^[0-9]+$ ]]; then
    if (( SET > 0 && SET <= ${#FILES[@]} )); then
      DIR_CURRENT="${FILES[$((SET-1))]}"
      pf "Você selecionou: ${DIR_CURRENT##*/}." "warn"
      feh --bg-fill "$DIR_CURRENT"
      pf "${DIR_CURRENT##*/} definido com sucesso." "success"
      break
    else
      pf "Número inválido. Por favor, selecione um número da lista." "error"
    fi
  else
    pf "Entrada inválida. Por favor, insira um número." "error"
  fi
done
## end block ##