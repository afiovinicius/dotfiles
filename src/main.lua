--- ============================================================================
--- 🚀 AFIO ARCH - MAIN ORCHESTRATOR (FASE 3)
--- ============================================================================
--- Orquestrador principal que coordena todo o fluxo de instalação.
--- Usa aux.lua para interação e packages.lua para dados.
--- ============================================================================

local envs = require("src.core.envs")
local aux = require("src.utils.aux")
local packages = require("src.core.packages")

--- ============================================================================
--- 🔧 FUNÇÕES AUXILIARES
--- ============================================================================

--- Pausa e aguarda usuário pressionar ENTER
local function pause_screen()
  print(envs.COLORS.YELLOW .. "Pressione ENTER para continuar..." .. envs.COLORS.RESET)
  local _ = io.read()
end

--- Limpa tela e exibe mensagem de instrução
local function show_restart_instruction()
  os.execute("clear")
  print()
  aux.pf("Instalação cancelada", "warn")
  print()
  print(envs.COLORS.BOLD .. "Para reiniciar a instalação, execute:" .. envs.COLORS.RESET)
  print()
  print(envs.COLORS.CYAN .. "  " .. envs.PATHS.DOTFILES .. "/init-setup" .. envs.COLORS.RESET)
  print()
end

--- Instala drivers de CPU
local function install_cpu_drivers()
  print()
  aux.pf("Seleção de Processador (CPU)", "warn")
  print()

  local cpu_options = { "AMD Ryzen", "Intel Core" }
  local selected_cpu = aux.choose("Qual é seu processador?", cpu_options)

  if selected_cpu == nil then
    aux.pf("Seleção de CPU cancelada", "warn")
    return false
  end

  local cpu_vendor = (selected_cpu == "AMD Ryzen") and "AMD" or "INTEL"
  envs.DYNAMIC.CPU_VENDOR = cpu_vendor

  print(envs.COLORS.YELLOW .. "  → Selecionado: " .. selected_cpu .. envs.COLORS.RESET)

  -- Obter drivers de CPU
  local cpu_category = (cpu_vendor == "AMD") and packages.CPU_DRIVERS.AMD or packages.CPU_DRIVERS.INTEL
  
  if cpu_category and #cpu_category > 0 then
    local cpu_packages = packages.get_names(cpu_category)
    print()
    print(envs.COLORS.DIM .. "Pacotes a instalar:" .. envs.COLORS.RESET)
    for _, pkg in ipairs(cpu_packages) do
      print("  • " .. pkg)
    end

    if aux.spinner(
      envs.SYSTEM.PKG_MANAGER_INSTALL .. " " .. table.concat(cpu_packages, " "),
      "Instalando drivers " .. cpu_vendor .. "..."
    ) then
      aux.pf("Drivers de CPU instalados com sucesso!", "success")
      return true
    else
      aux.pf("Erro ao instalar drivers de CPU", "error")
      return false
    end
  end

  return true
end

--- Instala drivers de GPU
local function install_gpu_drivers()
  print()
  aux.pf("Seleção de Placa Gráfica (GPU)", "warn")
  print()

  local gpu_options = { "AMD Radeon", "NVIDIA GeForce", "Intel Integrated" }
  local selected_gpus = aux.multiselect(
    "Quais placas gráficas deseja suporte? (Espaço: marcar | Enter: confirmar)",
    gpu_options
  )

  if #selected_gpus == 0 then
    aux.pf("Nenhuma GPU selecionada. Pulando instalação de drivers GPU.", "warn")
    return true
  end

  -- Mapear seleções para vendors
  local gpu_vendors_to_install = {}
  for _, gpu_name in ipairs(selected_gpus) do
    if gpu_name:match("AMD") then
      table.insert(gpu_vendors_to_install, "AMD")
    elseif gpu_name:match("NVIDIA") then
      table.insert(gpu_vendors_to_install, "NVIDIA")
    elseif gpu_name:match("Intel") then
      table.insert(gpu_vendors_to_install, "INTEL")
    end
  end

  -- Remover duplicatas
  local unique_vendors = {}
  local seen = {}
  for _, vendor in ipairs(gpu_vendors_to_install) do
    if not seen[vendor] then
      seen[vendor] = true
      table.insert(unique_vendors, vendor)
    end
  end

  envs.DYNAMIC.GPU_VENDORS = unique_vendors

  print()
  print(envs.COLORS.YELLOW .. "  → GPUs selecionadas:" .. envs.COLORS.RESET)
  for _, vendor in ipairs(unique_vendors) do
    print("     • " .. vendor)
  end

  -- Instalar drivers de cada GPU selecionada
  local all_success = true
  for _, vendor in ipairs(unique_vendors) do
    if packages.GPU_DRIVERS[vendor] then
      local gpu_packages = packages.get_names(packages.GPU_DRIVERS[vendor])
      
      print()
      print(envs.COLORS.DIM .. "Pacotes " .. vendor .. " a instalar:" .. envs.COLORS.RESET)
      for _, pkg in ipairs(gpu_packages) do
        print("  • " .. pkg)
      end

      if aux.spinner(
        envs.SYSTEM.PKG_MANAGER_INSTALL .. " " .. table.concat(gpu_packages, " "),
        "Instalando drivers " .. vendor .. "..."
      ) then
        aux.pf("Drivers " .. vendor .. " instalados!", "success")
      else
        aux.pf("Erro ao instalar drivers " .. vendor, "error")
        all_success = false
      end
    end
  end

  return all_success
end

--- Instala servidor gráfico (Xorg ou Wayland)
local function install_display_server()
  print()
  aux.pf("Seleção de Servidor Gráfico", "warn")
  print()

  local display_options = { "Xorg (X11)", "Wayland" }
  local selected_display = aux.choose("Qual servidor de exibição deseja usar?", display_options)

  if selected_display == nil then
    aux.pf("Seleção de servidor gráfico cancelada", "warn")
    return false
  end

  local display_vendor = (selected_display:match("Xorg")) and "XORG" or "WAYLAND"
  
  -- Salvar em envs.DYNAMIC para uso futuro
  envs.DYNAMIC.DISPLAY_SERVER = display_vendor:lower()

  print()
  print(envs.COLORS.YELLOW .. "  → Selecionado: " .. selected_display .. envs.COLORS.RESET)

  -- Obter pacotes de display server
  if packages.DISPLAY_SERVERS[display_vendor] then
    local display_packages = packages.get_names(packages.DISPLAY_SERVERS[display_vendor])

    print()
    print(envs.COLORS.DIM .. "Pacotes a instalar:" .. envs.COLORS.RESET)
    for _, pkg in ipairs(display_packages) do
      print("  • " .. pkg)
    end

    if aux.spinner(
      envs.SYSTEM.PKG_MANAGER_INSTALL .. " " .. table.concat(display_packages, " "),
      "Instalando " .. display_vendor .. "..."
    ) then
      aux.pf("Servidor gráfico " .. display_vendor .. " instalado!", "success")
      return true
    else
      aux.pf("Erro ao instalar servidor gráfico", "error")
      return false
    end
  end

  return true
end

--- Instala pacotes base do sistema
local function install_base_packages()
  print()
  aux.pf("Instalação de Pacotes Base", "warn")
  print()

  -- Coletar todos os pacotes base
  local base_packages_to_install = {}

  local categories_to_install = { "DEFAULT", "MULTIMEDIA_BASE", "AUDIO", "FONTS" }
  
  for _, category_name in ipairs(categories_to_install) do
    local cat_pkgs = packages.get_category(category_name) or {}
    for _, pkg in ipairs(cat_pkgs) do
      table.insert(base_packages_to_install, pkg.name)
    end
  end

  if #base_packages_to_install == 0 then
    aux.pf("Nenhum pacote base encontrado", "error")
    return false
  end

  -- Executar instalação
  if aux.execute_installation(base_packages_to_install) then
    return true
  else
    return false
  end
end

--- ============================================================================
--- 🎯 FLUXO PRINCIPAL
--- ============================================================================

local function main()
  -- 1️⃣ Validações iniciais
  if not aux.is_arch_linux() then
    print(envs.COLORS.RED .. "❌ Este script deve ser executado em Arch Linux" .. envs.COLORS.RESET)
    os.exit(1)
  end

  -- 2️⃣ Mostrar banner
  aux.show_banner()

  -- 4️⃣ Confirmação para iniciar
  if not aux.confirm("Deseja iniciar a instalação do Afio Arch?") then
    show_restart_instruction()
    return
  end

  os.execute("clear")

  -- 5️⃣ Instalar pacotes base
  print(envs.COLORS.BOLD .. "📦 FASE 1: Instalação de Pacotes Base" .. envs.COLORS.RESET)
  if not install_base_packages() then
    aux.pf("Erro na instalação de pacotes base", "error")
    return
  end

  pause_screen()
  os.execute("clear")

  -- 6️⃣ Drivers de CPU
  print(envs.COLORS.BOLD .. "💻 FASE 2: Seleção de CPU e Drivers" .. envs.COLORS.RESET)
  if not install_cpu_drivers() then
    aux.pf("Erro na instalação de drivers de CPU", "error")
    return
  end

  pause_screen()
  os.execute("clear")

  -- 7️⃣ Drivers de GPU
  print(envs.COLORS.BOLD .. "🎨 FASE 3: Seleção de GPU e Drivers" .. envs.COLORS.RESET)
  if not install_gpu_drivers() then
    aux.pf("Erro na instalação de drivers de GPU", "error")
    return
  end

  pause_screen()
  os.execute("clear")

  -- 8️⃣ Servidor Gráfico
  print(envs.COLORS.BOLD .. "🖥️  FASE 4: Seleção de Servidor Gráfico" .. envs.COLORS.RESET)
  if not install_display_server() then
    aux.pf("Erro na instalação de servidor gráfico", "error")
    return
  end

  pause_screen()
  os.execute("clear")

  -- 9️⃣ Status final
  print(envs.COLORS.BOLD .. envs.COLORS.GREEN .. "✅ BASE DO SISTEMA INSTALADA COM SUCESSO!" .. envs.COLORS.RESET)
  print()
  print("Configuração dinâmica salva:")
  print(envs.COLORS.CYAN .. "  • CPU: " .. (envs.DYNAMIC.CPU_VENDOR or "não selecionada") .. envs.COLORS.RESET)
  print(envs.COLORS.CYAN .. "  • GPU: " .. table.concat(envs.DYNAMIC.GPU_VENDORS, ", ") .. envs.COLORS.RESET)
  print(envs.COLORS.CYAN .. "  • Display Server: " .. (envs.DYNAMIC.DISPLAY_SERVER or "não selecionado") .. envs.COLORS.RESET)
  print()

  print(envs.COLORS.YELLOW .. "Próxima etapa: Instalação do Ambiente Gráfico (KDE ou Hyprland)" .. envs.COLORS.RESET)
  print()

  if aux.confirm("Deseja continuar com a configuração do Ambiente Gráfico?") then
    aux.pf("Iniciando instalação do Ambiente Gráfico...", "warn")
    -- TODO: Chamar interfaces/kde.lua ou interfaces/hyprland.lua
  else
    aux.pf("Você pode retomar a instalação mais tarde", "warn")
  end
end

--- ============================================================================
--- 🚀 EXECUÇÃO
--- ============================================================================

main()