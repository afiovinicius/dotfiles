#!/bin/sh

##
# Atualização do sistema
##
printf "Atualizando o sistema"
sudo pacman -Syu --noconfirm

##
# Ajustando SWAP
##
printf "Configurando SWAP"
sudo sysctl -w vm.swappiness=10
sysctl -a | grep -i swappiness

##
# Configuração das fonts e emojis
##
printf "Iniciando instalação e configuração das fonts e emojis"
sudo pacman -S --noconfirm noto-fonts-emoji adobe-source-code-pro-fonts adobe-source-serif-fonts adobe-source-sans-fonts ttf-inconsolata
mkdir $HOME/.config/fontconfig
echo -e '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE fontconfig SYSTEM "fonts.dtd">\n<fontconfig>\n<!-- ## serif ## -->\n<alias>\n<family>serif</family>\n<prefer>\n<family>Noto Serif</family>\n<family>emoji</family>\n<family>Liberation Serif</family>\n<family>Nimbus Roman</family>\n<family>DejaVu Serif</family>\n</prefer>\n</alias>\n<!-- ## sans-serif ## -->\n<alias>\n<family>sans-serif</family>\n<prefer>\n<family>Noto Sans</family>\n<family>emoji</family>\n<family>Liberation Sans</family>\n<family>Nimbus Sans</family>\n<family>DejaVu Sans</family>\n</prefer>\n</alias>\n</fontconfig>' > $HOME/.config/fontconfig/fonts.conf

##
# Sistema
##
printf "Instalando ferramentas globais"
sudo pacman -S --noconfirm dmenu clipmenu dunst polybar feh imv gvfs peek picom nitrogen sxhkd ranger wmname rofi reflector neofetch htop ffmpeg gst-plugins-ugly gst-plugins-good gst-plugins-base gst-plugins-bad gst-libav ufw gufw libinput galculator

##
# Gerenciador de Arquivos
##
sudo pacman -Syu --noconfirm pcmanfm

##
# Internet
##
printf "Instalando ferramentas internet"
sudo pacman -S --noconfirm firefox transmission-gtk

##
# Cliente Mensageiros
##
printf "Instalando ferramentas de mensageria"
sudo pacman -S --noconfirm discord telegram-desktop

##
# Jogos
##
printf "Instalando ferramentas para jogos"
sudo pacman -S --noconfirm steam mangohud lib32-mangohud

##
# Editor de texto
##
printf "Instalando ferramenta editor de texto"
sudo pacman -S --noconfirm emacs emacs-lua-mode

##
# Multimidia
##
printf "Instalando ferramentas de multimidia"
sudo pacman -S --noconfirm obs-studio yt-dlp audacious vlc cheese libcheese

##
# Gráficas
##
printf "Instalando ferramentas de design"
sudo pacman -S --noconfirm gimp inkscape

##
# Escritório
##
printf "Instalando ferramentas de escritório"
sudo pacman -S --noconfirm mupdf mupdf-tools

##
# Compactação de arquivos
##
printf "Instalando ferramentas de empacotamento"
sudo pacman -S --noconfirm unzip gzip zip p7zip

##
# Desenvolvimento
##
printf "Instalando ferramentas de desenvolvimento"
sudo pacman -S --noconfirm git github-cli nodejs npm yarn pnpm pm2 apache php php-apache phpmyadmin sqlite lib32-sqlite python python-pip docker jdk-openjdk

##
# Utiliarios
##
printf "Instalando ferramentas utiliarios"
sudo pacman -S --noconfirm vim kitty alacritty zsh conky flameshot

# Download oh my zsh +  plugins
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
printf "Baixando arquivo de instalação oh my zsh"
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o $HOME/stp-bspwm
cd $HOME/.oh-my-zsh/plugins
git clone https://github.com/zsh-users/zsh-completions.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions.git
cd $HOME/

##
# Apps do usuário do AUR
##
printf "Criando pasta aur"
mkdir $HOME/aur && cd $HOME/aur
printf "Instalando yay"
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -sic --skippgpcheck
cd $HOME
printf "Instalando pacotes pelo yay"
yay -Syu --skippgpcheck onlyoffice-bin spotify visual-studio-code-bin mockoon-bin obsidian-bin postman-bin local-by-flywheel-bin heroic-games-launcher-bin medit

# Configurações BSPWM
printf "Git config e clonando repo"
git config --global user.name "afiovinicius" && git config --global user.email "afiovinicius@gmail.com"
repo_url="https://github.com/afiovinicius/stp-bspwm"
repo_dir="$HOME/.stp-bspwm"

git clone --depth=1 "$repo_url" "$repo_dir"
printf "Clonagem foi um sucesso"

# Configurandoa arquivos
printf "Modelando os arquivos"
cd "$HOME"
printf "copiando arquivo de configuração do zsh"
cp -p "$HOME"/.stp-bspwm/.zshrc "$HOME"
printf "arquivo de configuração do zsh copiado"
printf "copiando pasta de configurações do bspwm"
cp -p "$HOME"/.stp-bspwm/config/bspwm "$HOME"/.config/
printf "pasta de configurações do bspwm copiada"

# Finalizado
sudo pacman-key --refresh-keys 
sudo pacman -Syu && sudo pacman -Rs $(pacman -Qqdt)
printf "Setup completo"
reboot