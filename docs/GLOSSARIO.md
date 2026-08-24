# 📚 Glossário Técnico & Análise do Projeto Afio Arch

> **Análise do Sistema e Repositório:** Documento gerado com base na arquitetura de scripts de automação (`init-setup`, `setup.sh`, `configs-system.sh`, `configs-desktop.sh`, `ecosystem.sh`, `utils.sh` e instaladores de AMB) do projeto **Afio Arch** (dotfiles de Afio Vinícius).

---

## 🏗️ 1. Estrutura e Fluxo dos Scripts do Repositório

O repositório foi construído de forma modular para automatizar a instalação, pós-instalação, otimização de kernel/memória e deploy do ambiente gráfico no **Arch Linux**.

| Script                     | Função Principal          | Principais Recursos / Ações                                                                                                                                                                                                                                     |
| :------------------------- | :------------------------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`init-setup`**           | Bootstrapper inicial      | Verifica dependência do `git`, clona o repositório `afiovinicius/dotfiles` em `$HOME/dotfiles` e executa o `setup.sh`.                                                                                                                                          |
| **`setup.sh`**             | Menu interativo principal | Coordena a seleção interativa de drivers de CPU/GPU, servidor gráfico (Xorg/Wayland), executa otimizações do sistema, instala o ambiente escolhido (KDE/Hyprland), atualiza o sistema (`pacman -Syu`) e limpa o cache.                                          |
| **`configs-system.sh`**    | Otimização e Kernel       | Ajusta o Pacman (`ParallelDownloads=10`, `ILoveCandy`), Habilita serviços `systemd` (Bluetooth, Reflector, Power Profiles), otimiza SSD (`noatime`), ajusta dinamicamente ZRAM/Swappiness e configura automação de mirrors com `reflector` via hooks do pacman. |
| **`configs-desktop.sh`**   | Shell & Ambiente Dev      | Configura fontes (`noto-fonts`, `adobe-source`), terminais (`Alacritty`, `Ghostty`), shell `Zsh` com plugins e `Starship`, parâmetros globais do Git, runtimes do Python (`Poetry`, `uv`), `Angular CLI` e serviço `Docker`.                                    |
| **`ecosystem.sh`**         | Instalação de Aplicações  | Realiza o download e instalação em lote das categorias de pacotes do sistema (Acessórios, Dev, Games, Design, IoT, Multimídia, Escritório, AUR via `yay` e `Flatpak`).                                                                                          |
| **`utils.sh`**             | Definições e Utilitários  | Contém listas organizadas em arrays bash com todas as dependências do sistema e funções auxiliares de formatação visual (`pf`, `plist`, `pkg_i`, `run_cmd_valid`).                                                                                              |
| **`files/kde/install.sh`** | Instalador do KDE         | Instala a base do `plasma`, `plasma-desktop` e `sddm`, ativa serviços (`fstrim`, `NetworkManager`), força o uso de NumLock e chama o script de ecossistema.                                                                                                     |

---

## ⚡ 2. Otimizações do Sistema, Memória & Kernel

### 🧠 ZRAM & Gerenciamento de Memória Virtual

- **ZRAM (`zram-generator`)**: Cria um dispositivo de bloco comprimido na RAM física operando como área de Swap de altíssima velocidade comprimida via **zstd**. Evita travamentos por estresse de memória (Out-Of-Memory) e reduz escritas físicas no SSD.
- **Swappiness (`vm.swappiness`)**: Parâmetro do kernel ajustado dinamicamente no script `configs-system.sh`:
  - `180` para RAM ≤ 8 GB (força o kernel a usar agressivamente a ZRAM comprimida).
  - `150` para RAM entre 12 GB e 24 GB.
  - `100` para RAM ≥ 32 GB.
- **Watermark Boosting (`vm.watermark_scale_factor` / `vm.watermark_boost_factor`)**: Ajustes de desalocação proativa de páginas de memória para evitar picos de latência sob carga pesada (jogos e compilação).
- **`vm.page-cluster = 0`**: Desativa o pre-read de múltiplas páginas no swap, otimizando a leitura/escrita de páginas individuais na ZRAM.

### 💾 Armazenamento & Desempenho de Disco

- **`noatime` (FSTAB)**: Substitui a opção padrão `relatime` nas montagens de partição no `/etc/fstab`. Impede que o sistema grave metadata de último acesso a cada leitura de arquivo, prolongando a vida útil e aumentando a velocidade do SSD.
- **`fstrim.timer`**: Serviço do systemd que executa periodicamente o comando TRIM em drives SSD/NVMe para liberar blocos de memória deletados.
- **`sysstat` & `gsmartcontrol`**: Ferramentas de monitoramento I/O em tempo real e integridade física de discos via tecnologia S.M.A.R.T.

### 🌐 Espelhos & Gerenciamento de Pacotes (`pacman`)

- **Reflector**: Utilitário que testa e ranqueia automaticamente os espelhos (_mirrors_) de download mais rápidos e atualizados do Brasil.
- **Pacman Hooks (`mirrorupgrade.hook`)**: Automação criada no `configs-system.sh` para reordenar a mirrorlist e limpar arquivos `.pacnew` sempre que o pacote `pacman-mirrorlist` for atualizado.
- **ParallelDownloads = 10**: Permite o download simultâneo de até 10 pacotes no pacman.
- **ILoveCandy**: Ativa o indicador visual estilo Pac-Man nas barras de progresso do terminal.

---

## 🖥️ 3. Servidores Gráficos, Compositores & Gerenciadores de Janela

- **Xorg (X11)**: Servidor de exibição legado tradicional Linux. Oferece compatibilidade total com aplicações legadas e ferramentas de capturas antigas.
- **Wayland**: Protocolo moderno de exibição de baixa latência, imune a _screen tearing_ (rasgos de imagem) e otimizado para GPUs modernas.
- **XWayland (`xorg-xwayland`)**: Camada de compatibilidade para executar programas baseados no X11 de forma transparente dentro de sessões Wayland.
- **Hyprland**: Compositor Wayland dinâmico (_tiling_) baseado em _wlroots_, famoso pelas animações fluídas por GPU, cantos arredondados, desfoque gaussiano e suporte nativo a múltiplos monitores com taxas de atualização variáveis (VRR).
- **KDE Plasma**: Ambiente de trabalho (_Desktop Environment_) completo, altamente customizável, baseado no ecossistema Qt6/KDE Frameworks.
- **Gamescope**: Compositor Wayland isolado criado pela Valve. Permite rodar jogos em contêineres de renderização com _scaling_ espacial/temporal (FSR), controle fino de resolução, limitação de FPS e isolamento de resolução.

---

## 🧩 4. Ecossistema de Ferramentas Hyprland / Wayland

| Ferramenta                       | Categoria       | Descrição / Função no Sistema                                                                |
| :------------------------------- | :-------------- | :------------------------------------------------------------------------------------------- |
| **`mako`**                       | Notificações    | Daemon de notificações leve e customizável para Wayland.                                     |
| **`hyprpaper`**                  | Papel de Parede | Gerenciador dinâmico de wallpapers com suporte a múltiplos monitores.                        |
| **`hyprlock`**                   | Segurança       | Bloqueio de tela rápido e acelerado por GPU.                                                 |
| **`hypridle`**                   | Economia        | Daemon para gerenciamento de inatividade (suspensão/desligamento de tela).                   |
| **`hyprpicker`**                 | Utilitário      | Seletor de cores (_color picker_) nativo para Wayland.                                       |
| **`hyprsunset`**                 | Saúde / Visual  | Filtro de luz azul noturno para o sistema.                                                   |
| **`cliphist`**                   | Produtividade   | Gerenciador de histórico da área de transferência (_clipboard_).                             |
| **`brightnessctl`**              | Hardware        | Controle de brilho de telas e teclados retrô-iluminados via CLI.                             |
| **`pamixer` / `playerctl`**      | Áudio / Mídia   | Controles via terminal de volume do PipeWire e reprodução MPRIS (Spotify, VLC, navegadores). |
| **`hyprpolkitagent`**            | Autenticação    | Daemon visual de elevação de privilégios (`sudo`/Polkit) para requisições gráficas.          |
| **`nwg-displays` / `nwg-shell`** | Configuração    | Interfaces gráficas GTK3 para configuração de monitores, layouts e barras.                   |

---

## 🛠️ 5. Linguagens, Ferramentas Dev & Engenharia Reversa

### 🖥️ Shell & Terminal Moderno

- **Zsh**: Shell avançado que substitui o Bash.
- **Plugins Zsh**: `zsh-autosuggestions` (sugestões baseadas no histórico), `zsh-syntax-highlighting` (destaque de sintaxe), `zsh-completions` (autocompletar avançado), `zsh-interactive-cd` e `zsh-navigation-tools`.
- **Starship**: Prompt minimalista, extremamente rápido e personalizável escrito em Rust.
- **Ghostty**: Terminal moderno acelerado por GPU com suporte a renderização nativa de glifos.
- **Alacritty**: Terminal minimalista e ultra veloz focado em desempenho bruto via OpenGL.

### 💻 Linguagens & Ambientes de Execução (Runtimes)

- **Node.js, NVM, pnpm, yarn, pm2**: Stack completa para desenvolvimento JavaScript/TypeScript e execução de servidores Node.
- **Python, Pyenv, Poetry, UV, Pipx**: Gerenciamento de versões do Python, criação de ambientes virtuais isolados (`pipx`) e empacotamento ultrarrápido (`uv`/`poetry`).
- **Rustup**: Gerenciador da cadeia de ferramentas (_toolchain_) da linguagem Rust.
- **Angular CLI**: Interface de linha de comando para scaffold e build de aplicações Angular.
- **Docker & Docker Compose**: Plataforma de virtualização em contêineres e orquestração leve.

### 🕵️ Engenharia Reversa, Auditoria & Edição

- **Ghidra**: Suíte de engenharia reversa e descompilação de código binário desenvolvida pela NSA.
- **Caido Desktop**: Ferramenta moderna e leve para auditoria de segurança web e interceptação de tráfego HTTP/S (substituta ao Burp Suite).
- **DnSpyEx (via Wine)**: Descompilador e depurador para montagens e arquivos binários .NET.
- **Neovim & Vim**: Editores de texto altamente extensíveis via Lua.
- **Zed**: Editor de código colaborativo ultrarrápido escrito em Rust.
- **Biome**: Linter e formatador de código de alta performance para JS/TS/JSON.

---

## 🎮 6. Jogos, Tradução de APIs e Áudio Multimídia

### 🕹️ Camadas de Tradução e Desempenho

- **Wine-Staging**: Versão de desenvolvimento do Wine contendo correções experimentais e patches de desempenho para jogos Windows no Linux.
- **VKD3D**: Camada de tradução que converte chamadas do DirectX 12 para a API Vulkan.
- **Vulkan 1.3 / ICD Loaders**: Drivers e carregadores de interface Vulkan essenciais para execução de Proton/DXVK/VKD3D.
- **GameMode (`gamemode`)**: Daemon da Feral Interactive que otimiza automaticamente as Governors da CPU, prioridades de E/S e perfis energéticos durante a execução de jogos.
- **MangoHud**: HUD de monitoramento em tempo real de FPS, frametime, temperaturas de CPU/GPU e uso de VRAM.
- **FSR (FidelityFX Super Resolution)**: Reamostragem espacial de imagem integrada ao Gamescope para ganho substancial de quadros.

### 🎧 Stack de Áudio e Captura

- **PipeWire / PipeWire-GStreamer**: Servidor de multimídia de ultra-baixa latência para roteamento de áudio/vídeo profissional (substituto do PulseAudio e JACK).
- **ALSA / Bluez**: Infraestrutura básica do kernel para placas de som e comunicação Bluetooth.
- **OBS Studio & v4l2loopback**: Suíte de gravação/transmissão e driver para criação de câmeras virtuais e loopback de vídeo no Linux.
- **Howdy**: Sistema de autenticação biométrica por reconhecimento facial infravermelho (equivalente ao Windows Hello) usando PAM no terminal e elevação de privilégios.

---

## 🔠 7. Dicionário de Pacotes e Componentes de A a Z

| Pacote / Componente                  | Descrição Resumida                                                                                            |
| :----------------------------------- | :------------------------------------------------------------------------------------------------------------ |
| **`a52dec`**                         | Decodificador para fluxos de áudio ATSC A/52 (AC-3).                                                          |
| **`adobe-source-fonts`**             | Família de fontes tipográficas otimizadas para programação e leitura (`Source Code Pro`, `Sans`, `Serif`).    |
| **`alacritty`**                      | Emulador de terminal acelerado por GPU via OpenGL.                                                            |
| **`alsa-utils` / `alsa-firmware`**   | Ferramentas de configuração e firmwares para placas de som no ALSA.                                           |
| **`amdgpu` / `amdvlk`**              | Drivers de código aberto e suporte Vulkan oficial da AMD.                                                     |
| **`apache` / `php` / `phpmyadmin`**  | Servidor Web e ambiente tradicional de desenvolvimento backend Web (LAMP).                                    |
| **`aquamarine`**                     | Gerenciador de janelas dinâmico leve para ecossistemas Wayland.                                               |
| **`ark`**                            | Gerenciador gráfico de compactação e extração de arquivos do KDE.                                             |
| **`audacious`**                      | Reprodutor de áudio leve e rápido focado em simplicidade.                                                     |
| **`bat`**                            | Substituto do `cat` no terminal com suporte a sintaxe colorida e integração Git.                              |
| **`beekeeper-studio`**               | Interface gráfica moderna para gerenciamento de bancos de dados SQL (PostgreSQL, SQLite, MySQL).              |
| **`biome`**                          | Ferramenta unificada de alta performance para formatação e linting de código web.                             |
| **`bleachbit`**                      | Utilitário de limpeza de sistema, remoção de arquivos temporários e liberação de disco.                       |
| **`blender`**                        | Suíte profissional open-source para modelagem 3D, renderização e animação.                                    |
| **`bluez` / `bluez-utils`**          | Pilha de protocolos oficial de Bluetooth para Linux e utilitários de pareamento.                              |
| **`brave-bin`**                      | Navegador Web focado em privacidade, bloqueio nativo de anúncios e desempenho.                                |
| **`brightnessctl`**                  | Controle de brilho da tela via CLI.                                                                           |
| **`btrfs-progs`**                    | Utilitários para criação e gerenciamento do sistema de arquivos Btrfs.                                        |
| **`caido-desktop`**                  | Suite moderna de auditoria de segurança web (proxy de interceptação HTTP).                                    |
| **`cameractrls`**                    | Interface de ajuste fino de parâmetros de webcams (exposição, foco, balanço de branco).                       |
| **`claude-desktop-bin`**             | Cliente de desktop da inteligência artificial Claude com suporte a MCP.                                       |
| **`cliphist`**                       | Gerenciador de área de transferência otimizado para Wayland.                                                  |
| **`cpupower`**                       | Utilitário para alteração de governadores de frequência e energia da CPU.                                     |
| **`discord` / `telegram-desktop`**   | Aplicativos de comunicação instantânea, voz e colaboração.                                                    |
| **`docker` / `docker-compose`**      | Engine para criação e execução de ecossistemas em contêineres.                                                |
| **`dolphin`**                        | Gerenciador de arquivos completo do ambiente KDE Plasma.                                                      |
| **`eza`**                            | Substituto moderno e colorido do comando `ls` com suporte a árvore e Git.                                     |
| **`fastfetch`**                      | Exibidor visual de informações do sistema operacional no terminal.                                            |
| **`fd` / `ripgrep` / `fzf`**         | Conjunto de ferramentas ultrarrápidas de busca de arquivos, busca textual (`rg`) e filtro interativo (`fzf`). |
| **`ffmpeg` / `ffmpegthumbnailer`**   | Framework multimídia universal para codificação/decodificação de áudio e vídeo e geração de miniaturas.       |
| **`firefox`**                        | Navegador Web open-source principal do sistema.                                                               |
| **`flameshot`**                      | Ferramenta avançada para captura e anotação rápida de telas.                                                  |
| **`flatpak`**                        | Sistema de distribuição e execução de aplicativos isolados (_sandbox_).                                       |
| **`fwupd`**                          | Daemon de atualização automática de firmwares de dispositivos de hardware.                                    |
| **`gamemode`**                       | Otimizador de desempenho do sistema voltado para jogos.                                                       |
| **`gamescope`**                      | Compositor micro-display isolado para otimização de jogos da Valve.                                           |
| **`ghidra`**                         | Ferramenta de engenharia reversa e análise de binários.                                                       |
| **`ghostty`**                        | Emulador de terminal acelerado por GPU com foco em tipografia e performance.                                  |
| **`gimp` / `inkscape`**              | Editores gráficos para manipulação de imagens rasterizadas (GIMP) e gráficos vetoriais SVG (Inkscape).        |
| **`git` / `github-cli`**             | Sistema de controle de versão e utilitário CLI oficial do GitHub.                                             |
| **`gsmartcontrol`**                  | Interface gráfica para teste e diagnóstico S.M.A.R.T. de discos rígidos e SSDs.                               |
| **`gstreamer` (e plugins)**          | Framework multimídia para construção de pipelines de processamento de áudio/vídeo/IA.                         |
| **`heroic-games-launcher`**          | Launcher open-source para jogos das plataformas Epic Games, GOG e Prime Gaming.                               |
| **`howdy`**                          | Autenticação por reconhecimento facial infravermelho via PAM no Linux.                                        |
| **`htop`**                           | Monitor interativo de processos e recursos do sistema no terminal.                                            |
| **`hyprland`**                       | Compositor Wayland dinâmico (_tiling_) com foco em estética e fluidez.                                        |
| **`irqbalance`**                     | Utilitário que distribui as interrupções de hardware entre os núcleos da CPU.                                 |
| **`krita`**                          | Aplicativo de pintura digital, ilustração e arte vetorial do ecossistema KDE.                                 |
| **`kvantum`**                        | Motor de temas para aplicações Qt que permite personalização visual avançada.                                 |
| **`libreoffice`**                    | Suíte de escritório completa (processador de texto, planilhas, apresentações).                                |
| **`lm_sensors`**                     | Leitor de sensores de hardware (temperatura de CPU/GPU, rotação de ventoinhas, tensões).                      |
| **`lutris`**                         | Gerenciador unificado de bibliotecas de jogos para Linux.                                                     |
| **`mangohud`**                       | Camada visual de monitoramento de métricas de desempenho em tempo real para Vulkan/OpenGL.                    |
| **`neovim`**                         | Editor de texto extensível focado em produtividade via linha de comando.                                      |
| **`networkmanager`**                 | Daemon e utilitários para gerenciamento flexível de conexões de rede (Wi-Fi, Ethernet, VPN).                  |
| **`note-liber-bin`**                 | Aplicativo minimalista e rápido para anotações.                                                               |
| **`noto-fonts-emoji`**               | Conjunto de fontes Noto com suporte completo a caracteres emoji Unicode.                                      |
| **`obs-studio`**                     | Software profissional de gravação de vídeo e transmissão ao vivo.                                             |
| **`okular`**                         | Visualizador universal de documentos (PDF, EPUB, DjVu) do KDE.                                                |
| **`opencode`**                       | Ferramenta / editor para código.                                                                              |
| **`pacman-contrib`**                 | Coleção de scripts úteis para usuários do gerenciador de pacotes Pacman (ex: `paccache`).                     |
| **`pipewire`**                       | Servidor de multimídia moderno de baixa latência para Linux.                                                  |
| **`postman-bin`**                    | Plataforma para desenvolvimento, documentação e testes de APIs REST/GraphQL.                                  |
| **`power-profiles-daemon`**          | Gerenciador de perfis de energia do sistema (Economia, Balanceado, Performance).                              |
| **`powertop`**                       | Ferramenta de diagnóstico de consumo de energia em tempo real desenvolvida pela Intel.                        |
| **`pyenv` / `poetry` / `uv`**        | Ecossistema moderno de gerenciamento de versões, dependências e empacotamento em Python.                      |
| **`qbittorrent`**                    | Cliente de download via protocolo BitTorrent leve e sem anúncios.                                             |
| **`reflector`**                      | Script de sincronização dos espelhos de pacotes mais ágeis do Arch Linux.                                     |
| **`rocm-opencl-runtime`**            | Plataforma de computação paralela e OpenCL para GPUs AMD Radeon.                                              |
| **`rustup`**                         | Instalador e gerenciador de versões da linguagem Rust.                                                        |
| **`ryzenadj`**                       | Utilitário para ajuste dos limites energéticos (TDP/TCTL) de processadores AMD Ryzen.                         |
| **`sddm`**                           | Gerenciador de exibição gráfico e tela de login para sessões X11 e Wayland.                                   |
| **`seahorse`**                       | Interface para gerenciamento de chaves GPG, SSH e senhas do ambiente GNOME.                                   |
| **`spotify`**                        | Aplicativo oficial para streaming de áudio e música.                                                          |
| **`starship`**                       | Prompt customizável e ultra-rápido para qualquer shell.                                                       |
| **`steam`**                          | Maior plataforma de distribuição digital de jogos e gerenciamento de biblioteca PC.                           |
| **`sysstat`**                        | Conjunto de utilitários de monitoramento do sistema (`iostat`, `mpstat`, `sar`).                              |
| **`ufw` / `gufw`**                   | Firewall simples baseados em `iptables/nftables` e sua respectiva interface gráfica.                          |
| **`v4l2loopback-dkms`**              | Módulo do kernel que permite criar dispositivos de vídeo virtuais V4L2.                                       |
| **`vkd3d`**                          | Tradutor de Direct3D 12 para Vulkan baseado no Wine.                                                          |
| **`vlc`**                            | Tocador multimídia clássico e versátil compatível com quase todos os codecs.                                  |
| **`vulkan-radeon` / `vulkan-intel`** | Implementações da API gráfica Vulkan baseadas nos drivers de código aberto Mesa.                              |
| **`wayland` / `xorg`**               | Protocolos centrais dos servidores de exibição gráfico no Linux.                                              |
| **`wine-staging`**                   | Camada de compatibilidade para execução de softwares e jogos do Windows.                                      |
| **`yay`**                            | Helper em Go para o AUR (Arch User Repository) com interface similar ao Pacman.                               |
| **`yt-dlp`**                         | Utilitário de linha de comando avançado para download de vídeos de plataformas web.                           |
| **`zed`**                            | Editor de código de altíssimo desempenho para desenvolvimento web.                                            |
| **`zram-generator`**                 | Gerador do systemd para criação e configuração dinâmica de partições ZRAM.                                    |
| **`zsh`**                            | Shell de comandos avançado com suporte extenso a customização e autocompletar.                                |

---

## 🎯 Conclusão e Observações Finais

O projeto **Afio Arch** representa uma arquitetura extremamente otimizada e coesa para o **Arch Linux**, combinando:

1. **Desempenho máximo de Hardware**: Através de tuning no Kernel (`zram`, `swappiness`, `noatime`, `irqbalance`, `cpupower`, `ryzenadj`).
2. **Ambiente Gráfico Moderno e Flexível**: Opções entre o ecossistema estático e rico em recursos (**KDE Plasma**) e o ecossistema dinâmico, minimalista e ultra fluido (**Hyprland / Wayland**).
3. **Stack Completa para Desenvolvimento & Engenharia**: Suporte imediato para contêineres (`Docker`), linguagens modernas (`Rust`, `Node.js`, `Python`), editores de alta performance (`Neovim`, `Ghostty`, `Zed`) e ferramentas avançadas de análise e auditoria (`Ghidra`, `Caido`).
4. **Pronto para Jogos de Alta Performance**: Configuração nativa das camadas de tradução (`Proton`, `Wine-Staging`, `VKD3D`, `Vulkan 1.3`), gerenciadores de jogos (`Steam`, `Lutris`, `Heroic`) e otimizadores (`GameMode`, `Gamescope`, `MangoHud`).
