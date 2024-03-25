#!/bin/sh


read -n1 -rep "Deseja iniciar instalação do kde? (s/n)" INIT
if [[ $INIT =~ ^[Ss]$ ]]; then
  ##
  # Ajustando SWAP
  ##
  printf "Configurando SWAP\n"
  sudo sysctl -w vm.swappiness=10
  sudo sysctl -a | grep -i swappiness

  ##
  # Configuração das fonts e emojis
  ##
  printf "Iniciando instalação e configuração das fonts e emojis\n"
  sudo pacman -S --noconfirm noto-fonts-emoji adobe-source-code-pro-fonts adobe-source-serif-fonts adobe-source-sans-fonts ttf-inconsolata
  mkdir $HOME/.config/fontconfig
  echo -e '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE fontconfig SYSTEM "fonts.dtd">\n<fontconfig>\n<!-- ## serif ## -->\n<alias>\n<family>serif</family>\n<prefer>\n<family>Noto Serif</family>\n<family>emoji</family>\n<family>Liberation Serif</family>\n<family>Nimbus Roman</family>\n<family>DejaVu Serif</family>\n</prefer>\n</alias>\n<!-- ## sans-serif ## -->\n<alias>\n<family>sans-serif</family>\n<prefer>\n<family>Noto Sans</family>\n<family>emoji</family>\n<family>Liberation Sans</family>\n<family>Nimbus Sans</family>\n<family>DejaVu Sans</family>\n</prefer>\n</alias>\n</fontconfig>' > $HOME/.config/fontconfig/fonts.conf

  ##
  # Sistema
  ##
  printf "Instalando ferramentas globais\n"
  sudo pacman -S --noconfirm ristretto reflector pcmanfm neofetch htop bpytop ffmpeg gst-plugins-ugly gst-plugins-good gst-plugins-base gst-plugins-bad gst-libav gstreamer ufw gufw libinput gvfs

  ##
  # Internet
  ##
  printf "Instalando ferramentas internet\n"
  sudo pacman -S --noconfirm firefox qbittorrent

  ##
  # Cliente Mensageiros
  ##
  printf "Instalando ferramentas de mensageria\n"
  sudo pacman -S --noconfirm discord telegram-desktop

  ##
  # Jogos
  ##
  printf "Instalando ferramentas para jogos\n"
  sudo pacman -S --noconfirm steam mangohud lib32-mangohud

  ##
  # Multimidia
  ##
  printf "Instalando ferramentas de multimidia\n"
  sudo pacman -S --noconfirm obs-studio yt-dlp audacious parole

  ##
  # Gráficas
  ##
  printf "Instalando ferramentas de design\n"
  sudo pacman -S --noconfirm gimp inkscape

  ##
  # Escritório
  ##
  printf "Instalando ferramentas de escritório\n"
  sudo pacman -S --noconfirm mupdf mupdf-tools

  ##
  # Compactação de arquivos
  ##
  printf "Instalando ferramentas de empacotamento\n"
  sudo pacman -S --noconfirm unzip gzip zip p7zip

  ##
  # Desenvolvimento
  ##
  printf "Instalando ferramentas de desenvolvimento\n"
  sudo pacman -S --noconfirm git github-cli nodejs npm yarn pnpm pm2 apache php php-apache phpmyadmin sqlite python python-pip docker jdk-openjdk

  ##
  # Utiliarios
  ##
  printf "Instalando ferramentas utiliarios\n"
  sudo pacman -S --noconfirm vim kitty alacritty zsh flameshot

  # Download oh my zsh +  plugins
  # sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  printf "Baixando arquivo de instalação oh my zsh\n"
  curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o $HOME/install-ohmyzsh.sh
  chmod +x install-ohmyzsh.sh
  cd $HOME/.oh-my-zsh/plugins
  git clone https://github.com/zsh-users/zsh-completions.git
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
  git clone https://github.com/zsh-users/zsh-autosuggestions.git
  cd $HOME/

  # GIT
  printf "Git config\n"
  git config --global user.name "afiovinicius" && git config --global user.email "afiovinicius@gmail.com"
  gh auth login

  ##
  # Apps do usuário do AUR
  ##
  printf "Criando pasta aur\n"
  mkdir $HOME/aur && cd $HOME/aur
  printf "Instalando yay\n"
  git clone https://aur.archlinux.org/yay.git
  cd yay && makepkg -sic --skippgpcheck
  cd $HOME
  printf "Instalando pacotes pelo yay\n"
  yay -Syu onlyoffice-bin spotify visual-studio-code-bin mockoon-bin obsidian-bin postman-bin local-by-flywheel-bin heroic-games-launcher-bin medit brave-bin
else
  exit
fi
