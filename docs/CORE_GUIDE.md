# 📦 Guia: Módulos Core (`envs.lua` e `packages.lua`)

## ✅ O que foi criado

Dois arquivos fundamental que formam a **base de dados reutilizável** do projeto:

### 1️⃣ `src/core/envs.lua` (Ambiente & Configurações)

**Responsabilidade:** Centralizar todas as variáveis, constantes e configurações que são **reutilizadas** em múltiplos módulos.

**Conteúdo:**

```lua
local envs = require("core.envs")

-- Banner e identidade
envs.BANNER              -- ASCII art do projeto
envs.PROJECT_NAME        -- "Afio Arch"
envs.PROJECT_VERSION     -- "2.0.0-lua"

-- Cores (ANSI codes)
envs.COLORS.RED          -- "\27[31m"
envs.COLORS.GREEN        -- "\27[32m"
envs.COLORS.CYAN         -- "\27[36m"
-- ... etc

-- Caminhos
envs.PATHS.HOME          -- $HOME
envs.PATHS.DOTFILES      -- $HOME/.dotfiles
envs.PATHS.SRC           -- $HOME/.dotfiles/src
envs.PATHS.CORE          -- $HOME/.dotfiles/src/core
-- ... etc

-- Comandos do sistema
envs.SYSTEM.PKG_MANAGER_INSTALL     -- "sudo pacman -S --needed --noconfirm"
envs.SYSTEM.REFLECTOR_CMD           -- comando para atualizar mirrors
envs.SYSTEM.AUR_HELPER_INSTALL      -- "yay -S --needed --noconfirm"

-- Limites e validações
envs.LIMITS.MIN_RAM_MB              -- 4096 (4 GB)
envs.SWAPPINESS_LEVELS.small        -- 180 (para RAM ≤ 8GB)
```

**Uso prático:**

```lua
-- Em qualquer arquivo Lua:
local envs = require("core.envs")
print(envs.COLORS.GREEN .. "Instalando..." .. envs.COLORS.RESET)
os.execute(envs.SYSTEM.PKG_MANAGER_INSTALL .. " git")
```

---

### 2️⃣ `src/core/packages.lua` (Registro de Pacotes)

**Responsabilidade:** Armazenar **todos os pacotes** do sistema, organizados por categoria, com descrição de cada um.

**Estrutura interna:**

Cada pacote é uma tabela com:
- `name`: Nome do pacote (para instalar)
- `desc`: Descrição curta (para exibir no menu)

```lua
packages.DEFAULT = {
  { name = "base", desc = "Pacotes essenciais para o sistema Arch Linux" },
  { name = "git", desc = "Sistema de controle de versão distribuído" },
  -- ...
}

packages.GPU_DRIVERS = {
  AMD = {
    { name = "vulkan-radeon", desc = "API Vulkan para AMD (Mesa)" },
    -- ...
  },
  INTEL = { ... },
  NVIDIA = { ... },
}
```

**Categorias disponíveis:**

| Categoria | O que contém | Exemplo |
|-----------|-------------|---------|
| `DEFAULT` | Base do sistema | base, linux-firmware, zram-generator |
| `CPU_DRIVERS` | Drivers por CPU | amd-ucode, intel-ucode |
| `GPU_DRIVERS` | Drivers GPU (AMD/INTEL/NVIDIA) | vulkan-radeon, nvidia-open-dkms |
| `DISPLAY_SERVERS` | Xorg/Wayland | xorg, wayland, xorg-xwayland |
| `MULTIMEDIA_BASE` | Codecs & áudio | ffmpeg, gstreamer, pipewire |
| `FONTS` | Tipografia | noto-fonts, ttf-jetbrains-mono-nerd |
| `DEVELOPMENT` | Dev base | git, neovim, zsh, alacritty |
| `PYTHON` | Python & gerenciadores | python, poetry, pyenv |
| `NODE` | Node.js & npm | nodejs, pnpm, yarn |
| `RUST` | Rust & Cargo | rustup |
| `DATABASES` | SQL & web | postgresql, sqlite, apache, php |
| `GAMING` | Jogos & Wine | steam, lutris, wine-staging, vkd3d |
| `GAMING_LIBS` | Libs de suporte gaming | vulkan-icd-loader, openal, mesa32 |
| `GRAPHICS` | Design & 3D | blender, gimp, inkscape, krita |
| `INTERNET` | Navegadores & comm | firefox, discord, telegram |
| `MEDIA_TOOLS` | Conversão & multimídia | obs-studio, vlc, kdenlive, yt-dlp |
| `OFFICE` | Produtividade | libreoffice, okular |
| `ACCESSORIES` | Utilitários | flameshot, htop, tree, fastfetch |
| `SECURITY` | Segurança & firewall | ufw, seahorse, caido-desktop, howdy |
| `KDE_EXTRA` | Pacotes KDE adicionais | dolphin, kate, krita, kdenlive |
| `HYPRLAND_EXTRA` | Pacotes Hyprland adicionais | mako, hyprpaper, hyprlock, cliphist |
| `AUR` | Pacotes não-oficiais | visual-studio-code-bin, postman-bin |

**Uso prático:**

```lua
local packages = require("core.packages")

-- Obter todos os pacotes de uma categoria
local gpu_amd = packages.GPU_DRIVERS.AMD
-- Retorna: { { name = "vulkan-radeon", desc = "..." }, ... }

-- Obter apenas nomes (para pacman -S)
local names = packages.get_names(gpu_amd)
-- Retorna: { "vulkan-radeon", "rocm-opencl-runtime", ... }

-- Obter descrição de um pacote específico
local desc = packages.get_description("vulkan-radeon")
-- Retorna: "API Vulkan para AMD (Mesa)"

-- Iterar com descrição (para menu com gum)
for _, pkg in ipairs(packages.DEVELOPMENT) do
  print(pkg.name .. ": " .. pkg.desc)
end
```

---

## 🔄 Fluxo de Uso

```
┌─────────────────────────────────────────────────────┐
│  init-setup (shell script)                          │
│  ├─ Instala git, lua, gum, luarocks               │
│  └─ Executa: lua ./src/main.lua                     │
└─────────────┬───────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────┐
│  main.lua (orquestrador)                            │
│  ├─ require("core.envs")                            │
│  ├─ require("core.packages")                        │
│  ├─ require("utils.aux")  [próximo arquivo]         │
│  └─ Fluxo: CPU → GPU → Display Server → Sistema     │
└─────────────┬───────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────┐
│  utils/aux.lua (wrappers de gum + utilitários)      │
│  ├─ aux.choose(pergunta, opções)                    │
│  ├─ aux.multiselect(pergunta, opções)               │
│  ├─ aux.confirm(pergunta)                           │
│  ├─ aux.spinner(comando, mensagem)                  │
│  └─ aux.run_cmd(comando)                            │
└─────────────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────┐
│  services/system.lua, desktop.lua, ecosystem.lua    │
│  ├─ Usa aux.choose() para menu interativo           │
│  ├─ Usa packages.CATEGORIA para dados               │
│  ├─ Usa envs.SYSTEM para comandos                   │
│  └─ Instala de forma inteligente e visual           │
└─────────────────────────────────────────────────────┘
```

---

## 🎯 Próximo Passo: `src/utils/aux.lua`

Este arquivo conterá os **wrappers de gum** que tornarão a experiência visual elegante:

```lua
local aux = require("utils.aux")

-- Menu com setas (single select)
local cpu = aux.choose("Qual sua CPU?", { "AMD", "INTEL" })
-- Retorna: "AMD" ou "INTEL"

-- Multi-select com espaço (multiple select)
local pkgs = aux.multiselect("Quais pacotes instalar?", {
  "git", "neovim", "docker", "rust"
})
-- Retorna: { "git", "docker" }

-- Confirmação
if aux.confirm("Deseja continuar?") then
  -- ...
end

-- Spinner com feedback
aux.spinner(
  "sudo pacman -S --noconfirm git",
  "Instalando git..."
)

-- Executar comando com tratamento de erro
aux.run_cmd("pacman -Sy", "Sincronizando pacotes")
```

---

## ✨ Destaques da Arquitetura

### ✅ `envs.lua` oferece:
- **Centralização:** Mude uma constante em um lugar, afeta tudo
- **Reutilização:** Qualquer arquivo pode chamar `require("core.envs")`
- **Consistência:** Cores, caminhos, comandos padronizados

### ✅ `packages.lua` oferece:
- **Descrições:** Cada pacote tem motivo de existir explicado
- **Flexibilidade:** Fácil filtrar por GPU, categoria, etc
- **Escalabilidade:** Adicione pacotes sem mexer em lógica

### ✅ Próximo (`aux.lua`) oferecerá:
- **UX elegante:** Menus interativos com gum, sem hardcode bash
- **Tratamento de erro:** Wrappers para os.execute com feedback visual
- **Modularidade:** Qualquer arquivo chama `aux.choose()`, `aux.spinner()`

---

## 📋 Checklist de Implementação

- ✅ `src/core/envs.lua` — Variáveis globais
- ✅ `src/core/packages.lua` — Registro de pacotes
- ⏳ `src/utils/aux.lua` — Wrappers de gum & utilitários
- ⏳ `src/main.lua` — Orquestrador (menu principal)
- ⏳ `src/services/system.lua` — Configurações do sistema
- ⏳ `src/services/desktop.lua` — Runtimes de dev
- ⏳ `src/services/ecosystem.lua` — Instalação em lote
- ⏳ `src/interfaces/kde/kde.lua` — KDE Plasma
- ⏳ `src/interfaces/hyprland/hyprland.lua` — Hyprland

---

## 🚀 Comandos Úteis

Se precisar instalar dependências Lua no futuro:

```bash
# Instalar pacote via luarocks
sudo luarocks install nome_do_pacote

# Instalar versão específica
sudo luarocks install nome_do_pacote 1.0

# Remover pacote
sudo luarocks remove nome_do_pacote
```

**Neste momento:** Você não precisa de nada além do que já vem no `init-setup` (git, lua, gum).

---

## 📝 Notas Importantes

1. **Estrutura de paths:** `envs.PATHS` assume que o dotfiles está em `$HOME/.dotfiles`. Se mudar, atualize em um único lugar.

2. **Cores:** Use `envs.COLORS.COLOR_NAME .. texto .. envs.COLORS.RESET` para evitar "contaminar" output.

3. **Pacotes:** Ao adicionar pacote novo, sempre inclua descrição curta (max 80 chars) para gum exibir bem.

4. **Categorias:** Se precisar criar categoria nova, siga o padrão:
   ```lua
   packages.NOVA_CATEGORIA = {
     { name = "...", desc = "..." },
   }
   ```

---

## 🔗 Referência de Imports

```lua
-- Em qualquer arquivo:
local envs = require("core.envs")
local packages = require("core.packages")
local aux = require("utils.aux")  -- [próximo]
local system = require("services.system")  -- [depois]
local desktop = require("services.desktop")  -- [depois]
```

---

**Criado:** Agosto 2026  
**Versão:** 2.0.0-lua  
**Status:** ✅ Pronto para próxima fase (aux.lua)
