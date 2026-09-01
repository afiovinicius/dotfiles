--- ============================================================================
--- 🚀 AFIO ARCH - MAIN ORCHESTRATOR
--- ============================================================================
--- Orquestrador principal que coordena todo o fluxo de instalação.
--- ============================================================================

local aux = require("src.utils.aux")
local envs = require("src.core.envs")
local systemBase = require("src.services.system_pkgs")
local systemConfig = require("src.services.system_config")
local desktopInstall = require("src.services.desktop_install")
local ecosystem = require("src.services.ecosystem")


local function main()
  envs.DYNAMIC.START_TIME = os.time()
  if not aux.is_arch_linux() then
    print(envs.COLORS.RED .. "❌ Este script deve ser executado em Arch Linux" .. envs.COLORS.RESET)
    os.exit(1)
  end

  aux.show_banner()

  if aux.confirm("Deseja iniciar a instalação do Afio Arch?") then
    if not systemBase.install_base_packages() then
      aux.canceled_instruction()
      return
    end

    aux.sequence()

    if not systemBase.install_display_server_packages() then
      aux.canceled_instruction()
      return
    end

    aux.sequence()

    if not systemBase.install_cpu_packages() then
      aux.canceled_instruction()
      return
    end

    aux.sequence()

    if not systemBase.install_gpu_packages() then
      aux.canceled_instruction()
      return
    end

    print(envs.COLORS.BOLD .. envs.COLORS.GREEN .. "✅ BASE DO SISTEMA INSTALADA COM SUCESSO!" .. envs.COLORS.RESET)
    print()
    print("Configuração dinâmica salva:")
    print(envs.COLORS.CYAN .. "  • CPU: " .. (envs.DYNAMIC.CPU_VENDOR or "não selecionada") .. envs.COLORS.RESET)
    print(envs.COLORS.CYAN .. "  • GPU: " .. table.concat(envs.DYNAMIC.GPU_VENDORS, ", ") .. envs.COLORS.RESET)
    print(envs.COLORS.CYAN .. "  • Display Server: " .. (envs.DYNAMIC.DISPLAY_SERVER or "não selecionado") .. envs.COLORS.RESET)
    print()

    print(envs.COLORS.YELLOW .. "Próxima etapa: Configuração do Sistema" .. envs.COLORS.RESET)
    print()
  else
    aux.canceled_instruction()
  end

  aux.sequence()

  if aux.confirm("Você gostaria de iniciar a configuração do sistema?") then
    if not systemConfig.config_pacman() then
      aux.pf("Erro ao configurar o pacman", "error")
    end

    aux.sequence()

    if not systemConfig.config_systemd() then
      aux.pf("Erro ao configurar o systemd", "error")
    end

    aux.sequence()

    if not systemConfig.config_fstab() then
      aux.pf("Erro ao configurar o fstab", "error")
    end

    aux.sequence()

    if not systemConfig.config_aur() then
      aux.pf("Erro ao configurar e instalar o aur", "error")
    end

    aux.sequence()

    if not systemConfig.config_memory() then
      aux.pf("Erro ao configurar a memória swap e zram", "error")
    end

    aux.sequence()

    if not systemConfig.config_reflector() then
      aux.pf("Erro ao configurar o reflector", "error")
    end

    aux.sequence()

    print()
    print(envs.COLORS.YELLOW .. "Próxima etapa: Instalação do Ambiente Gráfico" .. envs.COLORS.RESET)
    print()
  else
    print()
    aux.pf("Pulando configurações do sistema...", "warn")
    return
  end

  aux.sequence()

  if aux.confirm("Você gostaria de iniciar a instalação do ambiente gráfico?") then
    if not desktopInstall.install_environment() then
      aux.pf("Erro ao selecionar e instalar o ambiente gráfico", "error")
    end

    print()
    print(envs.COLORS.YELLOW .. "Próxima etapa: Instalação das ferramentas" .. envs.COLORS.RESET)
    print()
  else
    print()
    aux.pf("Pulando instalação do ambiente gráfico...", "warn")
    return
  end

  aux.sequence()

  if aux.confirm("Deseja iniciar a instalação dos pacotes do ecosistema?") then
    if not ecosystem.packages_install() then
      aux.pf("Erro ao instalar pacotes do ecosistema", "error")
    end

    print()
    print(envs.COLORS.YELLOW .. "Próxima etapa: Configurações do desktop" .. envs.COLORS.RESET)
    print()
  else
    print()
    aux.pf("Pulando instalação dos pacotes do ecosistema...", "warn")
    return
  end

  aux.show_congratulation()
end

--- ============================================================================
--- 🚀 EXECUÇÃO
--- ============================================================================

main()