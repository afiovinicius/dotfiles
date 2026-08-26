--- ============================================================================
--- 📦 AFIO ARCH - ENVIRONMENT & CONFIGURATION
--- ============================================================================
--- Arquivo centralizado para variáveis de ambiente, constantes e configurações
--- globais do projeto. Importado por qualquer módulo que precise desses dados.
--- ============================================================================

local envs = {}

--- ============================================================================
--- 🎨 BANNER E IDENTIDADE VISUAL
--- ============================================================================

envs.BANNER = [[
  ___    __  _                ___              _
 / _ \  / _|(_)              / _ \            | |
/ /_\ \| |_  _   ___        / /_\ \ _ __  ___ | |__
|  _  ||  _|| | / _ \   __  |  _  || '__|/ __|| '_ \
| | | || |  | || (_) | |__| | | | || |  | (__ | | | |
\_| |_/|_|  |_| \___/       \_| |_/|_|   \___||_| |_|
]]

envs.PROJECT_NAME = "Afio Arch"
envs.PROJECT_VERSION = "2.0.0"
envs.REPOSITORY = "https://github.com/afiovinicius/dotfiles"

--- ============================================================================
--- 🎨 CORES E ESTILOS DE TEXTO (ANSI ESCAPE CODES)
--- ============================================================================

envs.COLORS = {
  RESET   = "\27[0m",
  BOLD    = "\27[1m",
  DIM     = "\27[2m",

  -- Foreground (Texto)
  BLACK   = "\27[30m",
  RED     = "\27[31m",
  GREEN   = "\27[32m",
  YELLOW  = "\27[33m",
  BLUE    = "\27[34m",
  PURPLE  = "\27[35m",
  CYAN    = "\27[36m",
  WHITE   = "\27[37m",

  -- Background (Fundo)
  BG_BLACK   = "\27[40m",
  BG_RED     = "\27[41m",
  BG_GREEN   = "\27[42m",
  BG_YELLOW  = "\27[43m",
  BG_BLUE    = "\27[44m",
  BG_PURPLE  = "\27[45m",
  BG_CYAN    = "\27[46m",
  BG_WHITE   = "\27[47m",
}

--- ============================================================================
--- 📁 CAMINHOS E DIRETÓRIOS
--- ============================================================================

envs.PATHS = {
  HOME = os.getenv("HOME"),
  DOTFILES = os.getenv("HOME") .. "/.dotfiles",
  SRC = os.getenv("HOME") .. "/.dotfiles/src",
  CORE = os.getenv("HOME") .. "/.dotfiles/src/core",
  SERVICES = os.getenv("HOME") .. "/.dotfiles/src/services",
  INTERFACES = os.getenv("HOME") .. "/.dotfiles/src/interfaces",
  MODELS = os.getenv("HOME") .. "/.dotfiles/src/models",
  UTILS = os.getenv("HOME") .. "/.dotfiles/src/utils",
  ASSETS = os.getenv("HOME") .. "/.dotfiles/src/assets",
}

--- ============================================================================
--- ⚙️ CONFIGURAÇÕES DO SISTEMA
--- ============================================================================

envs.SYSTEM = {
  -- Detecção de distribuição (assumindo Arch Linux)
  DISTRO = "arch",

  -- Package manager
  PKG_MANAGER = "pacman",
  PKG_MANAGER_INSTALL = "sudo pacman -S --needed --noconfirm",
  PKG_MANAGER_SYNC = "sudo pacman -Sy",
  PKG_MANAGER_UPGRADE = "sudo pacman -Syu --noconfirm",
  PKG_MANAGER_QUERY = "pacman -Q",

  -- AUR helper
  AUR_HELPER = "yay",
  AUR_HELPER_INSTALL = "yay -S --needed --noconfirm",

  -- Reflector (mirror list)
  REFLECTOR_CMD = "sudo reflector --verbose --country BR --age 24 --p http --p https --sort rate --save /etc/pacman.d/mirrorlist",

  -- Git
  GITHUB_REPO = "afiovinicius/dotfiles",
  GITHUB_BRANCH = "lua",
}

--- ============================================================================
--- 🔧 CONFIGURAÇÕES DO PACMAN E SISTEMA
--- ============================================================================

envs.PACMAN_CONF = {
  parallel_downloads = 10,
  enable_candy = true, -- ILoveCandy
}

envs.ZRAM_CONFIG = {
  -- Configuração dinâmica baseada em RAM detectada
  -- Será ajustada em runtime por system.lua
  compression = "zstd",
  swap_priority = 100,
}

envs.SYSCTL_CONFIG = {
  -- Estes valores são ajustados dinamicamente em runtime
  -- Baseado no tamanho total de RAM do sistema
  watermark_boost_factor = 0,
  watermark_scale_factor = 125,
  page_cluster = 0,
}

--- ============================================================================
--- 🌍 CONFIGURAÇÕES DE LOCALIZAÇÃO E IDIOMA
--- ============================================================================

envs.LOCALE = {
  DEFAULT = "pt_BR.UTF-8",
  LANG = "pt_BR",
  SUPPORTED = {
    "pt_BR.UTF-8 UTF-8",
    "en_US.UTF-8 UTF-8",
  },
}

envs.KEYBOARD = {
  DEFAULT_LAYOUT = "br-abnt2",
  SUPPORTED = {
    "us",
    "br-abnt2",
  },
}

--- ============================================================================
--- 🎯 AMBIENTES GRÁFICOS (Desktop Environments & Compositors)
--- ============================================================================

envs.DISPLAY_SERVERS = {
  XORG = "xorg",
  WAYLAND = "wayland",
}

envs.DESKTOP_ENVIRONMENTS = {
  KDE = "kde",
  HYPRLAND = "hyprland",
  I3WM = "i3wm",
}

--- ============================================================================
--- 💻 HARDWARE E DRIVERS
--- ============================================================================

envs.CPU_VENDORS = {
  AMD = "amd",
  INTEL = "intel",
}

envs.GPU_VENDORS = {
  AMD = "amd",
  NVIDIA = "nvidia",
  INTEL = "intel",
}

--- ============================================================================
--- 📊 LIMITES E VALIDAÇÕES
--- ============================================================================

envs.LIMITS = {
  MIN_RAM_MB = 4096,          -- 4 GB mínimo
  MIN_STORAGE_MB = 10240,     -- 10 GB mínimo
  ZRAM_RAM_SMALL = 9000,      -- Até 8 GB
  ZRAM_RAM_MEDIUM = 25000,    -- 12 a 24 GB
  ZRAM_RAM_LARGE = 32000,    -- 32 GB ou mais
}

envs.SWAPPINESS_LEVELS = {
  small = 180,   -- RAM ≤ 8GB
  medium = 150,  -- RAM 12-24GB
  large = 100,   -- RAM ≥ 32GB
}

--- ============================================================================
--- 📝 MENSAGENS E STRINGS COMUNS
--- ============================================================================

envs.MESSAGES = {
  WELCOME = "Bem-vindo ao instalador do Afio Arch!",
  START = "Iniciando instalação...",
  COMPLETE = "Instalação concluída com sucesso! 🎉",
  ERROR = "Ocorreu um erro durante o processo.",
  CONFIRM_INSTALL = "Deseja continuar com a instalação?",
  CONFIRM_REBOOT = "Deseja reiniciar o sistema agora?",
}

--- ============================================================================
--- 📤 EXPORTAÇÃO DO MÓDULO
--- ============================================================================

return envs