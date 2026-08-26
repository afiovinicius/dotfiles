# 📚 Guia Técnico: `aux.lua` - Todas as Funções

**Arquivo:** `src/utils/aux.lua`  
**Linhas:** 500+  
**Dependências:** `src.core.envs`

---

## 🎨 FUNÇÕES LEGADAS (Bash → Lua)

### 1. `aux.pf(message, color_type)`

Print formatado com timestamp e cores ANSI.

**Parâmetros:**
- `message` (string): Mensagem a exibir
- `color_type` (string, opcional): 'error', 'warn', 'success' ou padrão (cyan)

**Retorno:** Nada (void)

**Exemplo:**
```lua
local aux = require("src.utils.aux")

aux.pf("Sistema iniciado", "success")      -- Verde
aux.pf("Processando...", "warn")           -- Amarelo
aux.pf("Erro na instalação", "error")      -- Vermelho
aux.pf("Informação", nil)                  -- Cyan (padrão)
```

**Output:**
```
[14:30:45] - ✅ Sistema iniciado
[14:30:46] - ⚠️ Processando...
[14:30:47] - ❌ Erro na instalação
[14:30:48] - ℹ️ Informação
```

---

### 2. `aux.plist(items)`

Lista items com índice numérico (formatado).

**Parâmetros:**
- `items` (table): Array de strings para listar

**Retorno:** Nada (void)

**Exemplo:**
```lua
aux.plist({"git", "neovim", "docker"})
```

**Output:**
```
[1]: git
[2]: neovim
[3]: docker
```

---

### 3. `aux.run_cmd_valid(cmd, description)`

Executa comando com validação e feedback automático.

**Parâmetros:**
- `cmd` (string): Comando shell a executar
- `description` (string): Descrição da operação (usada no feedback)

**Retorno:** boolean (true se sucesso, false se erro)

**Exemplo:**
```lua
-- Sucesso
if aux.run_cmd_valid("mkdir -p ~/.config", "Criando diretório") then
  aux.pf("Próximo passo...", "success")
end

-- Erro
aux.run_cmd_valid("rm /etc/important_file", "Deletando arquivo")
-- Output: "❌ Falha em Deletando arquivo."
```

---

## 🎯 WRAPPERS DE GUM - MENUS INTERATIVOS

### 4. `aux.choose(prompt, options)`

Menu single-select com navegação por setas (↑↓).

**Parâmetros:**
- `prompt` (string): Pergunta a exibir
- `options` (table): Array de opções string

**Retorno:** string (opção selecionada) ou nil (cancelado)

**Exemplo:**
```lua
local cpu = aux.choose("Qual sua CPU?", {
  "AMD Ryzen",
  "Intel Core",
  "Nenhuma"
})

if cpu == "AMD Ryzen" then
  aux.pf("AMD selecionado", "success")
elseif cpu == nil then
  aux.pf("Usuário cancelou", "warn")
end
```

**Comportamento:**
- Setas ↑↓ para navegar
- Enter para confirmar
- Ctrl+C para cancelar (retorna nil)

---

### 5. `aux.multiselect(prompt, options)`

Menu multi-select com marca/desmarca via espaço.

**Parâmetros:**
- `prompt` (string): Pergunta/header a exibir
- `options` (table): Array de opções string

**Retorno:** table (array de opções selecionadas) ou {} (nenhuma)

**Exemplo:**
```lua
local categories = aux.multiselect(
  "Quais categorias instalar? (Espaço: marca | Enter: confirma)",
  {
    "Desenvolvimento",
    "Games",
    "Áudio & Multimídia",
    "Fontes"
  }
)

for _, cat in ipairs(categories) do
  aux.pf("Selecionado: " .. cat, "success")
end

-- Saída se user marcou "Desenvolvimento" e "Games":
-- [14:31:23] - ✅ Selecionado: Desenvolvimento
-- [14:31:23] - ✅ Selecionado: Games
```

**Comportamento:**
- Setas ↑↓ para navegar
- Espaço para marcar/desmarcar (✔ ☐)
- Enter para confirmar
- Ctrl+C para cancelar (retorna {})

---

### 6. `aux.confirm(prompt)`

Confirmação sim/não interativa.

**Parâmetros:**
- `prompt` (string): Pergunta a confirmar

**Retorno:** boolean (true = Confirmar, false = Cancelar)

**Exemplo:**
```lua
if aux.confirm("Deseja continuar com a instalação?") then
  aux.pf("Prosseguindo...", "warn")
  -- executar instalação
else
  aux.pf("Cancelado pelo usuário", "warn")
end
```

**Comportamento:**
- Tab ou setas para trocar opção
- Enter para confirmar
- Mostra visualmente: ◉ Confirmar  ○ Cancelar

---

### 7. `aux.spinner(cmd, message)`

Executa comando com spinner visual (animado).

**Parâmetros:**
- `cmd` (string): Comando shell a executar (ou "" para apenas mostrar mensagem)
- `message` (string): Mensagem a exibir durante execução

**Retorno:** boolean (true se sucesso, false se erro)

**Exemplo:**
```lua
-- Instalar com spinner
aux.spinner(
  "sudo pacman -S --noconfirm git neovim",
  "Instalando pacotes..."
)

-- Apenas mostrar mensagem
aux.spinner("", "Processando dados...")

-- Com validação
if aux.spinner("npm install", "Instalando dependências npm") then
  aux.pf("NPM OK", "success")
else
  aux.pf("Falha no npm", "error")
end
```

**Visual:**
```
⠹ Instalando pacotes...   (animação de pontos girando)
✔ Instalando pacotes...   (quando termina com sucesso)
✖ Instalando pacotes...   (quando tem erro)
```

---

### 8. `aux.panel(title, content)`

Exibe painel visual com título e conteúdo.

**Parâmetros:**
- `title` (string): Título do painel
- `content` (string): Conteúdo/corpo do painel

**Retorno:** Nada (void) - apenas exibe

**Exemplo:**
```lua
aux.panel(
  "📋 RESUMO DA INSTALAÇÃO",
  "Pacotes a instalar: 247\n" ..
  "Tamanho total: 2.5 GB\n" ..
  "Tempo estimado: 15 minutos"
)
```

**Output:**
```
┌─ 📋 RESUMO DA INSTALAÇÃO ─┐
Pacotes a instalar: 247
Tamanho total: 2.5 GB
Tempo estimado: 15 minutos
└──────────────────────────┘
```

---

## 📦 FUNÇÕES DE INSTALAÇÃO

### 9. `aux.organize_categories(category_map, packages)`

Separa categorias em "auto-install" vs "user-select".

**Parâmetros:**
- `category_map` (table): Mapa `{nome_categoria -> {subcategorias}}`
- `packages` (table): Tabela de pacotes (require "src.core.packages")

**Retorno:** Nada (modifica estado interno)

**Exemplo:**
```lua
local categories = {
  ["Desenvolvimento"] = {"DEVELOPMENT", "PYTHON", "NODE"},
  ["Games"] = {"GAMING", "GAMING_LIBS"},
  ["Fontes"] = {"FONTS"},
}

aux.organize_categories(categories, packages)
-- Interno: organiza o que vai ser auto-install vs user-select
```

---

### 10. `aux.show_selection_summary(selected_categories, packages)`

Exibe resumo visual das seleções antes de instalar.

**Parâmetros:**
- `selected_categories` (table): Array de categorias selecionadas pelo usuário
- `packages` (table): Tabela de pacotes

**Retorno:** Nada (void) - apenas exibe

**Exemplo:**
```lua
local selected = {"Desenvolvimento", "Games"}
aux.show_selection_summary(selected, packages)
```

**Output:**
```
📋 RESUMO DA INSTALAÇÃO

  🔒 [OBRIGATÓRIO] Base do Sistema:
    ◆ base - Pacotes essenciais...
    ◆ linux-firmware - Firmware...
    ...

  ✓ Categorias Selecionadas:

    📦 Desenvolvimento:
    (Pacotes desta categoria)

    📦 Games:
    (Pacotes desta categoria)

  Total: 247 pacotes a instalar
```

---

### 11. `aux.interactive_install(category_map, packages)`

Fluxo completo de seleção interativa com confirmação.

**Parâmetros:**
- `category_map` (table): Mapa de categorias
- `packages` (table): Tabela de pacotes

**Retorno:** table (array de nomes de pacotes finais validados)

**Exemplo:**
```lua
local categories = {
  ["Desenvolvimento"] = {"DEVELOPMENT", "PYTHON", "NODE"},
  ["Games"] = {"GAMING"},
}

local final_packages = aux.interactive_install(categories, packages)

-- Retorna algo como:
-- {"base", "git", "python", "nodejs", "steam", ...}
```

**Fluxo Interno:**
1. Exibe multi-select para usuário escolher categorias
2. Valida seleção (obriga marcar algo)
3. Exibe resumo com aux.show_selection_summary
4. Pede confirmação
5. Se negar: volta ao multi-select
6. Se confirmar: retorna array de pacotes

---

### 12. `aux.execute_installation(packages_to_install)`

Executa instalação real com validação de segurança.

**Parâmetros:**
- `packages_to_install` (table): Array de nomes de pacotes

**Retorno:** boolean (true se sucesso, false se erro)

**Exemplo:**
```lua
local packages_to_install = {
  "base", "git", "vim", "docker"
}

if aux.execute_installation(packages_to_install) then
  aux.pf("Instalação completa!", "success")
else
  aux.pf("Erro na instalação", "error")
end
```

**Segurança Implementada:**
1. ✅ Verifica se há pacotes (não deixa instalar vazio)
2. ✅ Remove duplicatas automaticamente
3. ✅ Exibe comando antes de executar (auditoria)
4. ✅ Pede confirmação final
5. ✅ Executa com spinner visual
6. ✅ Trata erros e exibe feedback

---

## 🔒 VALIDAÇÃO E SEGURANÇA

### 13. `aux.validate_packages(packages_to_check, valid_packages)`

Valida lista de pacotes contra pacotes conhecidos.

**Parâmetros:**
- `packages_to_check` (table): Array de pacotes a validar
- `valid_packages` (table): Tabela de pacotes (require "src.core.packages")

**Retorno:** table, table (válidos, inválidos)

**Exemplo:**
```lua
local to_check = {"git", "vim", "pacote_inexistente"}
local valid, invalid = aux.validate_packages(to_check, packages)

print("Válidos:", #valid)     -- 2
print("Inválidos:", #invalid) -- 1

for _, pkg in ipairs(invalid) do
  aux.pf("Pacote desconhecido: " .. pkg, "error")
end
```

---

### 14. `aux.is_arch_linux()`

Verifica se está rodando em Arch Linux.

**Parâmetros:** Nenhum

**Retorno:** boolean (true = Arch, false = outro)

**Exemplo:**
```lua
if not aux.is_arch_linux() then
  aux.pf("Este script requer Arch Linux", "error")
  os.exit(1)
end
```

---

### 15. `aux.has_gum()`

Verifica se gum está instalado e acessível.

**Parâmetros:** Nenhum

**Retorno:** boolean (true = gum disponível, false = não)

**Exemplo:**
```lua
if not aux.has_gum() then
  aux.pf("gum não está instalado. Execute: sudo pacman -S gum", "error")
  os.exit(1)
end
```

---

## 🔄 Fluxo Completo de Uso

```lua
local aux = require("src.utils.aux")
local envs = require("src.core.envs")
local packages = require("src.core.packages")

-- 1. Validações iniciais
if not aux.is_arch_linux() then
  aux.pf("Apenas Arch Linux", "error")
  os.exit(1)
end

if not aux.has_gum() then
  aux.pf("Instale gum: sudo pacman -S gum", "error")
  os.exit(1)
end

-- 2. Exibir banner
os.execute("clear")
print(envs.BANNER)

-- 3. Menu de categorias
local categories = {
  ["Desenvolvimento"] = {"DEVELOPMENT", "PYTHON", "NODE"},
  ["Games"] = {"GAMING"},
}

-- 4. Fluxo interativo
local final_packages = aux.interactive_install(categories, packages)

-- 5. Executar instalação
if aux.execute_installation(final_packages) then
  aux.pf("Sistema pronto!", "success")
else
  aux.pf("Instalação incompleta", "warn")
end
```

---

## 📊 Tabela de Referência Rápida

| Função | Tipo | Uso | Retorna |
|--------|------|-----|---------|
| `pf()` | Print | Feedback visual | - |
| `plist()` | Print | Listar items | - |
| `run_cmd_valid()` | Exec | Executar com feedback | bool |
| `choose()` | Menu | Single-select | string |
| `multiselect()` | Menu | Multi-select | table |
| `confirm()` | Menu | Sim/Não | bool |
| `spinner()` | Exec | Cmd com animação | bool |
| `panel()` | Print | Painel formatado | - |
| `organize_categories()` | Util | Separar categorias | - |
| `show_selection_summary()` | Print | Resumo das seleções | - |
| `interactive_install()` | Flow | Fluxo completo | table |
| `execute_installation()` | Exec | Instalar pacotes | bool |
| `validate_packages()` | Check | Validar pacotes | table, table |
| `is_arch_linux()` | Check | Verificar distro | bool |
| `has_gum()` | Check | Verificar gum | bool |

---

## 🎓 Padrões de Uso

### Padrão 1: Confirmação Simples
```lua
if aux.confirm("Deseja continuar?") then
  -- fazer algo
end
```

### Padrão 2: Menu com Tratamento de Erro
```lua
local choice = aux.choose("Escolha:", options)
if choice == nil then
  aux.pf("Cancelado", "warn")
  return
end
-- usar choice
```

### Padrão 3: Instalação Segura
```lua
if aux.spinner(cmd, "Instalando...") then
  aux.pf("OK", "success")
else
  aux.pf("ERRO", "error")
  -- recuperação
end
```

### Padrão 4: Fluxo Completo
```lua
local selected = aux.multiselect("Escolha:", options)
if #selected == 0 then return end

aux.show_selection_summary(selected, packages)
if aux.confirm("Prosseguir?") then
  aux.execute_installation(selected)
end
```

---

## ⚠️ Erros Comuns

### Erro: "gum: comando não encontrado"
```lua
-- ❌ ERRADO: usar aux sem gum
aux.choose("Escolha:", options)

-- ✅ CORRETO: verificar antes
if not aux.has_gum() then
  aux.pf("Instale: sudo pacman -S gum", "error")
  os.exit(1)
end
```

### Erro: Esquecer de verificar retorno nil
```lua
-- ❌ ERRADO
local choice = aux.choose("Escolha:", options)
print(choice .. " selecionado")  -- crash se choice == nil

-- ✅ CORRETO
local choice = aux.choose("Escolha:", options)
if choice then
  print(choice .. " selecionado")
end
```

### Erro: Não validar pacotes antes de instalar
```lua
-- ❌ ERRADO
aux.execute_installation(user_input_packages)

-- ✅ CORRETO
local valid, invalid = aux.validate_packages(user_input, packages)
if #invalid > 0 then
  aux.pf("Pacotes inválidos encontrados", "error")
  return
end
aux.execute_installation(valid)
```

---

**Pronto para usar!** 🚀
