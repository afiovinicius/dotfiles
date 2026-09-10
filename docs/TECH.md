# 🚀 Tech Stack & Arquitetura Híbrida: Lua + Shell Script

Este documento define a nova arquitetura para o projeto **Orzhov Arch**, migrando de uma base puramente Bash/Shell Script para um ecossistema híbrido utilizando **Lua** como motor lógico principal e **Shell Script (SH)** como interface de execução de baixo nível e bootstrap.

---

## 🛠️ 1. Visão Geral da Stack

| Tecnologia                  | Papel na Arquitetura                                                             | Vantagens                                                                                                                                                  |
| :-------------------------- | :------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Lua (5.3/5.4 ou LuaJIT)** | Controlador Principal, Lógica de Negócios, Estruturas de Dados e Menus.          | Extremamente rápida, suporta tabelas estruturadas (muito superiores aos arrays do Bash), tratamento de erros nativo (`pcall`), modularidade via `require`. |
| **Shell Script (Bash/Zsh)** | Bootstrapper, Pipelines do Sistema (`\|`), Variáveis de Ambiente e Comandos RAW. | Já presente nativamente em qualquer ISO do Linux, ideal para dar o "pontapé inicial" e executar binários do sistema operacional (`pacman`, `systemctl`).   |

---

## ⚖️ 2. Diretrizes: Quando usar Lua vs Shell Script?

### ✅ Use **Lua** para

1. **Listas e Dados (Arrays/Dicionários):** Gerenciar listas de pacotes, categorias e configurações (tabelas Lua são perfeitas para isso).
2. **Lógica Complexa e Fluxo de Controle:** Menus interativos (`if/else/elseif`), loops complexos, validação de inputs do usuário.
3. **Formatação Visual (UI):** Funções para imprimir textos coloridos, formatar strings e gerar banners.
4. **Modularidade:** Dividir o código em pequenos arquivos lógicos exportando módulos (`module = {} ... return module`).

### ⚙️ Use **Shell Script** para

1. **Bootstrapping Inicial:** O script que clona o repositório e instala o próprio interpretador Lua na ISO do Arch antes de qualquer coisa.
2. **Pipelines Complexos do Linux:** Tarefas que exigem encadeamento de comandos, ex: `ls -la | grep "pacote" | awk '{print $1}'` (embora Lua possa fazer com `io.popen`, o Bash é mais semântico para isso).
3. **Exportação de Variáveis (Environment):** Modificar o ambiente do sistema (`export VAR=value`).

---

## 📂 3. Proposta de Estrutura de Diretórios

A estrutura modulariza as responsabilidades, separando dados estáticos de funções de execução.

```text
dotfiles/
├── docs/                       # Arquivos de documentos para auxiliar durante o desenvolvimento
├── screenshots/                # Prints dos setups montados e configurados
├── scripts/                    # Scripts auxiliares puramente Bash (ex: hooks do pacman)
├── src/
│   ├── assets/
│   │   ├── menu/               # Icone para menu principal
│   │   └── wallpapers/         # Pacote de wallpapers
│   ├── core/
│   │   ├── envs.lua            # (Metade do utils.sh) Caminhos, variáveis de ambiente e mirrors
│   │   └── packages.lua        # (Metade do utils.sh) Tabelas Lua com todos os pacotes
│   ├── interfaces/
│   │   ├── kde/
│   │   │   └── kde.lua         # Instalação do KDE Plasma
│   │   └── hyprland/
│   │       └── hyprland.lua    # Instalação do Hyprland
│   ├── models/                 # Pasta onde fica os arquivos modelos
│   │   └── config/             # Arquivos modelos para configuração das ferramentas
│   ├── services/
│   │   ├── system.lua          # (Antigo configs-system.sh) Fstab, ZRAM, Pacman hooks
│   │   ├── desktop.lua         # (Antigo configs-desktop.sh) Zsh, Docker, Dev runtimes
│   │   └── ecosystem.lua       # (Antigo ecosystem.sh) Lógica de loop para instalar pacotes
│   ├── utils/
│   │   └── aux.lua             # (Metade do utils.sh) Funções de formatação visual (pf, plist), wrapper de os.execute
│   └── main.lua                # (Antigo setup.sh) Ponto de entrada, menu interativo e roteador
├── .gitignore                  # Arquivo de configuração do git do projeto
├── init-setup.sh               # Instala o git, Lua e chama o main.lua
└── README.md                   # Documentação padrão do projeto
```

---

## 🔄 4. Refatoração e Transição de Arquivos

Aqui está o mapeamento do que será adicionado ou removido de acordo com as responsabilidades de cada arquivo.

### 🟡 1. `init-setup`

- **O que remove:** Lógica de execução do `setup.sh`.
- **O que adiciona:** Comando explícito para instalar a linguagem Lua no ambiente Live USB (`pacman -S --noconfirm lua`) antes de invocar `lua main.lua`.
- **Responsabilidade:** Único script `.sh` que o usuário executará manualmente.

### 🔴 2. `utils.sh` ➔ Dividido em 3 arquivos Lua

O `utils.sh` original faz muita coisa: tem funções de tela e guarda pacotes. Na nova stack, ele morre e nasce como:

#### `core/packages.lua` (Apenas Dados)

- **O que recebe:** Todas as listas de pacotes (Dev, Multimídia, Jogos) convertidas de arrays bash para Tabelas Lua.
- **Vantagem:** Facilita a manutenção. Você pode criar categorias, pacotes opcionais e pacotes obrigatórios dentro da mesma estrutura.

#### `utils/aux.lua` (Apenas Funções)

- **O que recebe:** As funções `pf`, `plist`, `pkg_i`.
- **O que adiciona:** Uma função `utils.run_command(cmd)` que empacota o `os.execute` do Lua, capturando erros e exibindo feedbacks padronizados.

### 🔵 3. `setup.sh` ➔ `main.lua`

- **O que remove:** Todo o código "macarrônico" de bash e dezenas de `read -p`.
- **O que adiciona:** Um fluxo orquestrado via `require()`. O `main.lua` apenas pergunta ao usuário o que ele quer (Xorg ou Wayland? KDE ou Hyprland?) e aciona os módulos corretos da pasta `services/`.

### 🟢 4. `ecosystem.sh` ➔ `services/ecosystem.lua`

- **O que remove:** Os `for` loops do bash lidando com expansão de arrays (`${ARRAY[@]}`).
- **O que adiciona:** Lógica funcional em Lua iterando sobre o `packages.lua`.
- **Vantagem:** Permite verificar via Lua se o pacote já está instalado antes de chamar o `pacman`, economizando chamadas de sistema e deixando o console mais limpo.

---

## 💻 5. Exemplos de Implementação (Snippets)

### Exemplo A: `core/packages.lua` (Antigo Array Bash)

```lua
local pkgs = {}

pkgs.core = {
    "git", "wget", "curl", "zsh", "starship", "bat", "eza"
}

pkgs.dev = {
    base = { "neovim", "docker", "docker-compose" },
    python = { "python", "pyenv", "poetry" },
    node = { "nodejs", "npm", "pnpm" }
}

pkgs.hyprland = {
    "hyprland", "waybar", "hyprpaper", "mako", "cliphist"
}

return pkgs
```

### Exemplo B: `utils/aux.lua` (Wrapper de Sistema)

```lua
local aux = {}

function aux.print_info(msg)
    print("\27[34m[INFO]\27[0m " .. msg)
end

function aux.run_cmd(cmd)
    local success = os.execute(cmd)
    if not success then
        print("\27[31m[ERRO]\27[0m Falha ao executar: " .. cmd)
        os.exit(1)
    end
end

function aux.install_packages(package_table)
    local pkg_string = table.concat(package_table, " ")
    aux.print_info("Instalando: " .. pkg_string)
    aux.run_cmd("sudo pacman -S --noconfirm --needed " .. pkg_string)
end

return aux
```

### Exemplo C: `main.lua` (O Novo Controlador)

```lua
local utils = require("utils.aux")
local pkgs = require("core.packages")
local ecosystem = require("services.ecosystem")

utils.print_info("Iniciando a instalação do Orzhov Arch...")

-- 1. Instala Core
utils.install_packages(pkgs.core)

-- 2. Menu Interativo Básico (Lua puro)
print("Escolha seu ambiente: 1) KDE Plasma  2) Hyprland")
local op = io.read()

if op == "1" then
    require("lua.installers.kde").install()
elseif op == "2" then
    require("lua.installers.hyprland").install()
else
    print("Opção inválida!")
end
```

---

## 🎯 Conclusão

A adoção de **Lua + SH** resolve os principais gargalos de scripts bash extensos:

1. **Fim do "Escape Hell"**: Sem problemas com aspas simples, duplas e expansão de variáveis corrompendo comandos.
2. **Dados Estruturados**: Tabelas aninhadas permitem definir ambientes completos (ex: pacotes que só instalam se a GPU for AMD).
3. **Escalabilidade**: Adicionar um novo ambiente gráfico ou stack de desenvolvimento no futuro será tão simples quanto criar uma nova tabela no `packages.lua` e um novo arquivo de módulo.
