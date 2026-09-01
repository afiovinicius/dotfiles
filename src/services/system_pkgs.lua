--- ============================================================================
--- AFIO ARCH - INSTALAÇÃO DOS PACOTES PADRÕES PARA O SISTEMA
--- ============================================================================
--- Funções auxiliares para instalar os pacotes de configuração do sistema para
--- entregar um Arch Linux com a base pronta para instalação de qualquer DE
--- ============================================================================

local systemBase = {}
local aux = require("src.utils.aux")
local envs = require("src.core.envs")
local packages = require("src.core.packages")

--- ============================================================================
--- FUNÇÕES DE INSTALAÇÃO
--- ============================================================================

function systemBase.install_base_packages()
  aux.panel("Instalação de Pacotes Base")

  local all_base_packages = {}
  local packages_by_category = {}

  for _, category_name in ipairs(aux.groups_categories["Pacotes Padrões"]) do
    local cat_pkgs = aux.get_category(category_name) or {}
    local pkg_names = aux.get_names(cat_pkgs)

    packages_by_category[category_name] = pkg_names

    for _, name in ipairs(pkg_names) do
      table.insert(all_base_packages, name)
    end
  end

  if #all_base_packages == 0 then
    aux.pf("Nenhum pacote para instalar", "warn")
    return false
  end

  local cmd = envs.SYSTEM.PKG_MANAGER_INSTALL .. " " .. table.concat(all_base_packages, " ")

  local success = aux.run_cmd_valid(cmd, "[Pacotes Base] ")

  if success then
    for cat_name, pkgs in pairs(packages_by_category) do
      aux.register_installed_packages(cat_name, pkgs)
    end
  end

  return success
end


function systemBase.install_display_server_packages()
  aux.panel("Seleção de Servidor Gráfico")

  local display_options = { "Xorg (X11)", "Wayland" }
  local selected_display = aux.choose_per_number("Qual servidor de exibição deseja usar?", display_options)

  if selected_display == nil then
    aux.pf("Seleção de servidor gráfico cancelada", "error")
    return false
  end

  local display_vendor = (selected_display:match("Xorg")) and "XORG" or "WAYLAND"

  envs.DYNAMIC.DISPLAY_SERVER = display_vendor:lower()

  print()
  print(envs.COLORS.YELLOW .. "  → Selecionado: " .. selected_display .. envs.COLORS.RESET)

  if packages.DISPLAY_SERVERS[display_vendor] then
    local display_packages = aux.get_names(packages.DISPLAY_SERVERS[display_vendor])

    print()
    print(envs.COLORS.DIM .. "Pacotes a instalar:" .. envs.COLORS.RESET)
    for _, pkg in ipairs(display_packages) do
      print("  • " .. pkg)
    end

    local cmd = envs.SYSTEM.PKG_MANAGER_INSTALL .. " " .. table.concat(display_packages, " ")
    local success = aux.run_cmd_valid(cmd, "[Drivers " .. display_vendor .. "] ")
    
    if success then
      aux.register_installed_packages("DISPLAY_SERVER_" .. display_vendor, display_packages)
    end
    return success
  end
end

function systemBase.install_cpu_packages()
  aux.panel("Seleção de Processador (CPU)")

  local cpu_options = { "AMD Ryzen", "Intel Core" }
  local selected_cpu = aux.choose_per_number("Qual é seu o processador?", cpu_options)

  if not selected_cpu then
    aux.pf("Seleção de CPU cancelada.", "error")
    return false
  end

  local cpu_vendor = (selected_cpu == "AMD Ryzen") and "AMD" or "INTEL"
  
  envs.DYNAMIC.CPU_VENDOR = cpu_vendor

  print(envs.COLORS.YELLOW .. "  → Selecionado: " .. selected_cpu .. envs.COLORS.RESET)

  local cpu_category = (cpu_vendor == "AMD") and packages.CPU_DRIVERS.AMD or packages.CPU_DRIVERS.INTEL

  if cpu_category and #cpu_category > 0 then
    local cpu_packages = aux.get_names(cpu_category)
    print()
    print(envs.COLORS.DIM .. "Pacotes a instalar:" .. envs.COLORS.RESET)
    for _, pkg in ipairs(cpu_category) do
      print("  • " .. pkg.name)
    end

    local cmd = envs.SYSTEM.PKG_MANAGER_INSTALL .. " " .. table.concat(cpu_packages, " ")
    local success = aux.run_cmd_valid(cmd, "[Drivers " .. cpu_vendor .. "] ")

    if success then
      aux.register_installed_packages("CPU_" .. cpu_vendor, cpu_packages)
    end
    return success
  end
end

function systemBase.install_gpu_packages()
  aux.panel("Seleção de Placa Gráfica (GPU)")

  local gpu_options = { "AMD", "NVIDIA", "Intel" }
  local selected_gpus = aux.multiselect(
    "Quais placas gráficas deseja suporte? (Espaço: marcar | Enter: confirmar)",
    gpu_options
  )

  if #selected_gpus == 0 then
    aux.pf("Nenhuma GPU selecionada. Pulando instalação de drivers GPU.", "warn")
    return true
  end

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

  local all_success = true

  for _, vendor in ipairs(unique_vendors) do
    if packages.GPU_DRIVERS[vendor] then
      local gpu_packages = aux.get_names(packages.GPU_DRIVERS[vendor])

      print()
      print(envs.COLORS.DIM .. "Pacotes " .. vendor .. " a instalar:" .. envs.COLORS.RESET)
      for _, pkg in ipairs(gpu_packages) do
        print("  • " .. pkg)
      end

      local cmd = envs.SYSTEM.PKG_MANAGER_INSTALL .. " " .. table.concat(gpu_packages, " ")
      local success = aux.run_cmd_valid(cmd, "[Drivers GPU " .. vendor .. "] ")

      if success then
        aux.register_installed_packages("GPU_" .. vendor, gpu_packages)
      else
        all_success = false
      end
    end
  end

  return all_success
end

--- ============================================================================
--- EXPORTAÇÃO DO MÓDULO
--- ============================================================================

return systemBase