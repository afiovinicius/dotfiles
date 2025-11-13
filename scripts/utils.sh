#!/bin/sh

#~~|¨Variables¨|~~#
BANNER="
  ___    __  _                ___              _     
 / _ \  / _|(_)              / _ \            | |    
/ /_\ \| |_  _   ___        / /_\ \ _ __  ___ | |__  
|  _  ||  _|| | / _ \   __  |  _  || '__|/ __|| '_ \ 
| | | || |  | || (_) | |__| | | | || |  | (__ | | | |
\_| |_/|_|  |_| \___/       \_| |_/|_|   \___||_| |_|
"

PKGS_DEFAULT=(
  "base" # Pacotes essenciais para o sistema Arch Linux.
  "base-devel" # Ferramentas de desenvolvimento básicas, como `make` e `gcc`.
  "multilib-devel" # Ferramentas para desenvolvimento de aplicativos 32 bits em sistemas 64 bits.
  "linux-firmware" # Firmware necessário para vários dispositivos de hardware.
  "sof-firmware" # Firmware para dispositivos de áudio habilitados para Sound Open Firmware (SOF).
  "networkmanager" # Gerenciador de conexões de rede.
  "network-manager-applet" # Interface gráfica para NetworkManager no tray.
  "btrfs-progs" # Ferramentas para gerenciar sistemas de arquivos Btrfs.
  "efibootmgr" # Ferramenta para gerenciar entradas de inicialização EFI.
  "net-tools" # Ferramentas de rede como `ifconfig` e `netstat`.
  "xf86-video-ati" # Driver para placas gráficas AMD/ATI no Xorg.
  "mesa" # Implementação de gráficos 3D de código aberto.
  "ffmpeg" # Ferramenta para manipular e converter arquivos de áudio/vídeo.
  "ffmpegthumbnailer" # Gera miniaturas de arquivos de vídeo.
  "ffmpegthumbs" # Integração do ffmpegthumbnailer com o KDE.
  "alsa-utils" # Ferramentas para controlar dispositivos de áudio ALSA.
  "alsa-firmware" # Firmware adicional para dispositivos de áudio ALSA.
  "a52dec" # Decodificador para o formato de áudio AC-3.
  "faac" # Codificador para o formato de áudio AAC.
  "flac" # Ferramentas e biblioteca para o formato de áudio FLAC.
  "jasper" # Biblioteca para manipulação do formato de imagem JPEG-2000.
  "lame" # Codificador de MP3 de alta qualidade.
  "libdca" # Biblioteca para decodificar fluxos de áudio DTS.
  "libmpeg2" # Biblioteca para decodificação de fluxos MPEG-2.
  "libtheora" # Biblioteca para manipulação do formato de vídeo Theora.
  "libvorbis" # Biblioteca para manipulação do formato de áudio Vorbis.
  "libxv" # Suporte ao XVideo no X11.
  "wavpack" # Ferramentas para manipular o formato de áudio WavPack.
  "x264" # Codificador para o formato de vídeo H.264.
  "x265" # Codificador para o formato de vídeo H.265.
  "xvidcore" # Biblioteca para o formato de vídeo Xvid (MPEG-4).
  "gstreamer" # Framework multimídia para processamento de áudio/vídeo.
  "gst-plugins-ugly" # Plugins GStreamer com licenciamento restritivo.
  "gst-plugins-good" # Plugins GStreamer de alta qualidade e bem suportados.
  "gst-plugins-base" # Plugins GStreamer essenciais para funcionalidades básicas.
  "gst-plugins-bad" # Plugins GStreamer experimentais ou menos suportados.
  "gst-libav" # Suporte a vários formatos de áudio/vídeo em GStreamer via libav.
  "bluez" # Suporte a dispositivos Bluetooth.
  "bluez-utils" # Ferramentas adicionais para dispositivos Bluetooth.
  "nano" # Editor de texto simples e fácil de usar.
  "libinput" # Biblioteca para lidar com dispositivos de entrada, como touchpads.
  "gvfs" # Abstração para acessar diferentes sistemas de arquivos.
  "lighttpd" # Servidor web leve e rápido.
  "reflector" # Atualiza automaticamente os espelhos de pacotes para os mais rápidos.
  "wget" # Ferramenta de linha de comando para download de arquivos via HTTP/FTP.
  "dosfstools" # Ferramentas para manipular sistemas de arquivos FAT.
  "cpupower" # Ferramentas para gerenciamento de energia do processador.
  "lm_sensors" # Monitoramento de temperatura, tensão e ventiladores de hardware.
  "pacman-contrib" # Exclui todas as versões em cache de pacotes instalados.
  "fwupd" # Daemon simples para permitir que atualize o firmware em sua máquina local.
  # "smartmontool" # CLI para monitorar S.M.A.R.T.
  "sysstat" # Monitoramento em tempo real do SSD.
  "gsmartcontrol" # Interface para monitoramento SMART baseado no smartmontool.
)

DRIVERS_AMD=(
  "xf86-video-amdgpu" # Driver de código aberto para GPUs AMD mais recentes no Xorg.
  "vulkan-radeon" # Implementação Vulkan para GPUs AMD usando o driver Mesa.
  "vulkan-swrast" # Renderização Vulkan em software via llvmpipe (fallback).
  "amdvlk" # Driver Vulkan oficial da AMD para GPUs Radeon.
  "mesa-vdpau" # Suporte para aceleração de vídeo VDPAU em GPUs AMD.
  "amd-ucode" # Firmware para CPUs e GPUs AMD.
)

DRIVERS_INTEL=(
  "xf86-video-intel" # Driver para GPUs Intel integradas no Xorg.
  "vulkan-intel" # Implementação Vulkan para GPUs Intel via Mesa.
)

XORG=(
  "xorg" # Meta-pacote para instalar o sistema Xorg completo.
  "xorg-server" # Servidor de exibição X (necessário para interfaces gráficas baseadas em X11).
  "xorg-apps" # Conjunto de utilitários e ferramentas para Xorg.
  "xdg-desktop-portal" # Interface entre aplicativos e ambientes desktop (necessária para sandboxing e Wayland).
)

WAYLAND=(
  "wayland" # Protocolo de exibição de próxima geração, sucessor do X11.
  "xorg-xwayland" # Compatibilidade do Wayland com aplicativos X11.
  "wayland-protocols" # Conjunto de protocolos de extensão para Wayland.
  "qt6-wayland" # Suporte Wayland para aplicativos Qt6.
)

ACCESSORIES=(
  "flameshot" # Ferramenta avançada para capturas de tela.
)

DEVELOPMENT=(
  "git" # Sistema de controle de versão distribuído.
  "github-cli" # Ferramenta de linha de comando para interagir com o GitHub.
  "nodejs" # Plataforma para execução de código JavaScript no backend.
  "npm" # Gerenciador de pacotes para Node.js.
  "yarn" # Alternativa rápida e confiável ao npm.
  "pnpm" # Gerenciador de pacotes eficiente para Node.js.
  "pm2" # Gerenciador de processos para aplicações Node.js.
  "sqlite" # Banco de dados leve e embutido.
  "postgresql" # Sistema de gerenciamento de banco de dados relacional.
  "postgresql-libs" # Bibliotecas essenciais para PostgreSQL.
  "apache" # Servidor web amplamente utilizado.
  "php" # Linguagem de programação popular para desenvolvimento web.
  "php-apache" # Módulo PHP para integração com Apache.
  "phpmyadmin" # Interface gráfica para gerenciar bancos de dados MySQL/MariaDB.
  "python" # Linguagem de programação versátil e de propósito geral.
  "pyenv" # Ferramenta para gerenciar múltiplas versões do Python.
  "python-pip" # Gerenciador de pacotes oficial do Python.
  "python-pipx" # Executa pacotes Python em ambientes virtuais isolados.
  "docker" # Plataforma para criar e gerenciar contêineres.
  "docker-compose" # Ferramenta para orquestrar aplicações multicontêiner.
  "vim" # Editor de texto poderoso e configurável para o terminal.
  "neovim" # Fork modernizado do Vim com melhorias.
  "zsh" # Shell interativo poderoso e personalizável.
  "alacritty" # Terminal GPU acelerado, leve e rápido.
  "zed" # IDE para desenvolvimento web.
)

GAMES=(
  "steam" # Plataforma de distribuição de jogos e gerenciamento de biblioteca.
  "lutris" # Plataforma para gerenciar jogos no Linux.
  "mangohud" # Overlay para monitorar desempenho em jogos.
  "wine-staging" # Versão experimental do Wine com patches adicionais.
  "wine-mono" # Implementação do .NET no Wine.
  "wine-gecko" # Substituto para o Internet Explorer no Wine.
  "winetricks" # Ferramenta para instalar bibliotecas e configurações no Wine.
  "zenity" # Ferramenta para criar caixas de diálogo gráficas via terminal.
  "vulkan-icd-loader" # Loader para implementações Vulkan.
  "vkd3d" # Tradução de Direct3D 12 para Vulkan.
  "openssl" # Biblioteca para criptografia e comunicações seguras.
  "gnutls" # Implementação de segurança de rede e TLS.
  "openal" # Biblioteca para áudio posicional em 3D.
  "libpulse" # Biblioteca para integração com PulseAudio.
  "mpg123" # Ferramenta para decodificar e tocar arquivos MP3.
  "gamemode" # Ferramenta para otimizar desempenho de jogos.
  "lib32-gamemode" # Versão de 32 bits do GameMode para compatibilidade.
  "giflib" # Biblioteca para trabalhar com imagens GIF.
  "libpng" # Biblioteca para manipular imagens PNG.
  "libldap" # Biblioteca para protocolo de acesso a diretórios LDAP.
  "v4l-utils" # Ferramentas para dispositivos de captura de vídeo (V4L2).
  "libgpg-error" # Biblioteca para relatórios de erros no GnuPG.
  "alsa-plugins" # Plugins adicionais para ALSA (Advanced Linux Sound Architecture).
  "alsa-lib" # Biblioteca principal do sistema ALSA.
  "libjpeg-turbo" # Biblioteca para manipular imagens JPEG.
  "libxcomposite" # Biblioteca para composição de janelas em Xorg.
  "libxinerama" # Suporte para múltiplos monitores em Xorg.
  "libgcrypt" # Biblioteca para criptografia usada por GnuPG.
  "ocl-icd" # Implementação ICD para OpenCL.
  "pocl" # Implementação de OpenCL portátil.
  "opencl-headers" # Cabeçalhos padrão para desenvolvimento com OpenCL.
  "libxslt" # Biblioteca para transformações XSLT em XML.
  "libva" # Biblioteca para aceleração de vídeo via hardware.
  "gtk3" # Toolkit para criar interfaces gráficas.
  "gst-plugins-base-libs" # Bibliotecas base para o GStreamer.
  "libxcrypt" # Biblioteca para autenticação e funções de criptografia.
  "libxcrypt-compat" # Compatibilidade com versões antigas de libxcrypt.
  "glibc" # Biblioteca padrão C para sistemas Linux.
  "rocm-opencl-runtime" # Runtime OpenCL para GPUs AMD com ROCm.
  "composable-kernel" # Kernel para computação em GPUs AMD.
  "lib32-amdvlk" # Versão de 32 bits do driver Vulkan oficial da AMD.
  "lib32-vulkan-radeon" # Versão de 32 bits do driver Vulkan Mesa para AMD.
  "nvidia-prime" # Para rodar drivers da NVIDIA em offload.
  "vulkan-mesa-layers" # Para rodar jogos com placa dedicada NVIDIA.
  "lib32-vulkan-mesa-layers" # Para rodar jogos com placa dedicada NVIDIA em 32bit.
)

GRAPHICS=(
  "gimp" # Editor de imagens avançado e de código aberto.
  "inkscape" # Editor de gráficos vetoriais em SVG.
  "blender" # Software para modelagem 3D.
)

IOT=(
  "firefox" # Navegador web popular e de código aberto.
  "qbittorrent" # Cliente leve e funcional para torrent.
  "discord" # Plataforma de comunicação por texto, voz e vídeo.
  "telegram-desktop" # Aplicativo oficial do Telegram para desktops.
)

MEDIA=(
  "obs-studio" # Software de gravação e streaming de vídeo.
  "yt-dlp" # Ferramenta para baixar vídeos de várias plataformas.
  "audacious" # Leitor de música leve e focado em simplicidade.
  "vlc" # Reprodutor multimídia versátil e de código aberto.
  "vlc-plugins-all" # Conjunto completo de plugins para o VLC.
  "vlc-plugins-extra" # Plugins adicionais para o VLC.
)

OFFICE=(
  # "libreoffice" # Suíte de escritório completa e de código aberto.
)

SETTIGNS=(
  "unzip" # Ferramenta para extrair arquivos ZIP.
  "ark" # Gerenciador gráfico de arquivos compactados.
  "gzip" # Utilitário para compactação de arquivos.
  "zip" # Ferramenta para criar arquivos ZIP.
  "p7zip" # Suporte para arquivos 7z e outros formatos.
  "ufw" # Firewall simples e fácil de usar.
  "gufw" # Interface gráfica para gerenciar o UFW.
  "pcmanfm" # Gerenciador de arquivos leve e rápido.
  "fastfetch" # Exibe informações do sistema no terminal.
  "htop" # Monitor de recursos interativo e avançado para o terminal.
  "seahorse" # Gerenciador de chaves e senhas no GNOME.
  "bleachbit" # Ferramenta para limpeza e liberação de espaço em disco.
  "fontconfig" # Utilitário para configurar e gerenciar fontes no Linux.
)

PKGS_AUR=(
  "note-liber-bin" # App de anotações rápido
  "brave-bin" # Navegador focado em privacidade e desempenho (versão binária).
  "spotify" # Cliente oficial do Spotify para streaming de música.
  "visual-studio-code-bin" # Editor de código da Microsoft (versão binária).
  # "mockoon-bin" # Simulador de APIs local para desenvolvedores (versão binária).
  # "obsidian-bin" # Aplicativo de notas baseado em Markdown (comentado na lista).
  "postman-bin" # Ferramenta para desenvolvimento e teste de APIs (versão binária).
  # "local-by-flywheel-bin" # Ambiente de desenvolvimento WordPress local (comentado na lista).
  # "wps-office" # Suíte de escritório.
  "stripe-cli" # CLI do Stripe.
  "slack-desktop" # Para para comunicação de times de desenvolvimento.
  "beekeeper-studio-bin" # Interface para gerenciamento de banco de dados.
  "howdy" # Windows Hello para Linux sensor ir.
)

PKGS_KDE=(
  "bluedevil" # Ferramentas para gerenciar dispositivos Bluetooth no KDE.
  "kvantum" # Motor de temas para Qt que permite personalização avançada.
  "krita" # Software de pintura digital e ilustração.
  "discover" # Gerenciador gráfico de pacotes do KDE.
  "kwrite" # Editor de texto simples baseado no KTextEditor.
  "kpackage" # Ferramenta para gerenciar pacotes no KDE.
  "qt5-tools" # Ferramentas de desenvolvimento para aplicações Qt5.
  "oxygen5" # Tema de ícones clássico do KDE.
  "colord-kde" # Integração do gerenciador de cores no KDE.
  "dolphin" # Gerenciador de arquivos padrão do KDE.
  "dolphin-plugins" # Plugins adicionais para o Dolphin.
  "filelight" # Visualizador gráfico de uso de disco.
  "gwenview" # Visualizador de imagens leve do KDE.
  "isoimagewriter" # Ferramenta para gravar imagens ISO em dispositivos USB.
  "kamera" # Integração com câmeras digitais no KDE.
  "kamoso" # Aplicativo para capturar fotos e vídeos de webcams.
  "kate" # Editor de texto avançado com suporte a múltiplas linguagens.
  "kcalc" # Calculadora gráfica do KDE.
  "kcolorchooser" # Ferramenta para selecionar e gerenciar cores.
  "kde-dev-scripts" # Scripts para desenvolvedores no ambiente KDE.
  "kde-dev-utils" # Conjunto de utilitários para desenvolvimento no KDE.
  "kdegraphics-thumbnailers" # Geradores de miniaturas para arquivos gráficos no KDE.
  "kdenetwork-filesharing" # Ferramentas para compartilhamento de arquivos em rede.
  "kdenlive" # Editor de vídeos não-linear avançado.
  "kdepim-addons" # Add-ons para aplicativos de gerenciamento de informações pessoais no KDE.
  "kdesdk-thumbnailers" # Miniaturas adicionais para arquivos específicos do KDE.
  "keditbookmarks" # Ferramenta para gerenciar favoritos no KDE.
  "kfind" # Ferramenta de busca de arquivos no KDE.
  "kgpg" # Interface gráfica para gerenciar chaves GPG.
  "kmousetool" # Ferramenta para assistência ao uso do mouse.
  "kontrast" # Verificador de contraste de cores para acessibilidade.
  "korganizer" # Calendário e organizador pessoal do KDE.
  "kwalletmanager" # Gerenciador de senhas do KDE.
  "signon-kwallet-extension" # Integração de gerenciamento de senhas do KDE com o SignOn.
  "kweather" # Aplicativo de previsão do tempo para o KDE.
  "okular" # Visualizador universal de documentos no KDE.
  "partitionmanager" # Ferramenta para gerenciar partições de disco.
  "skanlite" # Ferramenta leve para digitalização de imagens.
  "skanpage" # Aplicativo para digitalização moderna no KDE.
  "print-manager" # Gerenciador gráfico de impressoras no KDE.
  "cups" # Sistema de impressão comum Unix.
  "system-config-printer" # Ferramenta gráfica para configurar impressoras.
  "powerdevil" # Gerenciador de energia do KDE.
  "kscreen" # Ferramenta para gerenciar configurações de monitores no KDE.
  "colord-kde" # Integração com o sistema de gerenciamento de cores Colord no KDE.
)

#~~|¨Colors¨|~~#
COLOR_RESET="\e[0m"
COLOR_BLACK="\e[30m"
COLOR_RED="\e[31m"
COLOR_GREEN="\e[32m"
COLOR_YELLOW="\e[33m"
COLOR_PURPLE="\e[34m"
COLOR_CYAN="\e[36m"
COLOR_WHITE="\e[37m"

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
   
