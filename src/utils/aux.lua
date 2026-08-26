--- ============================================================================
--- 🎨 AFIO ARCH - AUXILIARY FUNCTIONS & GUM WRAPPERS
--- ============================================================================
--- Módulo com funções auxiliares de renderização, gum wrappers para UX
--- e lógica de instalação de pacotes com segurança e validação.
--- ============================================================================

local aux = {}
local envs = require("src.core.envs")
local packages = require("src.core.packages")

--- ============================================================================
--- 🎯 FUNÇÕES LEGADAS (pf, plist, pkg_i, run_cmd_valid)
--- ============================================================================

--- Imprime mensagem formatada com timestamp e cor
-- @param message string: Mensagem a exibir
-- @param color_type string: 'error', 'warn', 'success' ou padrão (cyan)
function aux.pf(message, color_type)
  local timestamp = os.date("%H:%M:%S")
  local color_code = envs.COLORS.CYAN

  if color_type == "error" then
    color_code = envs.COLORS.RED
  elseif color_type == "warn" then
    color_code = envs.COLORS.YELLOW
  elseif color_type == "success" then
    color_code = envs.COLORS.GREEN
  end

  local formatted = string.format(
    "\n%s[%s]%s - %s%s%s\n",
    envs.COLORS.BOLD,
    timestamp,
    envs.COLORS.RESET,
    color_code,
    message,
    envs.COLORS.RESET
  )

  io.write(formatted)
end

--- Lista items com índice
-- @param items table: Array de strings para listar
function aux.plist(items)
  local count = 1
  for _, item in ipairs(items) do
    print(string.format(
      "%s[%d]: %s%s",
      envs.COLORS.CYAN .. envs.COLORS.BOLD,
      count,
      item,
      envs.COLORS.RESET
    ))
    count = count + 1
  end
end

--- Executa comando com tratamento de erro e feedback visual
-- @param cmd string: Comando a executar
-- @param description string: Descrição da operação
-- @return boolean: true se sucesso, false se erro
function aux.run_cmd_valid(cmd, description)
  local result = os.execute(cmd)
  local success = (result == true or result == 0)

  if success then
    aux.pf(description .. " concluído!", "success")
  else
    aux.pf("Falha em " .. description .. ".", "error")
  end

  return success
end

--- ============================================================================
--- 🎯 WRAPPERS DE GUM - MENU INTERATIVO
--- ============================================================================

--- Menu single-select com gum
-- @param prompt string: Pergunta a exibir
-- @param options table: Array de opções
-- @return string: Opção selecionada
function aux.choose(prompt, options)
  if #options == 0 then
    aux.pf("Nenhuma opção disponível", "warn")
    return nil
  end

  local opts_formatted = {}
  for _, opt in ipairs(options) do
    table.insert(opts_formatted, string.format('"%s"', opt))
  end
  local opts_str = table.concat(opts_formatted, " ")

  local cmd = string.format('gum choose --header="%s" %s 2>/dev/null', prompt, opts_str)
  local handle = io.popen(cmd)
  if not handle then
    aux.pf("Erro ao abrir gum choose", "error")
    return nil
  end

  local result = handle:read("*l")
  handle:close()

  if result == nil or result == "" then
    aux.pf("Seleção cancelada", "warn")
    return nil
  end

  return result
end

--- Menu multi-select com gum (espaço para marcar, enter para confirmar)
-- @param prompt string: Pergunta a exibir
-- @param options table: Array de opções
-- @return table: Array de opções selecionadas
function aux.multiselect(prompt, options)
  if #options == 0 then
    aux.pf("Nenhuma opção disponível", "warn")
    return {}
  end

  local opts_formatted = {}
  for _, opt in ipairs(options) do
    table.insert(opts_formatted, string.format('"%s"', opt))
  end
  local opts_str = table.concat(opts_formatted, " ")

  local cmd = string.format(
    'gum choose --no-limit --header="%s" %s 2>/dev/null',
    prompt,
    opts_str
  )

  local handle = io.popen(cmd)
  if not handle then
    aux.pf("Erro ao abrir gum multiselect", "error")
    return {}
  end

  local selected = {}
  for line in handle:lines() do
    if line ~= "" then
      table.insert(selected, line)
    end
  end
  handle:close()

  return selected
end

--- Confirmação sim/não com gum
-- @param prompt string: Pergunta a exibir
-- @return boolean: true se confirmado, false se negado
function aux.confirm(prompt)
  local cmd = string.format(
    'gum confirm "%s" --affirmative="Confirmar" --negative="Cancelar" 2>/dev/null',
    prompt
  )
  local result = os.execute(cmd)
  return result == true or result == 0
end

--- Spinner visual durante execução de comando
-- @param cmd string: Comando a executar
-- @param message string: Mensagem a exibir durante execução
-- @return boolean: true se sucesso, false se erro
function aux.spinner(cmd, message)
  if cmd == "" or cmd == nil then
    aux.pf(message, "warn")
    return true
  end

  local spin_cmd = string.format(
    'gum spin --spinner dot --title="%s" -- sh -c \'%s\' 2>&1',
    message,
    cmd:gsub("'", "'\\''")
  )

  local result = os.execute(spin_cmd)
  return result == true or result == 0
end

--- Painel visual com título e conteúdo
-- @param title string: Título do painel
-- @param content string: Conteúdo do painel
function aux.panel(title, content)
  print()
  print(envs.COLORS.BOLD .. envs.COLORS.BLUE .. "┌─ " .. title .. " ─┐" .. envs.COLORS.RESET)
  print(content)
  print(envs.COLORS.BOLD .. envs.COLORS.BLUE .. "└─────────┘" .. envs.COLORS.RESET)
  print()
end

--- ============================================================================
--- 📦 GERENCIADOR DE INSTALAÇÃO DE PACOTES
--- ============================================================================

--- Estrutura interna para armazenar pacotes selecionados
local installation_state = {
  auto_install = {},      -- Categorias sem subcategorias (instaladas silenciosamente)
  user_selected = {},     -- Categorias com subcategorias (usuário escolhe)
  final_packages = {},    -- Lista final de pacotes a instalar
}

--- Processa categorias e separa em auto-install vs user-select
-- @param category_map table: Mapa de categorias {nome -> {sub1, sub2}}
-- @param packages table: Tabela de pacotes (require("src.core.packages"))
function aux.organize_categories(category_map, packages)
  installation_state.auto_install = {}
  installation_state.user_selected = {}

  for category_name, subcategories in pairs(category_map) do
    -- Verifica se tem subcategorias
    if type(subcategories) == "table" and #subcategories > 1 then
      -- Tem subcategorias -> vai para user_selected
      table.insert(installation_state.user_selected, {
        name = category_name,
        subcategories = subcategories,
        packages = packages
      })
    else
      -- Sem subcategorias -> vai para auto_install
      local sub_key = subcategories[1] or subcategories
      table.insert(installation_state.auto_install, {
        name = category_name,
        key = sub_key
      })
    end
  end
end

--- Exibe resumo visual das seleções
-- @param selected_categories table: Categorias selecionadas pelo usuário
-- @param packages table: Tabela de pacotes
function aux.show_selection_summary(selected_categories, packages)
  os.execute("clear")

  print(envs.COLORS.BOLD .. envs.COLORS.CYAN .. "📋 RESUMO DA INSTALAÇÃO" .. envs.COLORS.RESET)
  print()

  local total_packages = 0
  local all_packages = {}

  -- Pacotes OBRIGATÓRIOS (DEFAULT)
  print(envs.COLORS.RED .. "  🔒 [OBRIGATÓRIO] Base do Sistema:" .. envs.COLORS.RESET)
  local default_pkgs = packages.get_category("DEFAULT") or {}
  for _, pkg in ipairs(default_pkgs) do
    print(string.format(
      "    %s◆%s %-25s %s%s%s",
      envs.COLORS.YELLOW,
      envs.COLORS.RESET,
      pkg.name,
      envs.COLORS.DIM,
      pkg.desc,
      envs.COLORS.RESET
    ))
    table.insert(all_packages, pkg.name)
    total_packages = total_packages + 1
  end

  -- Pacotes SELECIONADOS
  print()
  print(envs.COLORS.GREEN .. "  ✓ Categorias Selecionadas:" .. envs.COLORS.RESET)

  for _, cat in ipairs(selected_categories) do
    print()
    print(envs.COLORS.CYAN .. "    📦 " .. cat .. ":" .. envs.COLORS.RESET)

    -- Aqui entraria a lógica para listar pacotes dessa categoria
    -- Por enquanto, apenas mostramos placeholder
    print(envs.COLORS.DIM .. "    (Pacotes desta categoria)" .. envs.COLORS.RESET)
  end

  print()
  print(envs.COLORS.BOLD .. "  Total: " .. total_packages .. " pacotes a instalar" .. envs.COLORS.RESET)
  print()
end

--- Função principal de seleção e instalação com validação
-- @param category_map table: Mapa de categorias
-- @param packages table: Tabela de pacotes
-- @return table: Pacotes finais validados para instalação
function aux.interactive_install(category_map, packages)
  local confirmed = false
  local selected_categories = {}

  while not confirmed do
    -- Coleta opções de categorias
    local category_options = {}
    for label, _ in pairs(category_map) do
      table.insert(category_options, label)
    end

    -- Menu multi-select
    selected_categories = aux.multiselect(
      "Selecione as categorias desejadas (Espaço: marcar | Enter: avançar):",
      category_options
    )

    -- Validação: obriga seleção
    if #selected_categories == 0 then
      print()
      aux.pf("Seleção vazia! Escolha ao menos uma categoria para prosseguir.", "error")
      print(envs.COLORS.YELLOW .. "Pressione ENTER para tentar novamente..." .. envs.COLORS.RESET)
      io.read("l")
      os.execute("clear")
    else
      -- Exibe resumo
      aux.show_selection_summary(selected_categories, packages)

      -- Pede confirmação final
      confirmed = aux.confirm("Deseja confirmar a instalação destes pacotes?")

      if not confirmed then
        os.execute("clear")
        aux.pf("Voltando ao menu de seleção...", "warn")
      else
        -- Compilar lista final de pacotes
        installation_state.final_packages = packages.get_names(
          packages.get_category("DEFAULT") or {}
        )

        for _, cat_label in ipairs(selected_categories) do
          local subcategories = category_map[cat_label]
          if type(subcategories) == "table" then
            for _, sub_key in ipairs(subcategories) do
              local sub_pkgs = packages.get_category(sub_key) or {}
              for _, pkg in ipairs(sub_pkgs) do
                table.insert(installation_state.final_packages, pkg.name)
              end
            end
          end
        end
      end
    end
  end

  return installation_state.final_packages
end

--- Executa instalação com validação de segurança
-- @param packages_to_install table: Array de nomes de pacotes
-- @return boolean: true se sucesso, false se erro
function aux.execute_installation(packages_to_install)
  if #packages_to_install == 0 then
    aux.pf("Nenhum pacote para instalar", "warn")
    return false
  end

  -- Remove duplicatas
  local unique_packages = {}
  local seen = {}
  for _, pkg in ipairs(packages_to_install) do
    if not seen[pkg] then
      seen[pkg] = true
      table.insert(unique_packages, pkg)
    end
  end

  print()
  aux.pf("Iniciando instalação de " .. #unique_packages .. " pacotes...", "warn")
  print()

  -- Gera e valida comando
  local cmd = envs.SYSTEM.PKG_MANAGER_INSTALL .. " " .. table.concat(unique_packages, " ")

  -- Exibe comando (para auditoria)
  print(envs.COLORS.DIM .. "Comando: " .. cmd .. envs.COLORS.RESET)
  print()

  -- Pede confirmação final de segurança
  if not aux.confirm("Executar este comando de instalação?") then
    aux.pf("Instalação cancelada pelo usuário", "warn")
    return false
  end

  -- Executa instalação com spinner
  local success = aux.spinner(cmd, "Instalando pacotes...")

  if success then
    print()
    aux.pf("Todos os pacotes foram instalados com sucesso!", "success")
  else
    print()
    aux.pf("Erro durante a instalação. Verifique os logs acima.", "error")
  end

  return success
end

--- ============================================================================
--- 🔒 VALIDAÇÃO E SEGURANÇA
--- ============================================================================

--- Valida lista de pacotes contra pacotes conhecidos
-- @param packages_to_check table: Array de pacotes
-- @param valid_packages table: Tabela de pacotes válidos
-- @return table, table: pacotes válidos e pacotes inválidos

aux.groups_categories = {
  ["Pacotes Padrões"]        = { packages.DEFAULT, packages.MULTIMEDIA_BASE, packages.AUDIO, packages.FONTS },
  ["Desenvolvimento"]        = { packages.DEVELOPMENT, packages.PYTHON, packages.NODE, packages.RUST, packages.ENGINEERING },
  ["Games & Emulação"]       = { packages.GAMING, packages.GAMING_LIBS },
  ["Áudio & Multimídia"]     = { packages.MEDIA_TOOLS },
  ["Internet & Comunicação"] = { packages.INTERNET },
  ["Ferramentas de Design"]  = { packages.GRAPHICS },
  ["Utilitários do Sistema"] = { packages.ACCESSORIES },
  ["Segurança & Firewall"]   = { packages.SECURITY },
  ["Ambiente Hyprland"]      = { packages.HYPRLAND_EXTRA },
  ["Ambiente KDE Plasma"]    = { packages.KDE_EXTRA },
  ["Pacotes do AUR"]         = { packages.AUR },
}

function aux.validate_packages(packages_to_check, valid_packages)
  local valid = {}
  local invalid = {}
  local known_packages = {}

  -- Monta set de pacotes conhecidos
  for _, category_name in ipairs({"DEFAULT", "DEVELOPMENT", "GAMING", "GRAPHICS", "FONTS", "AUDIO"}) do
    local cat_pkgs = valid_packages.get_category(category_name) or {}
    for _, pkg in ipairs(cat_pkgs) do
      known_packages[pkg.name] = true
    end
  end

  -- Valida cada pacote
  for _, pkg_name in ipairs(packages_to_check) do
    if known_packages[pkg_name] then
      table.insert(valid, pkg_name)
    else
      table.insert(invalid, pkg_name)
    end
  end

  return valid, invalid
end

--- Verifica se está em Arch Linux
-- @return boolean: true se Arch Linux, false caso contrário
function aux.is_arch_linux()
  local result = os.execute("pacman --version >/dev/null 2>&1")
  return result == true or result == 0
end

--- Verifica se gum está instalado
-- @return boolean: true se gum disponível, false caso contrário
function aux.has_gum()
  local result = os.execute("command -v gum >/dev/null 2>&1")
  return result == true or result == 0
end

function aux.show_banner()
  os.execute("clear")
  print(envs.COLORS.CYAN .. envs.BANNER .. envs.COLORS.RESET)
  print(envs.COLORS.BOLD .. "  " .. envs.PROJECT_NAME .. " v" .. envs.PROJECT_VERSION .. envs.COLORS.RESET .. "\n")
  print(envs.COLORS.DIM .. "  " .. envs.MESSAGES.WELCOME .. envs.COLORS.RESET)
  print()
end

--- ============================================================================
--- 📤 EXPORTAÇÃO DO MÓDULO
--- ============================================================================

return aux