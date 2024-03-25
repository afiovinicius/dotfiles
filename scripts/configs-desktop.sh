#!/bin/sh

## init block ##
#~~|¨Head Script¨|~~#
source "./utils.sh"
## end block ##

## init block ##
#~~|¨Fonts¨|~~#
pf "Iniciando instalação e configuração das fonts e emojis." "warn"
sudo pacman -S --needed --noconfirm noto-fonts-emoji adobe-source-code-pro-fonts adobe-source-serif-fonts adobe-source-sans-fonts ttf-inconsolata
pf "Criando pasta e arquivo de configuração." "warn"
mkdir "$DIR_USER/.config/fontconfig"
echo -e '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE fontconfig SYSTEM "fonts.dtd">\n<fontconfig>\n<!-- ## serif ## -->\n<alias>\n<family>serif</family>\n<prefer>\n<family>Noto Serif</family>\n<family>emoji</family>\n<family>Liberation Serif</family>\n<family>Nimbus Roman</family>\n<family>DejaVu Serif</family>\n</prefer>\n</alias>\n<!-- ## sans-serif ## -->\n<alias>\n<family>sans-serif</family>\n<prefer>\n<family>Noto Sans</family>\n<family>emoji</family>\n<family>Liberation Sans</family>\n<family>Nimbus Sans</family>\n<family>DejaVu Sans</family>\n</prefer>\n</alias>\n</fontconfig>' > "$DIR_USER/.config/fontconfig/fonts.conf"
pf "Configuração concluída." "success"
## end block ##

## init block ##
#~~|¨Terminal¨|~~#
pf "Iniciando instalação e configuração do terminal zsh + starship." "warn"
cp "../files/.zshenv" "$DIR_USER/.zshenv"
cp -r "../files/config/zsh" "$DIR_USER/.config/zsh"
chsh -s $(which zsh)
## end block ##

## init block ##
#~~|¨Docker¨|~~#
# sudo systemctl enable docker.service
# sudo systemctl start docker.service
## end block ##

## init block ##
#~~|¨Git¨|~~#
# git config --global user.name "user" && git config --global user.email "mail"
# gh auth login
## end block ##