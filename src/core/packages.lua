--- ============================================================================
--- ORZHOV ARCH - PACKAGE REGISTRY & ECOSYSTEM
--- ============================================================================
--- Definição centralizada de todos os pacotes, organizados por categoria.
--- Cada pacote contém: nome, descrição e metadados para facilitar
--- seleção interativa, validação e instalação.
---
--- ESTRUTURA:
---   packages.CATEGORY = {
---     { name = "pacote", desc = "Descrição curta" },
---     ...
---   }
--- ============================================================================

local packages = {}

--- ============================================================================
--- PACOTES ESSENCIAIS / BASE DO SISTEMA
--- ============================================================================

packages.DEFAULT = {
	{ name = "base", desc = "Pacotes essenciais para o sistema Arch Linux" },
	{ name = "base-devel", desc = "Ferramentas de desenvolvimento básicas (make, gcc)" },
	{ name = "bluez", desc = "Pilha Bluetooth oficial para Linux" },
	{ name = "bluez-tools", desc = "Ferramentas adicionais para Bluetooth" },
	{ name = "bluez-utils", desc = "Utilitários adicionais para Bluetooth" },
	{ name = "multilib-devel", desc = "Ferramentas para apps 32 bits em sistemas 64 bits" },
	{ name = "linux-firmware", desc = "Firmware necessário para vários dispositivos" },
	{ name = "sof-firmware", desc = "Firmware para dispositivos de áudio (Sound Open Firmware)" },
	{ name = "networkmanager", desc = "Gerenciador de conexões de rede" },
	{ name = "network-manager-applet", desc = "Applet visual para NetworkManager" },
	{ name = "btrfs-progs", desc = "Ferramentas para gerenciar Btrfs" },
	{ name = "efibootmgr", desc = "Ferramenta para gerenciar entradas UEFI/EFI" },
	{ name = "net-tools", desc = "Ferramentas de rede (ifconfig, netstat)" },
	{ name = "mesa", desc = "Implementação de gráficos 3D open-source" },
	{ name = "zram-generator", desc = "Gerador systemd para ZRAM comprimida" },
	{ name = "reflector", desc = "Atualiza mirrors para os mais rápidos" },
	{ name = "wget", desc = "Download de arquivos via HTTP/FTP" },
	{ name = "curl", desc = "Transferência de dados via URLs" },
	{ name = "dosfstools", desc = "Ferramentas para manipular FAT" },
	{ name = "cpupower", desc = "Gerenciamento de energia da CPU" },
	{ name = "lm_sensors", desc = "Monitoramento de temperatura/ventoinhas" },
	{ name = "power-profiles-daemon", desc = "Daemon para perfis de energia" },
	{ name = "pacman-contrib", desc = "Scripts úteis para Pacman (paccache)" },
	{ name = "fwupd", desc = "Daemon para atualizar firmware de dispositivos" },
	{ name = "irqbalance", desc = "Distribui interrupções entre cores da CPU" },
	{ name = "sysstat", desc = "Monitoramento I/O em tempo real (iostat, sar)" },
	{ name = "gsmartcontrol", desc = "Interface para monitoramento S.M.A.R.T. de discos" },
	{ name = "fuse2", desc = "FUSE v2 para filesystems customizados" },
	{ name = "ntfs-3g", desc = "NTFS FUSE driver" },
	{ name = "zlib", desc = "Biblioteca de compressão de dados" },
	{ name = "xz", desc = "Ferramenta de compressão com alta taxa" },
	{ name = "lcms2", desc = "Gerenciamento de cores e perfis ICC" },
	{ name = "openssl", desc = "Biblioteca para criptografia TLS/SSL" },
	{ name = "gnutls", desc = "Implementação de TLS/SSL alternativa" },
	{ name = "util-linux", desc = "Utilitários básicos do Linux" },
	{ name = "gvfs", desc = "Abstração para acessar diferentes sistemas de arquivos" },
	{ name = "exfatprogs", desc = "Utilitários do sistema de arquivos exFAT para o driver exFAT" },
	-- { name = "tk", desc = "Toolkit para criar interfaces gráficas com Tcl" },
	{ name = "libinput", desc = "Biblioteca para lidar com dispositivos de entrada, como touchpads." },
	-- { name = "systemdgenie", desc = "Utilitário de gerenciamento Systemd" },
	-- { name = "ascii", desc = "Conversor de várias representações de bytes e a tabela de caracteres ASCII" },
	{ name = "sddm", desc = "Gerenciador de exibição X11 e Wayland baseado em QML" },
	{ name = "polkit", desc = "Framework controle privilégios" },
	{ name = "polkit-qt6", desc = "API do PolicyKit para Qt6" },
	{ name = "xdg-desktop-portal", desc = "Interface sandbox/Wayland para apps" },
}

--- ============================================================================
--- SUPORTE A ÁUDIO E MULTIMÍDIA (CODECS & PLUGINS)
--- ============================================================================

packages.MULTIMEDIA_BASE = {
	{ name = "ffmpeg", desc = "Codec/converter universal para áudio/vídeo" },
	{ name = "ffmpegthumbnailer", desc = "Gera miniaturas de vídeos" },
	{ name = "alsa-utils", desc = "Ferramentas para controlar ALSA" },
	{ name = "alsa-firmware", desc = "Firmware adicional para ALSA" },
	{ name = "a52dec", desc = "Decodificador de áudio ATSC A/52 (AC-3)" },
	{ name = "faac", desc = "Codificador de áudio AAC" },
	{ name = "flac", desc = "Ferramentas para áudio FLAC lossless" },
	{ name = "jasper", desc = "Biblioteca para imagens JPEG-2000" },
	{ name = "lame", desc = "Codificador MP3 de alta qualidade" },
	{ name = "libdca", desc = "Decodificar fluxos de áudio DTS" },
	{ name = "libmpeg2", desc = "Decodificação de MPEG-2" },
	{ name = "libtheora", desc = "Manipulação de vídeo Theora" },
	{ name = "libvorbis", desc = "Manipulação de áudio Vorbis" },
	{ name = "libxv", desc = "Suporte XVideo no X11" },
	{ name = "wavpack", desc = "Ferramentas para áudio WavPack" },
	{ name = "x264", desc = "Codificador H.264/AVC" },
	{ name = "x265", desc = "Codificador H.265/HEVC" },
	{ name = "xvidcore", desc = "Codec de vídeo Xvid (MPEG-4)" },
	{ name = "gstreamer", desc = "Framework multimídia para audio/vídeo" },
	{ name = "gst-plugins-base", desc = "Plugins GStreamer essenciais" },
	{ name = "gst-plugins-good", desc = "Plugins GStreamer de qualidade" },
	{ name = "gst-plugins-bad", desc = "Plugins GStreamer experimentais" },
	{ name = "gst-plugins-ugly", desc = "Plugins GStreamer com restrições" },
	{ name = "gst-plugin-pipewire", desc = "Backend PipeWire para GStreamer" },
	{ name = "gst-plugin-onnx", desc = "Inferência de IA com ONNX" },
	{ name = "gst-plugin-opencv", desc = "Processamento de imagem/visão" },
	{ name = "gst-libav", desc = "Suporte a vários formatos via libav" },
	{ name = "gst-devtools", desc = "Ferramentas de desenvolvimento GStreamer" },
	{ name = "v4l-utils", desc = "Ferramentas para dispositivos de captura de vídeo (V4L2)" },
}

--- ============================================================================
--- ÁUDIO PROFISSIONAL & BLUETOOTH
--- ============================================================================

packages.AUDIO = {
	{ name = "pipewire", desc = "Servidor de multimídia de baixa latência" },
	{ name = "pipewire-pulse", desc = "Compatibilidade PulseAudio com PipeWire" },
	{ name = "pipewire-jack", desc = "Compatibilidade JACK com PipeWire" },
	{ name = "wireplumber", desc = "Gerenciador de sessão para PipeWire" },
}

--- ============================================================================
--- FONTES E TIPOGRAFIA
--- ============================================================================

packages.FONTS = {
	{ name = "fontconfig", desc = "Utilitário para configurar e gerenciar fontes no Linux" },
	{ name = "noto-fonts", desc = "Família Noto com suporte a múltiplos idiomas" },
	{ name = "noto-fonts-emoji", desc = "Fonte Noto com suporte a Emojis" },
	{ name = "ttf-jetbrains-mono-nerd", desc = "JetBrains Mono Monospaced com Nerd Font" },
	{ name = "ttf-nerd-fonts-symbols", desc = "Símbolos Nerd Font (completo)" },
	{ name = "ttf-nerd-fonts-symbols-common", desc = "Símbolos Nerd Font (comum)" },
	{ name = "ttf-nerd-fonts-symbols-mono", desc = "Símbolos Nerd Font (mono)" },
	{ name = "adobe-source-code-pro-fonts", desc = "Source Code Pro para código" },
	{ name = "adobe-source-serif-fonts", desc = "Source Serif Pro" },
	{ name = "adobe-source-sans-fonts", desc = "Source Sans Pro" },
}

--- ============================================================================
--- DRIVERS DE CPU
--- ============================================================================

packages.CPU_DRIVERS = {
	AMD = {
		{ name = "amd-ucode", desc = "Microcode/Firmware para CPUs AMD" },
		{ name = "vulkan-swrast", desc = "Renderização Vulkan via llvmpipe" },
	},
	INTEL = {
		{ name = "intel-ucode", desc = "Microcode/Firmware para CPUs Intel" },
	},
}

--- ============================================================================
--- DRIVERS DE GPU
--- ============================================================================

packages.GPU_DRIVERS = {
	AMD = {
		{ name = "xf86-video-amdgpu", desc = "Driver open-source AMD no Xorg" },
		{ name = "xf86-video-ati", desc = "Driver legado AMD/ATI no Xorg" },
		{ name = "vulkan-radeon", desc = "API Vulkan para AMD (Mesa)" },
		{ name = "lib32-vulkan-radeon", desc = "Vulkan AMD 32-bit" },
		{ name = "rocm-opencl-runtime", desc = "Runtime OpenCL para AMD (ROCm)" },
		{ name = "composable-kernel", desc = "Kernel para computação em GPU AMD" },
	},
	INTEL = {
		{ name = "xf86-video-intel", desc = "Driver Intel iGPU no Xorg" },
		{ name = "vulkan-intel", desc = "API Vulkan para Intel (Mesa)" },
		{ name = "lib32-vulkan-intel", desc = "Vulkan Intel 32-bit" },
		{ name = "powertop", desc = "Diagnóstico de consumo de energia (Intel)" },
	},
	NVIDIA = {
		{ name = "nvidia-dkms", desc = "Driver NVIDIA (DKMS)" },
		{ name = "nvidia-open-dkms", desc = "Driver NVIDIA open-source (DKMS)" },
		{ name = "nvidia-utils", desc = "Utilitários NVIDIA" },
		{ name = "lib32-nvidia-utils", desc = "Utilitários NVIDIA para 32b" },
		{ name = "nvidia-settings", desc = "Ferramenta de configuração NVIDIA" },
		{ name = "nvidia-prime", desc = "Suporte NVIDIA Prime (offload)" },
		{ name = "vulkan-mesa-layers", desc = "Camadas Vulkan Mesa para NVIDIA" },
		{ name = "lib32-vulkan-mesa-layers", desc = "Camadas Mesa Vulkan 32-bit" },
	},
}

--- ============================================================================
--- SERVIDORES GRÁFICOS E PROTOCOLOS
--- ============================================================================

packages.DISPLAY_SERVERS = {
	XORG = {
		{ name = "xorg", desc = "Meta-pacote do sistema Xorg completo" },
		{ name = "xorg-server", desc = "Servidor de exibição X11" },
		{ name = "xorg-apps", desc = "Utilitários e ferramentas Xorg" },
		{ name = "libxcomposite", desc = "Composição de janelas Xorg" },
		{ name = "libxinerama", desc = "Suporte multi-monitor Xorg" },
	},
	WAYLAND = {
		{ name = "wayland", desc = "Protocolo de exibição Wayland" },
		{ name = "xorg-xwayland", desc = "Compatibilidade X11 no Wayland" },
		{ name = "wayland-protocols", desc = "Protocolos de extensão Wayland" },
		{ name = "qt6-wayland", desc = "Suporte Wayland para Qt6" },
		{ name = "egl-wayland", desc = "Extensão EGL para Wayland" },
		{ name = "swayidle", desc = "Daemon de gerenciamento de ociosidade para Wayland" },
	},
}

--- ============================================================================
--- AMBIENTE DE DESENVOLVIMENTO BASE
--- ============================================================================

packages.DEVELOPMENT = {
	{ name = "git", desc = "Sistema de controle de versão distribuído" },
	{ name = "github-cli", desc = "Ferramenta CLI oficial do GitHub" },
	{ name = "zsh", desc = "Shell avançado e personalizável" },
	{ name = "nano", desc = "Editor de texto simples" },
	{ name = "vim", desc = "Editor poderoso de terminal" },
	{ name = "neovim", desc = "Fork moderno do Vim com Lua nativa" },
	{ name = "tree-sitter", desc = "Parser incremental para árvores sintáticas" },
	{ name = "tree-sitter-cli", desc = "CLI para Tree-sitter" },
	{ name = "fzf", desc = "Buscador fuzzy interativo" },
	{ name = "fd", desc = "Finder moderno mais rápido que find" },
	{ name = "ripgrep", desc = "Busca de texto ultra-rápida (rg)" },
	{ name = "bat", desc = "Cat com destaque de sintaxe" },
	{ name = "eza", desc = "Ls moderno e colorido com Git" },
	{ name = "alacritty", desc = "Terminal acelerado por GPU (OpenGL)" },
	{ name = "ghostty", desc = "Terminal moderno acelerado por GPU" },
	{ name = "starship", desc = "Prompt ultra-rápido em Rust" },
	{ name = "docker", desc = "Plataforma de contêineres" },
	{ name = "docker-compose", desc = "Orquestração de contêineres" },
	{ name = "sassc", desc = "Preprocessador de CSS para C" },
	{ name = "syntax-highlighting", desc = "Realce de sintaxe para texto estruturado e código" },
}

--- ============================================================================
--- DATABASE & SERVERS
--- ============================================================================

packages.DATABASE = {
	{ name = "sqlite", desc = "Banco de dados SQL leve e embutido" },
	{ name = "postgresql", desc = "Sistema RDBMS poderoso" },
	{ name = "postgresql-libs", desc = "Bibliotecas essenciais PostgreSQL" },
	{ name = "apache", desc = "Servidor web tradicional" },
	{ name = "lighttpd", desc = "Servidor web leve e rápido" },
}

--- ============================================================================
--- PHP
--- ============================================================================

packages.PHP = {
	{ name = "php", desc = "Linguagem de programação web" },
	{ name = "php-apache", desc = "Integração PHP com Apache" },
}

--- ============================================================================
--- PYTHON & GERENCIAMENTO DE VERSÕES
--- ============================================================================

packages.PYTHON = {
	{ name = "python", desc = "Linguagem Python (versão default)" },
	{ name = "python-pip", desc = "Gerenciador de pacotes pip" },
	{ name = "python-pipx", desc = "Executa apps Python em ambientes isolados" },
	{ name = "pyenv", desc = "Gerenciador de versões Python" },
	{ name = "poetry", desc = "Gerenciador de dependências Python moderno" },
}

--- ============================================================================
--- NODE.JS & JAVASCRIPT/TYPESCRIPT
--- ============================================================================

packages.NODE = {
	{ name = "nvm", desc = "Gerenciador de versões Node.js" },
	{ name = "nodejs", desc = "Plataforma Node.js" },
	{ name = "npm", desc = "Gerenciador de pacotes Node.js" },
	{ name = "pnpm", desc = "Gerenciador de pacotes eficiente" },
	{ name = "yarn", desc = "Gerenciador de pacotes alternativo" },
	{ name = "pm2", desc = "Gerenciador de processos Node.js" },
}

--- ============================================================================
--- RUST & LINGUAGENS COMPILADAS
--- ============================================================================

packages.RUST = {
	{ name = "rustup", desc = "Gerenciador da toolchain Rust" },
	{ name = "zed", desc = "IDE de código ultra-rápida (Rust)" },
}

--- ============================================================================
--- QT FRAMEWORK
--- ============================================================================

packages.QT = {
	{ name = "quickshell", desc = "Conjunto de ferramentas flexível para QtQuick" },
	{ name = "qt6-base", desc = "Utilitários para QT 6" },
	{ name = "qt6ct", desc = "Utilitário de Configuração do Qt 6" },
	-- { name = "qt5ct", desc = "Utilitário de Configuração do Qt 5" },
	-- { name = "qt5-tools", desc = "Ferramentas desenvolvimento Qt5" },
	{ name = "qt6-declarative", desc = "Classes para as linguagens QML e JavaScript" },
	{ name = "qt6-svg", desc = "Classes para exibir o conteúdo de arquivos SVG" },
	{ name = "qt6-multimedia", desc = "Classes de funcionalidades de áudio, vídeo, rádio e câmera" },
	{ name = "qt6-imageformats", desc = "Plugins para formatos de imagem TIFF, MNG, TGA, WBMP" },
	{ name = "qt6-shadertools", desc = "Funcionalidades para o Qt Quick operar em Vulkan, Metal e Direct3D" },
}

--- ============================================================================
--- DESENVOLVIMENTO & ENGENHARIA REVERSA
--- ============================================================================

packages.ENGINEERING = {
	{ name = "go", desc = "Linguagem Go" },
	{ name = "lua", desc = "Linguagem Lua" },
	{ name = "luarocks", desc = "Gerenciador de pacotes Lua" },
	{ name = "biome", desc = "Linter/formatador de JS/TS/JSON" },
	{ name = "ghidra", desc = "Suite de engenharia reversa (NSA)" },
	{ name = "opencode", desc = "CLI de IA open-source" },
}

--- ============================================================================
--- MOBILE
--- ============================================================================

packages.MOBILE = {
	{ name = "android-tools", desc = "Ferramentas da plataforma Android" },
	{ name = "scrcpy", desc = "Exiba e controle seu dispositivo Android" },
	{ name = "waydroid", desc = "Android completo em um sistema Linux comum" },
}

--- ============================================================================
--- GAMING & CAMADAS DE TRADUÇÃO
--- https://wiki.archlinux.org/title/gaming
--- https://arch.d3sox.me/gaming/
--- ============================================================================

packages.GAMING = {
	{ name = "steam", desc = "Plataforma de distribuição de jogos" },
	{ name = "lutris", desc = "Gerenciador unificado de jogos" },
	{ name = "mangohud", desc = "HUD de monitoramento em tempo real" },
	{ name = "wine-staging", desc = "Wine com patches experimentais" },
	{ name = "wine-mono", desc = "Implementação .NET para Wine" },
	{ name = "wine-gecko", desc = "Suporte IE para Wine" },
	{ name = "winetricks", desc = "Instalador de libs/configs Wine" },
	{ name = "vkd3d", desc = "Tradução DirectX 12 para Vulkan" },
	{ name = "vulkan-icd-loader", desc = "Loader para Vulkan ICD" },
	{ name = "gamescope", desc = "Compositor Wayland isolado (Valve)" },
	{ name = "gamemode", desc = "Daemon de otimização para jogos" },
	{ name = "lib32-gamemode", desc = "GameMode 32-bit" },
	{ name = "zenity", desc = "Caixas de diálogo gráficas no terminal" },
}

--- Bibliotecas de suporte para gaming
packages.GAMING_LIBS = {
	{ name = "openal", desc = "Biblioteca de áudio posicional 3D" },
	{ name = "libpulse", desc = "Integração PulseAudio" },
	{ name = "mpg123", desc = "Decodificador e player de MP3" },
	{ name = "giflib", desc = "Biblioteca para manipular GIF" },
	{ name = "libpng", desc = "Biblioteca para PNG" },
	{ name = "libjpeg-turbo", desc = "Biblioteca JPEG otimizada" },
	{ name = "libldap", desc = "Biblioteca protocolo LDAP" },
	{ name = "libgpg-error", desc = "Biblioteca de erros GnuPG" },
	{ name = "alsa-lib", desc = "Biblioteca ALSA" },
	{ name = "alsa-plugins", desc = "Plugins adicionais ALSA" },
	{ name = "libgcrypt", desc = "Biblioteca de criptografia" },
	{ name = "ocl-icd", desc = "Implementação ICD OpenCL" },
	{ name = "pocl", desc = "Implementação OpenCL portátil" },
	{ name = "opencl-headers", desc = "Headers para desenvolvimento OpenCL" },
	{ name = "libxslt", desc = "Transformações XSLT em XML" },
	{ name = "libva", desc = "Aceleração de vídeo por hardware" },
	{ name = "gtk3", desc = "Toolkit para interfaces gráficas GTK3" },
	{ name = "gst-plugins-base-libs", desc = "Libs base GStreamer" },
	{ name = "libxcrypt", desc = "Autenticação e criptografia" },
	{ name = "libxcrypt-compat", desc = "Compatibilidade libxcrypt" },
	{ name = "glibc", desc = "Biblioteca C padrão Linux" },
	{ name = "lib32-mesa", desc = "Mesa 3D 32-bit" },
}

--- ============================================================================
--- DESIGN & GRÁFICOS
--- ============================================================================

packages.GRAPHICS = {
	{ name = "blender", desc = "Suite profissional 3D (modelo, render)" },
	{ name = "gimp", desc = "Editor raster avançado" },
	{ name = "inkscape", desc = "Editor de gráficos vetoriais SVG" },
	{ name = "krita", desc = "Aplicativo de pintura digital (KDE)" },
}

--- ============================================================================
--- INTERNET & COMUNICAÇÃO
--- ============================================================================

packages.INTERNET = {
	{ name = "firefox", desc = "Navegador web open-source" },
	{ name = "qbittorrent", desc = "Cliente torrent leve" },
	{ name = "discord", desc = "Plataforma de comunicação" },
	{ name = "telegram-desktop", desc = "App oficial Telegram" },
}

--- ============================================================================
--- MULTIMÍDIA & CONVERSÃO
--- ============================================================================

packages.MEDIA_TOOLS = {
	{ name = "obs-studio", desc = "Software de gravação/streaming" },
	{ name = "yt-dlp", desc = "Download de vídeos de plataformas" },
	{ name = "audacious", desc = "Player de música leve" },
	{ name = "vlc", desc = "Reprodutor multimídia versátil" },
	{ name = "vlc-plugins-all", desc = "Conjunto completo de plugins para o VLC" },
	{ name = "vlc-plugins-extra", desc = "Plugins adicionais para o VLC" },
	{ name = "kdenlive", desc = "Editor de vídeo não-linear (KDE)" },
	{ name = "cameractrls", desc = "Controles de câmera para Linux" },
}

--- ============================================================================
--- PRODUTIVIDADE & ESCRITÓRIO
--- ============================================================================

packages.OFFICE = {
	{ name = "libreoffice-fresh", desc = "Suite de escritório completa" },
	{ name = "okular", desc = "Visualizador universal de docs" },
}

--- ============================================================================
--- ACESSÓRIOS & UTILITÁRIOS
--- ============================================================================

packages.ACCESSORIES = {
	-- { name = "flameshot", desc = "Ferramenta avançada de screenshot" },
	{ name = "unzip", desc = "Extrator de arquivos ZIP" },
	{ name = "zip", desc = "Criador de arquivos ZIP" },
	{ name = "gzip", desc = "Compactador de arquivos" },
	{ name = "p7zip", desc = "Suporte para 7z e outros formatos" },
	{ name = "ark", desc = "Gerenciador gráfico de compactados" },
	{ name = "tree", desc = "Visualizador de diretórios em árvore" },
	{ name = "btop", desc = "Monitor de processos interativo" },
	{ name = "fastfetch", desc = "Exibidor de informações do sistema" },
	{ name = "bleachbit", desc = "Limpeza de sistema/temp" },
	{ name = "pcmanfm", desc = "Gerenciador de arquivos leve e rápido" },
	{ name = "filelight", desc = "Visualizador uso de disco" },
	{ name = "skanlite", desc = "Scanner leve para imagens" },
	{ name = "skanpage", desc = "App digitalizador moderno" },
	{ name = "print-manager", desc = "Gerenciador gráfico impressoras" },
	{ name = "cups", desc = "Sistema impressão CUPS" },
	{ name = "system-config-printer", desc = "Configurador impressoras" },
	{ name = "dolphin", desc = "Gerenciador de arquivos KDE" },
	{ name = "dolphin-plugins", desc = "Plugins adicionais Dolphin" },
	{ name = "kvantum", desc = "Motor de temas Qt avançado" },
}

--- ============================================================================
--- SEGURANÇA & FIREWALL
--- ============================================================================

packages.SECURITY = {
	{ name = "ufw", desc = "Firewall simples baseado em iptables" },
	{ name = "gufw", desc = "Interface gráfica para UFW" },
	{ name = "seahorse", desc = "Gerenciador de chaves GPG/SSH" },
	{ name = "timeshift", desc = "Utilitários para backup do sistema" },
	{ name = "snapper", desc = "Uma ferramenta para gerenciar snapshots BTRFS e LVM" },
}

--- ============================================================================
--- AMBIENTE KDE PLASMA
--- ============================================================================

packages.KDE = {
	{ name = "plasma", desc = "Ambiente de desktop do KDE" },
	{ name = "plasma-desktop", desc = "KDE Plasma Desktop" },
}

packages.KDE_EXTRA = {
	{ name = "bluedevil", desc = "Ferramentas Bluetooth no KDE" },
	{ name = "discover", desc = "Gerenciador gráfico de pacotes" },
	{ name = "kwrite", desc = "Editor de texto simples KDE" },
	{ name = "kpackage", desc = "Gerenciador de pacotes KDE" },
	{ name = "oxygen5", desc = "Tema de ícones clássico KDE" },
	{ name = "colord-kde", desc = "Integração gerenciador cores KDE" },
	{ name = "gwenview", desc = "Visualizador de imagens KDE" },
	{ name = "isoimagewriter", desc = "Gravar ISO em USB" },
	{ name = "kamera", desc = "Integração de câmeras digitais" },
	{ name = "kamoso", desc = "App captura fotos/vídeos webcam" },
	{ name = "kate", desc = "Editor avançado multi-linguagem" },
	{ name = "kcalc", desc = "Calculadora gráfica" },
	{ name = "kclock", desc = "Relógio gráfico" },
	{ name = "kcolorchooser", desc = "Seletor de cores" },
	{ name = "kde-dev-scripts", desc = "Scripts para devs KDE" },
	{ name = "kde-dev-utils", desc = "Utilitários desenvolvimento KDE" },
	{ name = "kdegraphics-thumbnailers", desc = "Miniaturas arquivos gráficos" },
	{ name = "kdenetwork-filesharing", desc = "Compartilhamento arquivos rede" },
	{ name = "kdepim-addons", desc = "Add-ons PIM (mail, calendar)" },
	{ name = "kdesdk-thumbnailers", desc = "Miniaturas extras SDK" },
	{ name = "keditbookmarks", desc = "Gerenciador de favoritos" },
	{ name = "kfind", desc = "Ferramenta busca de arquivos" },
	{ name = "kgpg", desc = "Interface gráfica GPG" },
	{ name = "kmousetool", desc = "Assistência uso mouse" },
	{ name = "kontrast", desc = "Verificador contraste cores" },
	{ name = "korganizer", desc = "Calendário e organizador pessoal" },
	{ name = "kwalletmanager", desc = "Gerenciador senhas KDE" },
	{ name = "signon-kwallet-extension", desc = "Integração KWallet/SignOn" },
	{ name = "kweather", desc = "App previsão do tempo" },
	{ name = "partitionmanager", desc = "Gerenciador de partições" },
	{ name = "powerdevil", desc = "Gerenciador energia KDE" },
	{ name = "kscreen", desc = "Configurador monitores" },
	{ name = "plasma-x11-session", desc = "Suporte sessão X11 KDE" },
	{ name = "ffmpegthumbs", desc = "Plugin ffmpegthumbnailer para KDE" },
	{ name = "polkit-kde-agent", desc = "Daemon de autenticação Polkit para o KDE" },
}

--- ============================================================================
--- AMBIENTE HYPRLAND / WAYLAND
--- ============================================================================

packages.HYPRLAND = {
	{ name = "hyprland", desc = "Tiling Wayland compositor" },
	{ name = "xdg-desktop-portal-hyprland", desc = "xdg-desktop-portal para hyprland" },
	-- { name = "xdg-desktop-portal-wlr", desc = "Back-end xdg-desktop-portal para wlroots" },
}

packages.HYPRLAND_EXTRA = {
	-- { name = "mako", desc = "Daemon de notificações Wayland" },
	{ name = "swaync", desc = "Daemon de notificações baseado em GTK" },
	{ name = "aquamarine", desc = "Gerenciador de janelas dinâmico para Wayland, inspirado no i3 e Sway" },
	{ name = "brightnessctl", desc = "Controle brilho via CLI" },
	{ name = "pamixer", desc = "Controle volume via CLI" },
	{ name = "pavucontrol", desc = "Interface para controle de volume" },
	{ name = "wf-recorder", desc = "Gravador de tela" },
	{ name = "wlr-protocols", desc = "Wayland protocols" },
	-- { name = "volumeicon", desc = "Controle de volume para system tray" },
	{ name = "playerctl", desc = "Controle players MPRIS" },
	{ name = "cliphist", desc = "Gerenciador clipboard histórico" },
	{ name = "nwg-displays", desc = "Gerenciador monitores GTK3" },
	-- { name = "nwg-look", desc = "Editor de configurações GTK" },
	-- { name = "nwg-shell", desc = "Utilitários barra/menu Wayland" },
	-- { name = "nwg-bar", desc = "Barra botões GTK3 Wlroots" },
	-- { name = "swww", desc = "Daemon para papéis de parede animados no Wayland" },
	{ name = "hyprpaper", desc = "Gerenciador wallpapers Wayland" },
	{ name = "hyprpicker", desc = "Color picker Wayland" },
	{ name = "hyprlauncher", desc = "App launcher Wayland" },
	{ name = "hyprtoolkit", desc = "Toolkit GUI desenvolvimento Wayland" },
	{ name = "hypridle", desc = "Daemon inatividade Hyprland" },
	{ name = "hyprlock", desc = "Bloqueio tela GPU-acelerado" },
	{ name = "hyprsunset", desc = "Filtro luz azul noturno" },
	{ name = "hyprpolkitagent", desc = "Daemon autenticação Polkit visual" },
	{ name = "hyprland-qt-support", desc = "Suporte apps Qt no Hyprland" },
	{ name = "hyprpwcenter", desc = "Centro controle Pipewire GUI" },
	{ name = "hyprshutdown", desc = "Utilitário shutdown/reboot GUI" },
	{ name = "hyprcursor", desc = "Configurador cursor Wayland" },
	{ name = "hyprutils", desc = "Biblioteca tipos/utils Hypr" },
	{ name = "hyprlang", desc = "Parser linguagem config Hypr" },
	{ name = "hyprshot", desc = "Utilitário de captura de tela Hyprland" },
	{ name = "grim", desc = "Utilitário de captura de tela Hyprland" },
	{ name = "hyprwayland-scanner", desc = "Scanner protocolo Wayland" },
	{ name = "hyprgraphics", desc = "Utilidades gráficas Hypr" },
	{ name = "hyprland-guiutils", desc = "Utilitários GUI Hypr" },
	{ name = "ifuse", desc = "Sistema de arquivos FUSE para acessar o conteúdo de dispositivos iOS" },
	{ name = "libimobiledevice", desc = "Biblioteca para comunicação com serviços em dispositivos iOS" },
	{ name = "slurp", desc = "Selecione uma região no Wayland" },
	{ name = "fcitx5", desc = "Próxima geração do fcitx, estrutura de método de entrada multiplataforma" },
	{ name = "fcitx5-configtool", desc = "Ferramenta de configuração para Fcitx5" },
	{ name = "fcitx5-qt", desc = "Biblioteca Qt Fcitx5" },
	{ name = "fcitx5-lua", desc = "Suporte a Lua para Fcitx5" },
	{ name = "waybar", desc = "Barra Wayland altamente personalizável." },
	{ name = "rofi", desc = "Um alternador de janelas, iniciador de aplicativos e substituto do dmenu" },
	{ name = "rofi-emoji", desc = "Um plugin Rofi para selecionar emojis" },
	-- { name = "wofi", desc = "Launcher para menu iniciar" },
	{ name = "yazi", desc = "Gerenciador de arquivos de terminal escrito em Rust e baseado em I/O assíncrona" },
}

--- ============================================================================
--- PACOTES DO AUR (UNOFFICIAL)
--- ============================================================================

packages.AUR = {
	{ name = "note-liber-bin", desc = "App anotações rápido" },
	{ name = "brave-bin", desc = "Navegador focado em privacidade e desempenho (versão binária)" },
	{ name = "spotify", desc = "Cliente oficial do Spotify para streaming de música" },
	{ name = "visual-studio-code-bin", desc = "Editor VS Code (binário)" },
	{ name = "postman-bin", desc = "Ferramenta testes API (binário)" },
	{ name = "local-by-flywheel-bin", desc = "Ambiente de desenvolvimento WordPress local" },
	{ name = "beekeeper-studio-bin", desc = "Gerenciador DB moderno" },
	{ name = "howdy", desc = "Windows Hello para Linux sensor ir" },
	{ name = "heroic-games-launcher-bin", desc = "Gerenciador gráfico para jogos no Linux" },
	{ name = "dnspyex-wine-bin", desc = "Descompilador .NET via Wine" },
	{ name = "caido-desktop", desc = "Conjunto de ferramentas para auditoria de segurança web" },
	{ name = "claude-desktop-bin", desc = "Cliente Claude com MCP" },
	{ name = "ryzenadj", desc = "Ajuste TDP/TCTL AMD Ryzen" },
	{ name = "wlogout", desc = "Logout menu para wayland" },
}

--- ============================================================================
--- EXPORTAÇÃO DO MÓDULO
--- ============================================================================

return packages
