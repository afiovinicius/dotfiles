# 🚀 Tech Stack & Arquitetura Híbrida: Lua + Shell Script

Este documento define a nova arquitetura para o projeto **Afio Arch**, migrando de uma base puramente Bash/Shell Script para um ecossistema híbrido utilizando **Lua** como motor lógico principal e **Shell Script (SH)** como interface de execução de baixo nível e bootstrap.

---

## 🛠️ 1. Visão Geral da Stack

| Tecnologia | Papel na Arquitetura | Vantagens |
| :--- | :--- | :--- |
| **Lua (5.3/5.4 ou LuaJIT)** | Controlador Principal, Lógica de Negócios, Estruturas de Dados e Menus. | Extremamente rápida, suporta tabelas estruturadas (muito superiores aos arrays do Bash), tratamento de erros nativo (`pcall`), modularidade via `require`. |
| **Shell Script (Bash/Zsh)** | Bootstrapper, Pipelines do Sistema (`\|`), Variáveis de Ambiente e Comandos RAW. | Já presente nativamente em qualquer ISO do Linux, ideal para dar o "pontapé inicial" e executar binários do sistema operacional (`pacman`, `systemctl`). |

---

## ⚖️ 2. Diretrizes: Quando usar Lua vs Shell Script?

### ✅ Use **Lua** para:
1. **Listas e Dados (Arrays/Dicionários):** Gerenciar listas de pacotes, categorias e configurações (tabelas Lua são perfeitas para isso).
2. **Lógica Complexa e Fluxo de Controle:** Menus interativos (`if/else/elseif`), loops complexos, validação de inputs do usuário.
3. **Formatação Visual (UI):** Funções para imprimir textos coloridos, formatar strings e gerar banners.
4. **Modularidade:** Dividir o código em pequenos arquivos lógicos exportando módulos (`module = {} ... return module`).

### ⚙️ Use **Shell Script** para:
1. **Bootstrapping Inicial:** O script que clona o repositório e instala o próprio interpretador Lua na ISO do Arch antes de qualquer coisa.
2. **Pipelines Complexos do Linux:** Tarefas que exigem encadeamento de comandos, ex: `ls -la | grep "pacote" | awk '{print $1}'` (embora Lua possa fazer com `io.popen`, o Bash é mais semântico para isso).
3. **Exportação de Variáveis (Environment):** Modificar o ambiente do sistema (`export VAR=value`).

---

## 📂 3. Proposta de Estrutura de Diretórios

A estrutura modulariza as responsabilidades, separando dados estáticos de funções de execução.

```text
afio-arch/
├── bootstrap.sh            # (Antigo init-setup) Instala o git, Lua e chama o main.lua
├── main.lua                # (Antigo setup.sh) Ponto de entrada, menu interativo e roteador
├── lua/
│   ├── core/
│   │   ├── utils.lua       # Funções de formatação visual (pf, plist), wrapper de os.execute
│   │   └── logger.lua      # Sistema centralizado de logs (sucesso, erro, info)
│   ├── data/
│   │   ├── packages.lua    # (Metade do utils.sh) Tabelas Lua com todos os pacotes
│   │   └── envs.lua        # Caminhos, variáveis de ambiente e mirrors
│   ├── modules/
│   │   ├── system.lua      # (Antigo configs-system.sh) Fstab, ZRAM, Pacman hooks
│   │   ├── desktop.lua     # (Antigo configs-desktop.sh) Zsh, Docker, Dev runtimes
│   │   └── ecosystem.lua   # (Antigo ecosystem.sh) Lógica de loop para instalar pacotes
│   └── installers/
│       ├── hyprland.lua    # Instalação específica do Hyprland
│       └── kde.lua         # (Antigo files/kde/install.sh) Instalação do Plasma
└── scripts/
    └── hooks/              # Scripts auxiliares puramente Bash (ex: hooks do pacman)
```

---

## 🔄 4. Refatoração e Transição de Arquivos

Aqui está o mapeamento do que será adicionado ou removido de acordo com as responsabilidades de cada arquivo.

### 🟡 1. `init-setup` ➔ `bootstrap.sh`
- **O que remove:** Lógica de execução do `setup.sh`.
- **O que adiciona:** Comando explícito para instalar a linguagem Lua no ambiente Live USB (`pacman -S --noconfirm lua`) antes de invocar `lua main.lua`.
- **Responsabilidade:** Único script `.sh` que o usuário executará manualmente.

### 🔴 2. `utils.sh` ➔ Dividido em 2 arquivos Lua
O `utils.sh` original faz muita coisa: tem funções de tela e guarda pacotes. Na nova stack, ele morre e nasce como:

#### `lua/data/packages.lua` (Apenas Dados)
- **O que recebe:** Todas as listas de pacotes (Dev, Multimídia, Jogos) convertidas de arrays bash para Tabelas Lua.
- **Vantagem:** Facilita a manutenção. Você pode criar categorias, pacotes opcionais e pacotes obrigatórios dentro da mesma estrutura.

#### `lua/core/utils.lua` (Apenas Funções)
- **O que recebe:** As funções `pf`, `plist`, `pkg_i`.
- **O que adiciona:** Uma função `utils.run_command(cmd)` que empacota o `os.execute` do Lua, capturando erros e exibindo feedbacks padronizados.

### 🔵 3. `setup.sh` ➔ `main.lua`
- **O que remove:** Todo o código "macarrônico" de bash e dezenas de `read -p`.
- **O que adiciona:** Um fluxo orquestrado via `require()`. O `main.lua` apenas pergunta ao usuário o que ele quer (Xorg ou Wayland? KDE ou Hyprland?) e aciona os módulos corretos da pasta `modules/`.

### 🟢 4. `ecosystem.sh` ➔ `lua/modules/ecosystem.lua`
- **O que remove:** Os `for` loops do bash lidando com expansão de arrays (`${ARRAY[@]}`).
- **O que adiciona:** Lógica funcional em Lua iterando sobre o `packages.lua`.
- **Vantagem:** Permite verificar via Lua se o pacote já está instalado antes de chamar o `pacman`, economizando chamadas de sistema e deixando o console mais limpo.

---

## 💻 5. Exemplos de Implementação (Snippets)

### Exemplo A: `lua/data/packages.lua` (Antigo Array Bash)
```lua
-- data/packages.lua
local M = {}

M.core = {
    "git", "wget", "curl", "zsh", "starship", "bat", "eza"
}

M.dev = {
    base = { "neovim", "docker", "docker-compose" },
    python = { "python", "pyenv", "poetry" },
    node = { "nodejs", "npm", "pnpm" }
}

M.hyprland = {
    "hyprland", "waybar", "hyprpaper", "mako", "cliphist"
}

return M
```

### Exemplo B: `lua/core/utils.lua` (Wrapper de Sistema)
```lua
-- core/utils.lua
local M = {}

function M.print_info(msg)
    print("\27[34m[INFO]\27[0m " .. msg)
end

function M.run_cmd(cmd)
    local success = os.execute(cmd)
    if not success then
        print("\27[31m[ERRO]\27[0m Falha ao executar: " .. cmd)
        os.exit(1)
    end
end

-- Equivalente ao pacman -S pacote
function M.install_packages(package_table)
    local pkg_string = table.concat(package_table, " ")
    M.print_info("Instalando: " .. pkg_string)
    M.run_cmd("sudo pacman -S --noconfirm --needed " .. pkg_string)
end

return M
```

### Exemplo C: `main.lua` (O Novo Controlador)
```lua
-- main.lua
local utils = require("lua.core.utils")
local pkgs = require("lua.data.packages")
local ecosystem = require("lua.modules.ecosystem")

utils.print_info("Iniciando a instalação do Afio Arch...")

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
