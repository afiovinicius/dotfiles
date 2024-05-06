#!/bin/sh

## init block ##
#~~|¨Colors¨|~~#
COLOR_RESET="\e[0m"
COLOR_BLACK="\e[30m"
COLOR_RED="\e[31m"
COLOR_GREEN="\e[32m"
COLOR_YELLOW="\e[33m"
COLOR_PURPLE="\e[34m"
COLOR_CYAN="\e[36m"
COLOR_WHITE="\e[37m"
## end block ##

## init block ##
#~~|¨Variables¨|~~#
DIR_USER="$HOME"
DIR_NAV="$PWD"
PACMAN_CONF="/etc/pacman.conf"

PKGS_DEFAULT=(
  "base" 
  "base-devel" 
  "linux-firmware" 
  "sof-firmware" 
  "networkmanager"
  "network-manager-applet"
  "btrfs-progs" 
  "efibootmgr" 
  "net-tools" 
  "xf86-video-ati" 
  "mesa" 
  "ffmpegthumbnailer" 
  "ffmpegthumbs" 
  "alsa-utils" 
  "alsa-firmware" 
  "a52dec" 
  "faac" 
  "flac" 
  "jasper" 
  "lame" 
  "libdca" 
  "libmpeg2" 
  "libtheora" 
  "libvorbis" 
  "libxv" 
  "wavpack" 
  "x264" 
  "x265" 
  "xvidcore"
  "nano"
  "ffmpeg"
  "gst-plugins-ugly"
  "gst-plugins-good" 
  "gst-plugins-base" 
  "gst-plugins-bad" 
  "gst-libav" 
  "gstreamer"
  "libinput" 
  "gvfs"
  "lighttpd"
  "reflector"
  "wget"
)

DRIVERS_AMD=(
  "xf86-video-amdgpu"
  "vulkan-radeon"
  "vulkan-swrast"
  "amdvlk" 
  "mesa-vdpau"
)

DRIVERS_INTEL=(
  "xf86-video-intel"
  "vulkan-intel" 
)

XORG=(
  "xorg" 
  "xorg-server"
  "xorg-apps"
  "xdg-desktop-portal"
)

WAYLAND=(
  "wayland"
  "xorg-xwayland"
  "wayland-protocols"
)

ACCESSORIES=(
  "flameshot"
  "kcalc"
  "kfind"
  "kcolorchooser"
  "kvantum"
)

DEVELOPMENT=(
  "git" 
  "github-cli" 
  "nodejs" 
  "npm" 
  "yarn" 
  "pnpm" 
  "pm2" 
  "sqlite" 
  "postgresql"
  "postgresql-libs" 
  "apache" 
  "php"
  "php-apache" 
  "phpmyadmin"
  "python"
  "pyenv" 
  "python-pip" 
  "python-pipx"
  "python-poetry"
  "docker"
  "docker-compose"
  "jdk-openjdk"
  "kate"
  "vim"
  "neovim"
  "zsh" 
  "alacritty"
)

GAMES=(
  "steam"
  "lutris"
  "mangohud"
  "wine-staging"
  "wine-mono" 
  "wine-gecko" 
  "winetricks"
  "zenity"
  "vulkan-icd-loader"
  "vkd3d"
  "openssl" 
  "gnutls"
  "openal" 
  "libpulse" 
  "mpg123" 
  "gamemode"
  "lib32-gamemode"
  "giflib"  
  "libpng"  
  "libldap" 
  "v4l-utils" 
  "libgpg-error"
  "alsa-plugins" 
  "alsa-lib" 
  "libjpeg-turbo"
  "libxcomposite"
  "libxinerama" 
  "libgcrypt" 
  "ocl-icd" 
  "libxslt"
  "libva" 
  "gtk3"
  "gst-plugins-base-libs" 
  "libxcrypt"
  "libxcrypt-compat" 
  "glibc"
)

GRAPHICS=(
  "gimp" 
  "inkscape" 
  "krita"
  "gwenview" 
)

IOT=(
  "firefox" 
  "qbittorrent"
  "discord" 
  "telegram-desktop"
)

MEDIA=(
  "obs-studio" 
  "yt-dlp" 
  "audacious"
  "vlc" 
  "kamoso" 
  "kdenlive"
)

OFFICE=(
  "okular" 
  "skanlite" 
  "korganizer"  
)

SETTIGNS=(
  "unzip"
  "ark"
  "gzip" 
  "zip"
  "p7zip"
  "partitionmanager"
  "discover"
  "dolphin"
  "knotes"
  "kwrite"
  "ufw" 
  "gufw"
  "pcmanfm" 
  "neofetch" 
  "htop" 
  "seahorse"
  "bleachbit"
  "fontconfig"
)

PKGS_AUR=(
  "brave-bin" 
  "onlyoffice-bin"
  "spotify"
  "protonup-qt"
  "visual-studio-code-bin" 
  "mockoon-bin" 
  "obsidian-bin" 
  "postman-bin" 
  "local-by-flywheel-bin"
)
## end block ##

## init block ##
#~~|¨Functions¨|~~#
pf() {
  local TIME="\e[1m$COLOR_PURPLE$(date +"%H:%M:%S")$COLOR_RESET"
  local MESSAGE="$1"
  local COLOR="$2"

  case "$COLOR" in
    "error")
      COLOR_CODE=$COLOR_RED;;
    "warn")
      COLOR_CODE=$COLOR_YELLOW;;
    "success")
      COLOR_CODE=$COLOR_GREEN;;
    *)
      COLOR_CODE=$COLOR_CYAN;; 
  esac

  printf "\n$TIME - $COLOR_CODE$MESSAGE$COLOR_RESET\n"
}

plist() {
  local COUNT=1
  for list in $@; do
    printf "\e[1m$COLOR_CYAN[$COUNT]: ${list##*/}$COLOR_RESET\n"
    ((COUNT++))
  done
}

pkg_i() {
  local PKG=$@

  while true; do
    read -n1 -rep "Deseja continuar com a instação? (s/n)" RES
    if [[ $RES == [Ss] ]]; then
      pf "Instalando..." "warn"
      sudo pacman -S --needed --noconfirm $PKG
      pf "Instalação concluída!" "success"
      break
    elif [[ $RES == [Nn] ]]; then
      break
    else
      pf "Opção inválida. Por favor digite novamente." "error"
    fi
  done
}

run_cmd_valid() {
  local COMMAND_RUN=$1
  local COMMAND_M=$2

  if $COMMAND_RUN; then
    pf "$COMMAND_M concluído!" "success"
  else
      pf "Falha em $COMMAND_M." "error"
  fi
}
## end block ##
