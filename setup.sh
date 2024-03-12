#!/bin/sh

# Atualização do sistema
sudo pacman -Syu

# Ajustando SWAP
sudo sysctl -w vm.swappiness=10
sysctl -a | grep -i swappiness

# Configuração das fonts e emojis
sudo pacman -S --noconfirm noto-fonts-emoji adobe-source-code-pro-fonts adobe-source-serif-fonts adobe-source-sans-fonts ttf-inconsolata
sudo mkdir "$HOME"/.config/fontconfig
echo -e '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE fontconfig SYSTEM "fonts.dtd">\n<fontconfig>\n
<!-- ## serif ## -->\n  <alias>\n               <family>serif</family>\n                <prefer>\n                      <family>Noto Serif</family>\n                     <family>emoji</family>\n                        <family>Liberation Serif</family>\n
        <family>Nimbus Roman</family>\n                 <family>DejaVu Serif</family>\n         </prefer>\n     </alias>\n      <!-- ## sans-serif ## -->\n       <alias>\n               <family>sans-serif</family>\n           <prefer>\n                      <family>Noto Sans</family>\n                      <family>emoji</family>\n                        <family>Liberation Sans</family>\n                        <family>Nimbus Sans</family>\n                  <family>DejaVu Sans</family>\n          </prefer>\n     </alias>\n</fontconfig>' > /home/$USER/.config/fontconfig/fonts.conf


echo -n "Instalações globais"
# Pacotes Base
sudo pacman -S --noconfirm base base-devel linux-firmware sof-firmware networkmanager network-manager-applet grub grub-btrfs btrfs-progs efibootmgr net-tools xf86-video-ati ffmpegthumbnailer ffmpegthumbs alsa-utils alsa-firmware a52dec faac flac jasper lame libdca libmpeg2 libtheora libvorbis libxv wavpack x264 x265 xvidcore xorg xorg-server xorg-apps xorg-xinit xorg-drivers xdg-desktop-portal xdg-desktop-portal-gtk texinfo
# Sistema
sudo pacman -S --noconfirm dmenu clipmenu dunst polybar feh peek picom nitrogen sxhkd wmname rofi reflector flatpak neofetch htop ffmpeg gst-plugins-ugly gst-plugins-good gst-plugins-base gst-plugins-bad gst-libav gstreamer ufw gufw libinput thunar
echo -n "Finalizado"
# Internet
echo -n "Instalando Ambiente de Inteenet"
sudo pacman -S --noconfirm vivaldi vivaldi-ffmpeg-codecs firefox transmission-gtk
echo -n "Finalizado"
# Cliente Mensageiros
echo -n "Instalando Clientes de Mensageria"
sudo pacman -S --noconfirm discord telegram-desktop
echo -n "Finalizado"
# Jogos
echo -n "Instalando setup para jogos"
sudo pacman -S --noconfirm steam mangohud lib32-mangohud lutris
echo -n "Finalizado"
# Editor de texto
echo -n "Instalando editor de texto"
sudo pacman -S --noconfirm emacs emacs-lua-mode
echo -n "Finalizado"
# Multimidia
echo -n "Instalando ferramentas de multimidia"
sudo pacman -S --noconfirm obs-studio yt-dlp audacious vlc cheese libcheese
echo -n "Finalizado"
# Ferramentas Gráficas
echo -n "Instalando ambiente de design"
sudo pacman -S --noconfirm krita gimp inkscape blender
echo -n "Finalizado"
# Suíte de Escritório
echo -n "Instalando utilitarios de escritório"
sudo pacman -S --noconfirm okular
echo -n "Finalizado"
# Suíte compactação de arquivos
echo -n "Instalando utilitarios de empacotamento"
sudo pacman -S --noconfirm ark unzip
echo -n "Finalizado"
# Desenvolvimento
echo -n "Instalando Ambiente de Desenvolvimento"
sudo pacman -S --noconfirm git github-cli nodejs npm yarn pnpm pm2 apache php php-apache phpmyadmin sqlite lib32-sqlite python python-pip docker jdk-openjdk
echo -n "Finalizado"
# Utiliarios
echo -n "Instalando utiliarios do sistema"
sudo pacman -S --noconfirm vim kitty alacritty zsh starship conky flameshot copyq
# Download oh my zsh +  plugins
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd "$HOME"/.oh-my-zsh/plugins
git clone https://github.com/zsh-users/zsh-completions.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions.git
cd "$HOME"
echo -n "Finalizado"
# Apps do usuário do AUR
mkdir "$HOME"/aur && cd ~/aur
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -sic --skippgpcheck
cd ..
git clone https://aur.archlinux.org/ncurses5-compat-libs.git
cd ncurses5-compat-libs && makepkg -sic --skippgpcheck
cd ..
git clone https://aur.archlinux.org/local-by-flywheel-bin.git
cd local-by-flywheel-bin && makepkg -sic --skippgpcheck
cd "$HOME"

yay -Syu onlyoffice-bin spotify visual-studio-code-bin mockoon-bin obsidian-bin postman-bin
# Configurações BSPWM
echo -n "Git config e clonando repo"
git config --global user.name "afiovinicius" && git config --global user.email "afiovinicius@gmail.com"
repo_url="https://github.com/afiovinicius/stp-bspwm"
repo_dir="$HOME/.stp-bspwm"

git clone --depth=1 "$repo_url" "$repo_dir"
echo -n "Clonagem foi um sucesso"
# Configurandoa arquivos
echo -n "Modelando os arquivos"
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
echo -n "Setup completo"
reboot
